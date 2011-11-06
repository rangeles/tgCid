#import "CFCoreTelephony.h"
@class NSBundle, IncomingCallView, NSNumber, UIView;

@interface CallManager : NSObject
{
    NSBundle *resource;
    id controller;
    IncomingCallView *view;
}
- (void)setupForController:(id)controller withCall:(CTCallRef)call;
- (void)_teardown;
- (void)teardownForController:(id)controller;
- (void)setForController:(id)controller ABUID:(NSNumber *)abuid;
- (UIView *)viewForController:(id)controller;
- (BOOL)hasViewForController:(id)controller;
@end
