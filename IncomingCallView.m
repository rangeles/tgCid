#import "ImageLabel.h"
#import "UIImage-Private.h"
#import "UIView-Center.h"
#import "IncomingCallView.h"

@implementation IncomingCallView

- (id)initWithFrame:(CGRect)frame resource:(NSBundle *)resource {
    if ((self = [super initWithFrame:frame])) {
        [self setOpaque:NO];
        isLabeled = NO;

        pending = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:pending];
        [pending centerBothAxes];

        caller = [[ImageLabel alloc] initWithFrame:[self bounds] withImage:[[UIImage imageNamed:@"callerIcon" inBundle:resource] autorelease]];
        [self addSubview:caller];
        location = [[ImageLabel alloc] initWithFrame:[self bounds] withImage:[[UIImage imageNamed:@"locationIcon" inBundle:resource] autorelease]];
        [self addSubview:location];
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
        [pending removeFromSuperview];
        [self fadeInSubview:0];
    } else {
        [pending startAnimating];
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

@end
