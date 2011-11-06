#import "ConstrictedUILabel.h"

@implementation ConstrictedUILabel

@synthesize constrictedWidth, constrictedHeight;

- (id)init {
    if ((self = [super init])) {
        constrictedWidth = constrictedHeight = CGFLOAT_MAX;
        [self setAdjustsFontSizeToFitWidth:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTextColor:[UIColor clearColor]];
        [self setFont:[UIFont fontWithName:@"Helvetica" size:22]];
    }

    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize ret = [super sizeThatFits:size];
    if (ret.width > constrictedWidth) {
        ret = CGSizeMake(constrictedWidth, ret.height);
    }
    if (ret.height > constrictedHeight) {
        ret = CGSizeMake(ret.width, constrictedHeight);
    }
    return ret;
}

@end
