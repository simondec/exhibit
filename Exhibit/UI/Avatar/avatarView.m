//
// Created by Simon de Carufel on 15-06-04.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "AvatarView.h"
#import "UIImage+MCImageGeneration.h"
#import "UIImage+MCRounded.h"
#import "UIView+MCLayout.h"

@interface AvatarView ()
@property (nonatomic) UIImageView *ringImageView;
@property (nonatomic) UIImageView *profileImageView;
@end

@implementation AvatarView
- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame borderWidth:6.0f];
}

- (instancetype)initWithFrame:(CGRect)frame borderWidth:(CGFloat)borderWidth {
    return [self initWithFrame:frame borderWidth:borderWidth borderColor:[UIColor colorWithWhite:1 alpha:0.3f]];
}

- (instancetype)initWithFrame:(CGRect)frame borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    if (self = [super initWithFrame:frame]) {
        if (borderWidth > 0) {
            UIImage *ringImage = [UIImage mc_generateCircleImageOfSize:CGRectInset(self.bounds, borderWidth / 2.0f, borderWidth / 2.0f).size fillColor:[UIColor clearColor] strokeColor:borderColor strokeWidth:borderWidth];
            self.ringImageView = [[UIImageView alloc] initWithImage:ringImage];
            [self addSubview:self.ringImageView];
        }

        self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, borderWidth, borderWidth)];
        self.profileImageView.layer.minificationFilter = kCAFilterTrilinear;
        [self addSubview:self.profileImageView];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    self.profileImageView.image = [image imageWithRoundedCornersRadius:(image.size.width / 2.0f)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.ringImageView mc_setPosition:MCViewPositionCenters];
    [self.profileImageView mc_setPosition:MCViewPositionCenters];
}
@end