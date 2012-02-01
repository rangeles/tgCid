#import <CommonCrypto/CommonDigest.h>
#import "Debug.h"
#import "CallManager.h"
#import "IncomingCallView.h"

@implementation CallManager

+ (NSURLRequest *)createRequestForNumber:(NSString *)aNumber {
    char *appID = "8pR9w";
    char *appVer = "1";
    NSTimeInterval nonce = [[NSDate date] timeIntervalSince1970];

    char udidBuffer[64];
    char secretBuffer[256];
    unsigned char md5Buffer[16];

    int i, length;
    for (i = length = 0; i < 5; i++) {
        length += sprintf(udidBuffer + length, "%08x", arc4random());
    }

    length = sprintf(secretBuffer, "app_id=%sapp_ver=%sdevice_id=%snonce=%ff3e0ed061a7c4fe48676ddd25838d40c", appID, appVer, udidBuffer, nonce);
    CC_MD5(secretBuffer, length, md5Buffer);

    for (i = length = 0; i < 16; i++) {
        length += sprintf(secretBuffer + length, "%02X", md5Buffer[i]);
    }

    NSString *urlString = [NSString stringWithFormat:@"http://gadgets.whitepages.com/wpapi/1.0/reverse_phone?app_ver=%s&device_id=%s&nonce=%f&app_id=%s&phone=%@&format=json&secret=%s", appVer, udidBuffer, nonce, appID, aNumber, secretBuffer];

    NSURL *url = [NSURL URLWithString:urlString];

    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:7];

    return urlRequest;
}

+ (CallManager *)sharedManager {
    static CallManager *sharedManager;

    if (!sharedManager) {
        sharedManager = [[CallManager alloc] init];
    }

    return sharedManager;
}

- (id)init {
    if ((self = [super init])) {
        resource = [[NSBundle alloc] initWithPath:@"/Library/Application Support/tgCid"];
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
    NSString *address = [CTCallCopyAddress(NULL, call) autorelease];
    NSString *countryCode = [CTCallCopyCountryCode(NULL, call) autorelease];
    if (address != nil && countryCode != nil && controller == nil) {
        // U.S. MCCs = 310-316 (inclusive)
        if ([countryCode integerValue] >= 310 && [countryCode integerValue] <= 316) {
            request = [CallManager createRequestForNumber:address];
            view = [[IncomingCallView alloc] initWithDefaultFrameAndBundle:resource];
            controller = aController;
        }
    }
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
        DEBUG_LOG((@"tgCid: Lookup request to be fetched: %@", request));
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *rData, NSError *rError){
            NSString *caller = @"Unknown";
            NSString *location = @"Unknown";

            if (rData != nil) {
                DEBUG_LOG((@"tgCid: Lookup request returned: %@", [[[NSString alloc] initWithData:rData encoding:NSUTF8StringEncoding] autorelease]));
                NSError *jError;
                NSDictionary *jData = [NSJSONSerialization JSONObjectWithData:rData options:0 error:&jError];

                if (jData != nil) {
                    NSDictionary *firstListing = [[jData objectForKey:@"listings"] objectAtIndex:0];
                    NSString *jCaller = [firstListing objectForKey:@"displayname"];
                    NSDictionary *jAddress = [firstListing objectForKey:@"address"];
                    NSString *jCity = [jAddress objectForKey:@"city"];
                    NSString *jState = [jAddress objectForKey:@"state"];

                    if (jCaller != nil) {
                        caller = jCaller;
                    }

                    if (jCity != nil && jState != nil) {
                        location = [NSString stringWithFormat:@"%@, %@", jCity, jState];
                    }
                }
            } else {
                DEBUG_LOG((@"tgCid: Lookup request errored: %@", rError));
            }

            SEL selector;
            NSMethodSignature *signature;
            NSInvocation *invocation;

            selector = @selector(setCaller:andLocation:);
            signature = [IncomingCallView instanceMethodSignatureForSelector:selector];
            invocation = [NSInvocation invocationWithMethodSignature:signature];

            [invocation setSelector:selector];
            [invocation setTarget:view];
            [invocation setArgument:&caller atIndex:2];
            [invocation setArgument:&location atIndex:3];
            [invocation retainArguments];

            [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:NO];
        }];
    }
}

- (UIView *)viewForController:(id)aController {
    return controller == aController ? view : nil;
}

- (BOOL)hasViewForController:(id)aController {
    return [self viewForController:aController] != nil;
}

@end
