#import "CallManager.h"
#import "IncomingCallView.h"

@implementation CallManager

- (id)init {
    if ((self = [super init])) {
        resource = [NSBundle bundleWithPath:@"/Library/Application Support/tgCid"];
    }

    return self;
}

- (void)dealloc {
    [view release];
    [resource release];
    [super dealloc];
}

- (void)setupForController:(id)aController withCall:(CTCallRef)call {
    NSString *address = CTCallCopyAddress(NULL, call);
    NSString *countryCode = CTCallCopyCountryCode(NULL, call);
    if (address != nil && countryCode != nil && controller == nil) {
        // U.S. MCCs = 310-316 (inclusive)
        if ([countryCode integerValue] >= 310 && [countryCode integerValue] <= 316) {
            // Prepare a nsurlrequest
            view = [[IncomingCallView alloc] initWithDefaultFrameAndBundle:resource];
            controller = aController;
        }
    }
    [address release];
    [countryCode release];
}

- (void)teardownForController:(id)aController {
    if (controller == aController) {
        [view release];
        controller = view = nil;
    }
}

- (void)demo {
    [view setCaller:@"John Smith" andLocation:@"United States"];
}

- (void)setForController:(id)aController ABUID:(NSNumber *)abuid {
    if (abuid != nil) {
        [self teardownForController:aController];
    } else if (controller == aController) {
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(demo) userInfo:nil repeats:NO];
    }
}

- (UIView *)viewForController:(id)aController {
    return controller == aController ? view : nil;
}

- (BOOL)hasViewForController:(id)aController {
    return [self viewForController:aController] != nil;
}

@end
