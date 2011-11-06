#import "CFCoreTelephony.h"
#import "IncomingCallView.h"
#import "CallManager.h"

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
    NSString *number = CTCallCopyAddress(NULL, call);
    view = [[IncomingCallView alloc] initWithFrame:CGRectMake(0, 52, 320, 42)];
    // Set operation for number
    [number release];
}

- (void)_teardown {
    controller = nil;
    [view release];
    view = nil;
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
