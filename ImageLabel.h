@class ConstrictedUILabel, UIImageView, UIImage, NSString;

@interface ImageLabel : UIView
{
    UIImageView *image;
    ConstrictedUILabel *label;
}
- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)image;
- (void)setLabel:(NSString *)label;
@end
