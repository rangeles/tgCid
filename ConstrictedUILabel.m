#import "ConstrictedUILabel.h"

@implementation ConstrictedUILabel

@synthesize constrictedWidth, constrictedHeight;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        constrictedWidth = constrictedHeight = CGFLOAT_MAX;
        [self setAdjustsFontSizeToFitWidth:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTextColor:[UIColor whiteColor]];
        [self setFont:[UIFont fontWithName:@"Helvetica" size:22]];
    }

    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize orig = [super sizeThatFits:size];
    if (orig.width > constrictedWidth) {
        orig = CGSizeMake(constrictedWidth, orig.height);
    }
    if (orig.height > constrictedHeight) {
        orig = CGSizeMake(orig.width, constrictedHeight);
    }
    return orig;
}

@end
