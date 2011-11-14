#import "CFCoreTelephony.h"
@class NSBundle, IncomingCallView, NSNumber, UIView, NSOperationQueue, NSURLRequest;

@interface CallManager : NSObject
{
    NSBundle *resource;
    NSOperationQueue *queue;
    id controller;
    IncomingCallView *view;
    NSURLRequest *request;
}
+ (NSURLRequest *)prepareRequestForNumber:(NSString *)number;
- (void)setupForController:(id)controller withCall:(CTCallRef)call;
- (void)teardownForController:(id)controller;
- (void)setForController:(id)controller ABUID:(NSNumber *)abuid;
- (UIView *)viewForController:(id)controller;
- (BOOL)hasViewForController:(id)controller;
@end
