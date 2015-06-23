//
// Created by Simon de Carufel on 15-06-19.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <MCUIViewLayout/UIView+MCLayout.h>
#import "RootView.h"

@interface RootView ()
@property (nonatomic) BOOL viewDidAppearOnce;
@property (nonatomic) CGSize referenceSize;
@end

@implementation RootView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (!CGSizeEqualToSize(self.referenceSize, self.mc_size)) {
        self.referenceSize = self.mc_size;
        [self.leftPaneView mc_setPosition:MCViewPositionTopLeft withMargins:UIEdgeInsetsZero size:CGSizeMake(320, self.mc_height)];
        [self.rightPaneView mc_setPosition:MCViewPositionTopRight withMargins:UIEdgeInsetsZero size:CGSizeMake(self.mc_width - 320, self.mc_height)];
    }
}

- (void)setLeftPaneView:(UIView *)leftPaneView
{
    if (self.leftPaneView) {
        [self.leftPaneView removeFromSuperview];
    }

    _leftPaneView = leftPaneView;
    [self addSubview:self.leftPaneView];
}

- (void)setRightPaneView:(UIView *)rightPaneView
{
    if (self.rightPaneView) {
        [self.rightPaneView removeFromSuperview];
    }

    _rightPaneView = rightPaneView;
    [self addSubview:self.rightPaneView];
}

- (void)preparePanelsForDisplay
{
    if (!self.viewDidAppearOnce) {
        self.rightPaneView.alpha = 0;
        self.leftPaneView.transform = CGAffineTransformMakeTranslation(-self.leftPaneView.mc_width, 0);
    }
}

- (void)displayPanels
{
    self.viewDidAppearOnce = YES;
    [UIView animateWithDuration:0.5f delay:0.5f usingSpringWithDamping:1000 initialSpringVelocity:0 options:0 animations:^{
        self.leftPaneView.transform = CGAffineTransformIdentity;
    } completion:nil];

    [UIView animateWithDuration:1.0f delay:1.0f options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
        self.rightPaneView.alpha = 1;
    } completion:nil];

}

- (void)hidePanels:(void (^)(void))completion
{
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.rightPaneView.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.leftPaneView.transform = CGAffineTransformMakeTranslation(-self.leftPaneView.mc_width, 0);
        } completion:^(BOOL finished) {
            if (completion) completion();
        }];
    }];
}
@end