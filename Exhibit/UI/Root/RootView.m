//
// Created by Simon de Carufel on 15-06-19.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <MCUIViewLayout/UIView+MCLayout.h>
#import "RootView.h"

@interface RootView ()
@property (nonatomic) BOOL viewDidAppearOnce;
@property (nonatomic) CGSize referenceSize;
@property (nonatomic) UIUserInterfaceIdiom idiom;
@end

@implementation RootView

- (instancetype)initWithUserInterfaceIdiom:(UIUserInterfaceIdiom)idiom
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.backgroundColor = [UIColor blackColor];
        self.idiom = idiom;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (!CGSizeEqualToSize(self.referenceSize, self.mc_size)) {
        self.referenceSize = self.mc_size;
        [self.leftPanelView mc_setPosition:MCViewPositionTopLeft withMargins:UIEdgeInsetsZero size:CGSizeMake(320, self.mc_height)];

        CGFloat rightPanelWidth = self.mc_width - (self.idiom == UIUserInterfaceIdiomPad ? 320 : 0);

        [self.rightPanelView mc_setPosition:MCViewPositionTopRight withMargins:UIEdgeInsetsZero size:CGSizeMake(rightPanelWidth, self.mc_height)];
    }
}

- (void)setLeftPanelView:(UIView *)leftPanelView
{
    if (self.leftPanelView) {
        [self.leftPanelView removeFromSuperview];
    }

    _leftPanelView = leftPanelView;
    [self addSubview:self.leftPanelView];
}

- (void)setRightPanelView:(UIView *)rightPanelView
{
    if (self.rightPanelView) {
        [self.rightPanelView removeFromSuperview];
    }

    _rightPanelView = rightPanelView;
    [self addSubview:self.rightPanelView];
}

- (void)preparePanelsForDisplay
{
    if (!self.viewDidAppearOnce) {
        self.rightPanelView.alpha = 0;
        self.leftPanelView.transform = CGAffineTransformMakeTranslation(-self.leftPanelView.mc_width, 0);
    }
}

- (void)displayLeftPanelWithDelay:(CGFloat)delay
{
    self.viewDidAppearOnce = YES;
    [UIView animateWithDuration:0.5f delay:delay usingSpringWithDamping:1000 initialSpringVelocity:0 options:0 animations:^{
        self.leftPanelView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)displayRightPanelWithDelay:(CGFloat)delay
{
    [UIView animateWithDuration:1.0f delay:delay options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
        self.rightPanelView.alpha = 1;
    } completion:nil];
}

- (void)hideLeftPanel:(void (^)(void))completion
{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.leftPanelView.transform = CGAffineTransformMakeTranslation(-self.leftPanelView.mc_width, 0);
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

- (void)hideRightPanel:(void (^)(void))completion
{
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.rightPanelView.alpha = 0;
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}
@end