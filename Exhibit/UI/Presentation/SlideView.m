//
// Created by Simon de Carufel on 15-06-04.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <MCUIViewLayout/UIView+MCLayout.h>
#import "SlideView.h"
#import "Moment.h"

@interface SlideView ()
@property (nonatomic) UIView *momentImageContainerView;
@property (nonatomic) UIImageView *momentImageView;
@property (nonatomic) UIView *momentTitleContainerView;
@property (nonatomic) UILabel *momentTitle;
@property (nonatomic) CGSize referenceSize;
@property (nonatomic) BOOL moveLeft;
@property (nonatomic) Moment *moment;
@end

@implementation SlideView
- (instancetype)initWithMoment:(Moment *)moment moveLeft:(BOOL)moveLeft
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.moment = moment;
        self.moveLeft = moveLeft;

        self.momentImageContainerView = [UIView new];
        [self.momentImageContainerView setBackgroundColor:[UIColor whiteColor]];
        self.momentImageContainerView.alpha = 0;
        self.momentImageContainerView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.momentImageContainerView.layer.shouldRasterize = YES;
        [self addSubview:self.momentImageContainerView];

        self.momentImageView = [[UIImageView alloc] initWithImage:moment.media];
        [self.momentImageContainerView addSubview:self.momentImageView];

        self.momentTitleContainerView = [UIView new];
        self.momentTitleContainerView.clipsToBounds = YES;
        [self addSubview:self.momentTitleContainerView];

        self.momentTitle = [UILabel new];
        self.momentTitle.numberOfLines = 0;
        self.momentTitle.text = moment.momentDescription;
        self.momentTitle.textColor = [UIColor whiteColor];
        self.momentTitle.font = [UIFont fontWithName:@"Lato-Light" size:30];
        self.momentTitle.shadowColor = [UIColor colorWithWhite:0 alpha:0.2f];
        self.momentTitle.shadowOffset = CGSizeMake(0, 1);
        self.momentTitle.textAlignment = moveLeft ? NSTextAlignmentLeft : NSTextAlignmentRight;
        [self.momentTitleContainerView addSubview:self.momentTitle];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!CGSizeEqualToSize(self.mc_size, self.referenceSize)) {
        self.referenceSize = self.mc_size;

        CGSize momentTitleSize = [self.momentTitle sizeThatFits:CGSizeMake(320 * 1.5f, MAXFLOAT)];
        CGFloat horizontalMargin = floorf((self.mc_width - 320 - momentTitleSize.width - 40.0f) / 2.0f);

        if (self.moveLeft) {
            [self.momentImageContainerView mc_setPosition:MCViewPositionVCenterLeft withMargins:UIEdgeInsetsMake(0, horizontalMargin, 0, 0) size:CGSizeMake(320 + 20, 320 + 20)];
            [self.momentTitleContainerView mc_setRelativePosition:MCViewRelativePositionToTheRightCentered toView:self.momentImageContainerView withMargins:UIEdgeInsetsMake(0, 40.0f, 0, 0) size:CGSizeMake(momentTitleSize.width, self.mc_height)];
            [self.momentTitle mc_setPosition:MCViewPositionVCenterLeft withMargins:UIEdgeInsetsZero size:momentTitleSize];
        } else {
            [self.momentImageContainerView mc_setPosition:MCViewPositionVCenterRight withMargins:UIEdgeInsetsMake(0, 0, 0, horizontalMargin) size:CGSizeMake(320 + 20, 320 + 20)];
            [self.momentTitleContainerView mc_setRelativePosition:MCViewRelativePositionToTheLeftCentered toView:self.momentImageContainerView withMargins:UIEdgeInsetsMake(0, 0, 0, 40.0f) size:CGSizeMake(momentTitleSize.width, self.mc_height)];
            [self.momentTitle mc_setPosition:MCViewPositionVCenterRight withMargins:UIEdgeInsetsZero size:momentTitleSize];
        }
    }

    [self.momentImageView mc_setPosition:MCViewPositionCenters withMargins:UIEdgeInsetsZero size:CGSizeMake(320, 320)];
}

//------------------------------------------------------------------------------
#pragma mark - Public Methods
//------------------------------------------------------------------------------

- (void)presentMoment:(void (^)(void))completion
{
    [self layoutIfNeeded];

    CGFloat rotationAngle = self.moveLeft ? -M_PI_2 : M_PI_2;
    CGFloat titleTranslationX = self.moveLeft ? -self.momentTitle.mc_width : self.momentTitle.mc_width;

    CATransform3D rotation = CATransform3DMakeRotation(rotationAngle, 0, 1, 0);
    rotation.m34 = -1.0f/200.0f;
    self.momentImageContainerView.layer.transform = rotation;

    self.momentTitle.transform = CGAffineTransformMakeTranslation(titleTranslationX, 0);


    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.momentImageContainerView.alpha = 1;
    } completion:^(BOOL finished) {

    }];

    [UIView animateWithDuration:0.4f delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:0 animations:^{
        self.momentImageContainerView.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];

    [UIView animateWithDuration:0.4f delay:0.5f usingSpringWithDamping:3000 initialSpringVelocity:0 options:0 animations:^{
        self.momentTitle.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];

}

- (void)dismissMoment:(void (^)(void))completion
{
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.momentImageView.alpha = 0;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}
@end