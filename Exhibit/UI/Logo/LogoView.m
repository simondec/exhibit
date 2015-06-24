//
// Created by Simon de Carufel on 15-06-24.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <MCUIViewLayout/UIView+MCLayout.h>
#import "LogoView.h"

@interface LogoView ()
@property (nonatomic) UIImageView *nwadImageView;
@property (nonatomic) UILabel *exhibitLabel;
@end

@implementation LogoView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];

        self.nwadImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NWADLogoPicto"]];
        [self addSubview:self.nwadImageView];

        self.exhibitLabel = [UILabel new];
        self.exhibitLabel.text = @"Exhibit";
        self.exhibitLabel.font = [UIFont fontWithName:@"Lato-Light" size:40];
        self.exhibitLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.exhibitLabel];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(130, 130);
}

- (void)layoutSubviews
{
    [self.nwadImageView mc_setPosition:MCViewPositionTopHCenter withMargins:UIEdgeInsetsZero size:CGSizeMake(70, 70)];
    [self.exhibitLabel mc_setPosition:MCViewPositionBottomHCenter withMargins:UIEdgeInsetsZero size:[self.exhibitLabel sizeThatFits:CGSizeZero]];
}
@end