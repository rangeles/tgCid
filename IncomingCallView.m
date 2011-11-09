#import "ImageLabel.h"
#import "UIImage-Private.h"
#import "UIView-Center.h"
#import "IncomingCallView.h"

@implementation IncomingCallView

- (id)initWithDefaultFrameAndBundle:(NSBundle *)resourceBundle {
    if ((self = [super initWithFrame:CGRectMake(0, 52, 320, 42)])) {
        [self setOpaque:NO];
        isLabeled = NO;

        pending = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:pending];
        [pending centerBothAxes];

        UIImage *callerIcon = [UIImage imageNamed:@"callerIcon" inBundle:resourceBundle];
        UIImage *locationIcon = [UIImage imageNamed:@"locationIcon" inBundle:resourceBundle];

        caller = [[ImageLabel alloc] initWithFrame:[self bounds] withImage:callerIcon];
        [self addSubview:caller];

        location = [[ImageLabel alloc] initWithFrame:[self bounds] withImage:locationIcon];
        [self addSubview:location];

        [callerIcon release];
        [locationIcon release];
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

// Looks rather bloated
- (void)setCaller:(NSString *)aCaller andLocation:(NSString *)aLocation {
    [caller setLabel:aCaller];
    //[caller sizeToFit];
    [location setLabel:aLocation];
    //[location sizeToFit];

    [pending stopAnimating];
    [pending removeFromSuperview];

    isLabeled = YES;
    [self setNeedsLayout];
    [self fadeInSubview:0];
}

@end
