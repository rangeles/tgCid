@class ImageLabel, UIActivityIndicatorView;

@interface IncomingCallView : UIView
{
    BOOL isLabeled;
    NSString *locationFallback;
    UIActivityIndicatorView *pending;
    ImageLabel *caller;
    ImageLabel *location;
}
- (id)initWithDefaultFrameAndBundle:(NSBundle *)resourceBundle;
- (void)fadeInSubview:(NSUInteger)index;
- (void)fadeOutSubview:(NSUInteger)index;
- (void)setLocationFallback:(NSString *)location;
- (void)setCallerAndFinalize:(NSString *)caller;
@end
