#import "ImageLabel.h"
#import "UIImage-Private.h"
#import "UIView-Center.h"
#import "IncomingCallView.h"

@implementation IncomingCallView

- (id)initWithDefaultFrameAndBundle:(NSBundle *)resourceBundle {
    if ((self = [super initWithFrame:CGRectMake(3, 52, 314, 42)])) {
        isLabeled = NO;

        pending = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:pending];

        caller = [[ImageLabel alloc] initWithFrame:[self bounds] withImage:[UIImage imageNamed:@"callerIcon" inBundle:resourceBundle]];
        [self addSubview:caller];

        location = [[ImageLabel alloc] initWithFrame:[self bounds] withImage:[UIImage imageNamed:@"locationIcon" inBundle:resourceBundle]];
        [self addSubview:location];

        [self setNeedsLayout];
    }

    return self;
}

- (void)dealloc {
    [pending release];
	[caller release];
	[location release];
	[super dealloc];
}

- (void)didMoveToSuperview {
    if (isLabeled) {
        [self fadeInSubview:0];
    } else {
        [pending startAnimating];
    }
}

- (void)layoutSubviews {
    for (UIView *subview in [self subviews]) {
        [subview centerBothAxes];
    }
}

- (void)fadeInSubview:(NSUInteger)index {
    UIView *current = [[self subviews] objectAtIndex:index];
    [UIView animateWithDuration:1 delay:0.5 options:0 animations:^{ [current setAlpha:1]; } completion:^(BOOL finished){ if (finished) [self fadeOutSubview:index]; }];
}

- (void)fadeOutSubview:(NSUInteger)index {
    UIView *current = [[self subviews] objectAtIndex:index];
    [UIView animateWithDuration:1 delay:1 options:0 animations:^{ [current setAlpha:0]; } completion:^(BOOL finished){ if (finished) [self fadeInSubview:(index+1)%[[self subviews] count]]; }];
}

- (void)setCaller:(NSString *)aCaller andLocation:(NSString *)aLocation {
    [caller setLabel:aCaller];
    [location setLabel:aLocation];

    [pending stopAnimating];
    [pending removeFromSuperview];

    isLabeled = YES;
    [self setNeedsLayout];
    [self fadeInSubview:0];
}

@end
