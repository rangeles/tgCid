#import <CommonCrypto/CommonDigest.h>
#import "CallManager.h"
#import "IncomingCallView.h"

@implementation CallManager

+ (NSURLRequest *)prepareRequestForNumber:(NSString *)aNumber {
    char *appID = "8pR9w";
    char *appVer = "1";

    NSDate *date = [NSDate date];
    NSTimeInterval nonce = [date timeIntervalSince1970];
    [date release];

    char udidBuffer[64];
    char secretBuffer[256];
    unsigned char md5Buffer[16];

    snprintf(udidBuffer, sizeof(udidBuffer), "%08x%08x%08x%08x%08x", arc4random(), arc4random(), arc4random(), arc4random(), arc4random());

    int secretBufferLen = snprintf(secretBuffer, sizeof(secretBuffer), "app_id=%sapp_ver=%sdevice_id=%snonce=%ff3e0ed061a7c4fe48676ddd25838d40c", appID, appVer, udidBuffer, nonce);
    CC_MD5(secretBuffer, secretBufferLen, md5Buffer);

    NSString *urlString = [NSString stringWithFormat:@"http://gadgets.whitepages.com/wpapi/1.0/reverse_phone?app_ver=%s&device_id=%s&nonce=%f&app_id=%s&phone=%@&format=json&secret=%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", appVer, udidBuffer, nonce, appID, aNumber, md5Buffer[0], md5Buffer[1], md5Buffer[2], md5Buffer[3], md5Buffer[4], md5Buffer[5], md5Buffer[6], md5Buffer[7], md5Buffer[8], md5Buffer[9], md5Buffer[10], md5Buffer[11], md5Buffer[12], md5Buffer[13], md5Buffer[14], md5Buffer[15]];

    NSURL *url = [NSURL URLWithString:urlString];

    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:3];

    [url release];
    [urlString release];

    return request;
}

- (id)init {
    if ((self = [super init])) {
        resource = [NSBundle bundleWithPath:@"/Library/Application Support/tgCid"];
        queue = [[NSOperationQueue alloc] init];
    }

    return self;
}

- (void)dealloc {
    [resource release];
    [queue release];
    [view release];
    [request release];
    [super dealloc];
}

- (void)setupForController:(id)aController withCall:(CTCallRef)call {
    NSString *address = CTCallCopyAddress(NULL, call);
    NSString *countryCode = CTCallCopyCountryCode(NULL, call);
    if (address != nil && countryCode != nil && controller == nil) {
        // U.S. MCCs = 310-316 (inclusive)
        if ([countryCode integerValue] >= 310 && [countryCode integerValue] <= 316) {
            request = [CallManager prepareRequestForNumber:address];
            view = [[IncomingCallView alloc] initWithDefaultFrameAndBundle:resource];
            controller = aController;
        }
    }
    [address release];
    [countryCode release];
}

- (void)teardownForController:(id)aController {
    if (controller == aController) {
        [request release];
        [view release];
        controller = nil;
        request = nil;
        view = nil;
    }
}

- (void)setForController:(id)aController ABUID:(NSNumber *)abuid {
    if (abuid != nil) {
        [self teardownForController:aController];
    } else if (controller == aController) {
        //[NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){ if (data != nil) { } }];
    }
}

- (UIView *)viewForController:(id)aController {
    return controller == aController ? view : nil;
}

- (BOOL)hasViewForController:(id)aController {
    return [self viewForController:aController] != nil;
}

@end
