//
// Created by Simon de Carufel on 15-06-04.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "MomentViewCell.h"
#import "UIView+MCLayout.h"

@interface MomentViewCell ()
@property (nonatomic, readwrite) UIImageView *imageView;
@end

@implementation MomentViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView = [UIImageView new];
        self.imageView.alpha = 0.4f;
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.imageView mc_setPosition:MCViewPositionCenters withMargins:UIEdgeInsetsZero size:CGSizeMake(self.mc_width - 10, self.mc_height - 10)];
}

- (void)setSelected:(BOOL)selected
{
    self.backgroundColor = selected ? [UIColor whiteColor] : [UIColor clearColor];
    self.imageView.alpha = selected ? 1 : 0.4f;
}


- (void)prepareForReuse
{
    self.imageView.alpha = 0.4f;
    self.backgroundColor = [UIColor clearColor];
}
@end