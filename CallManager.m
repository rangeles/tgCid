#import "Debug.h"
#import "CallManager.h"
#import "IncomingCallView.h"

@implementation CallManager

+ (NSURLRequest *)createRequestForNumber:(NSString *)aNumber {
    NSString *urlString = [NSString stringWithFormat:@"http://freecnam.org/dip?q=%@", aNumber];
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

            if (rData != nil && [rData length] > 0) {
                caller = [[[NSString alloc] initWithData:rData encoding:NSUTF8StringEncoding] autorelease];
                DEBUG_LOG((@"tgCid: Lookup request returned: %@", caller));
            } else if (rError != nil) {
                DEBUG_LOG((@"tgCid: Lookup request errored: %@", rError));
            }

            [view performSelectorOnMainThread:@selector(setCallerAndFinalize:) withObject:caller waitUntilDone:NO];
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
