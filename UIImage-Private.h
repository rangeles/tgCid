@class NSString, NSBundle;

@interface UIImage (private)
+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle;
@end
