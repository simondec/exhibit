//
// Created by Simon de Carufel on 15-06-04.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <MCUIViewLayout/UIView+MCLayout.h>
#import "SlideView.h"
#import "Moment.h"
#import "AvatarView.h"

@interface SlideView ()
@property (nonatomic) UIView *momentImageContainerView;
@property (nonatomic) UIImageView *momentImageView;
@property (nonatomic) UIView *momentInfoContainerClipView;
@property (nonatomic) UIView *momentInfoContainerView;
@property (nonatomic) UILabel *momentTitle;
@property (nonatomic) AvatarView *authorAvatar;
@property (nonatomic) UILabel *momentInfo;

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
        self.momentImageContainerView.layer.allowsGroupOpacity = YES;
        [self addSubview:self.momentImageContainerView];

        self.momentImageView = [[UIImageView alloc] initWithImage:moment.media];
        [self.momentImageContainerView addSubview:self.momentImageView];

        self.momentInfoContainerClipView = [UIView new];
        self.momentInfoContainerClipView.clipsToBounds = YES;
        [self addSubview:self.momentInfoContainerClipView];

        self.momentInfoContainerView = [UIView new];
        [self.momentInfoContainerClipView addSubview:self.momentInfoContainerView];

        self.momentTitle = [UILabel new];
        self.momentTitle.numberOfLines = 0;
        self.momentTitle.text = moment.momentDescription;
        self.momentTitle.textColor = [UIColor whiteColor];
        self.momentTitle.font = [UIFont fontWithName:@"Lato-Medium" size:30];
        self.momentTitle.shadowColor = [UIColor colorWithWhite:0 alpha:0.2f];
        self.momentTitle.shadowOffset = CGSizeMake(0, 1);
        self.momentTitle.textAlignment = moveLeft ? NSTextAlignmentLeft : NSTextAlignmentRight;
        [self.momentInfoContainerView addSubview:self.momentTitle];

//        self.authorAvatar = [[AvatarView alloc] initWithFrame:CGRectMake(0, 0, 40, 40) borderWidth:4 borderColor:[UIColor whiteColor]];
//        [self.authorAvatar setImage:moment.authorAvatar];
//        [self.momentImageContainerView addSubview:self.authorAvatar];

        self.momentInfo = [UILabel new];
        self.momentInfo.text = [NSString stringWithFormat:@"%@ ― %@", moment.author, moment.relativeDate];
        self.momentInfo.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
        self.momentInfo.font = [UIFont fontWithName:@"Lato-Medium" size:18];
        self.momentInfo.shadowColor = [UIColor colorWithWhite:0 alpha:0.2f];
        self.momentInfo.shadowOffset = CGSizeMake(0, 1);
        [self.momentInfoContainerView addSubview:self.momentInfo];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!CGSizeEqualToSize(self.mc_size, self.referenceSize)) {
        self.referenceSize = self.mc_size;

        CGSize momentInfoSize = CGSizeMake(320 * 1.5f, self.mc_height);
        CGFloat horizontalMargin = floorf((self.mc_width - 320 - momentInfoSize.width - 40.0f) / 2.0f);

        if (self.moveLeft) {
            [self.momentImageContainerView mc_setPosition:MCViewPositionVCenterLeft withMargins:UIEdgeInsetsMake(0, horizontalMargin, 0, 0) size:CGSizeMake(320 + 20, 320 + 20)];
            [self.momentInfoContainerClipView mc_setRelativePosition:MCViewRelativePositionToTheRightCentered toView:self.momentImageContainerView withMargins:UIEdgeInsetsMake(0, 40.0f, 0, 0) size:CGSizeMake(momentInfoSize.width, self.mc_height)];
            self.momentInfoContainerView.frame = self.momentInfoContainerClipView.bounds;
            [self.momentTitle mc_setPosition:MCViewPositionVCenterLeft withMargins:UIEdgeInsetsMake(0, 0, 20, 0) size:[self.momentTitle sizeThatFits:momentInfoSize]];
//            [self.authorAvatar mc_setRelativePosition:MCViewRelativePositionUnderAlignedLeft toView:self.momentTitle withMargins:UIEdgeInsetsMake(10, 0, 0, 0)];
//            [self.momentInfo mc_setRelativePosition:MCViewRelativePositionToTheRightCentered toView:self.authorAvatar withMargins:UIEdgeInsetsMake(0, 10, 0, 0) size:[self.momentInfo sizeThatFits:CGSizeZero]];
            [self.momentInfo mc_setRelativePosition:MCViewRelativePositionUnderAlignedLeft toView:self.momentTitle withMargins:UIEdgeInsetsMake(10, 0, 0, 0) size:[self.momentInfo sizeThatFits:CGSizeZero]];

        } else {
            [self.momentImageContainerView mc_setPosition:MCViewPositionVCenterRight withMargins:UIEdgeInsetsMake(0, 0, 0, horizontalMargin) size:CGSizeMake(320 + 20, 320 + 20)];
            [self.momentInfoContainerClipView mc_setRelativePosition:MCViewRelativePositionToTheLeftCentered toView:self.momentImageContainerView withMargins:UIEdgeInsetsMake(0, 0, 0, 40.0f) size:CGSizeMake(momentInfoSize.width, self.mc_height)];
            self.momentInfoContainerView.frame = self.momentInfoContainerClipView.bounds;
            [self.momentTitle mc_setPosition:MCViewPositionVCenterRight withMargins:UIEdgeInsetsMake(0, 0, 20, 0) size:[self.momentTitle sizeThatFits:momentInfoSize]];
//            [self.authorAvatar mc_setRelativePosition:MCViewRelativePositionUnderAlignedRight toView:self.momentTitle withMargins:UIEdgeInsetsMake(10, 0, 0, 0)];
//            [self.momentInfo mc_setRelativePosition:MCViewRelativePositionToTheLeftCentered toView:self.authorAvatar withMargins:UIEdgeInsetsMake(0, 0, 0, 10) size:[self.momentInfo sizeThatFits:CGSizeZero]];
            [self.momentInfo mc_setRelativePosition:MCViewRelativePositionUnderAlignedRight toView:self.momentTitle withMargins:UIEdgeInsetsMake(10, 0, 0, 0) size:[self.momentInfo sizeThatFits:CGSizeZero]];
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
    CGFloat titleTranslationX = self.moveLeft ? -self.momentInfoContainerView.mc_width : self.momentInfoContainerView.mc_width;

    CATransform3D rotation = CATransform3DMakeRotation(rotationAngle, 0, 1, 0);
    rotation.m34 = -1.0f/200.0f;
    self.momentImageContainerView.layer.transform = rotation;

    self.momentInfoContainerView.transform = CGAffineTransformMakeTranslation(titleTranslationX, 0);


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
        self.momentInfoContainerView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];

}

- (void)dismissMoment:(void (^)(void))completion
{
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}
@end