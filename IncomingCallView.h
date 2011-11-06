@class ImageLabel, UIActivityIndicatorView;

@interface IncomingCallView : UIView
{
    BOOL isLabeled;
    UIActivityIndicatorView *pending;
    ImageLabel *caller;
    ImageLabel *location;
}
- (void)fadeInSubview:(NSUInteger)index;
- (void)fadeOutSubview:(NSUInteger)index;
@end
