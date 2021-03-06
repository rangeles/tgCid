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
+ (NSURLRequest *)createRequestForNumber:(NSString *)number;
+ (CallManager *)sharedManager;
- (void)setupForController:(id)controller withCall:(CTCallRef)call;
- (void)teardownForController:(id)controller;
- (void)setForController:(id)controller ABUID:(NSNumber *)abuid;
- (IncomingCallView *)viewForController:(id)controller;
- (BOOL)hasViewForController:(id)controller;
@end
