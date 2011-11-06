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
    [self _teardown];
    [resource release];
    [super dealloc];
}

- (void)setupForController:(id)aController withCall:(CTCallRef)call {
    if (controller != nil) {
        [self _teardown];
    }

    NSString *address = CTCallCopyAddress(NULL, call);
    NSString *countryCode = CTCallCopyCountryCode(NULL, call);

    view = [[IncomingCallView alloc] initWithDefaultFrameAndBundle:resource];
    controller = aController;
    // Set operation for number
    [number release];
    }
}

- (void)_teardown {
    [view release];
    controller = view = nil;
}

- (void)teardownForController:(id)aController {
    if (controller == aController) {
        [self _teardown];
    }
}

- (void)setForController:(id)aController ABUID:(NSNumber *)abuid {
    if (abuid != nil) {
        [self teardownForController:aController];
    } else if (controller == aController) {
        // start operation
    }
}

- (UIView *)viewForController:(id)aController {
    return controller == aController ? view : nil;
}

- (BOOL)hasViewForController:(id)aController {
    return [self viewForController:aController] != nil;
}

@end
