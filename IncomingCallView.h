@class ImageLabel, UIActivityIndicatorView;

@interface IncomingCallView : UIView
{
    BOOL isLabeled;
    UIActivityIndicatorView *pending;
    ImageLabel *caller;
    ImageLabel *location;
}
- (id)initWithDefaultFrameAndBundle:(NSBundle *)resourceBundle;
- (void)fadeInSubview:(NSUInteger)index;
- (void)fadeOutSubview:(NSUInteger)index;
- (void)setCaller:(NSString *)caller andLocation:(NSString *)location;
@end
