#import "ImageLabel.h"
#import "ConstrictedUILabel.h"
#import "UIView-Center.h"

#define IMAGELABEL_SPACING 7

@implementation ImageLabel

- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)aImage {
    if ((self = [super initWithFrame:frame])) {
        [self setOpaque:NO];
        [self setAlpha:0];

        image = [[UIImageView alloc] initWithImage:aImage];
        [self addSubview:image];

        label = [[ConstrictedUILabel alloc] initWithFrame:CGRectMake([image frame].size.width + IMAGELABEL_SPACING, 0, 0, 0)];
        [label setConstrictedWidth:([self frame].size.width - [image frame].size.width - IMAGELABEL_SPACING)];
        [self addSubview:label];
    }

    return self;
}

- (void)dealloc {
    [image release];
    [label release];
    [super dealloc];
}

- (void)layoutSubviews {
    for (UIView *subview in [self subviews]) {
        [subview centerHorizontalAxis];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake([label frame].origin.x + [label frame].size.width, size.height);
}

- (void)setLabel:(NSString *)aLabel {
    [label setText:aLabel];
    [label sizeToFit];
    [self sizeToFit];
}

@end
