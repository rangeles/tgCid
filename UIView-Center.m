#import "UIView-Center.h"

@implementation UIView (center)

- (void)centerHorizontalAxis {
    if ([self superview]) {
        [self setCenter:CGPointMake([self center].x, [[self superview] frame].size.height/2)];
        [self setFrame:CGRectIntegral([self frame])];
    }
}

- (void)centerVerticalAxis {
    if ([self superview]) {
        [self setCenter:CGPointMake([[self superview] frame].size.width/2, [self center].y)];
        [self setFrame:CGRectIntegral([self frame])];
    }
}

- (void)centerBothAxes {
    [self centerHorizontalAxis];
    [self centerVerticalAxis];
}

@end
