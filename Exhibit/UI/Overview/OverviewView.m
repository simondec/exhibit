//
// Created by Simon de Carufel on 15-06-16.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <MCUIViewLayout/UIView+MCLayout.h>
#import <Aubergiste/AUBOrganization.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <Aubergiste/AUBAvatar.h>
#import "OverviewView.h"
#import "UIImage+MCImageGeneration.h"
#import "AvatarView.h"

@interface OverviewView ()
@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) UIView *logoContainerView;
@property (nonatomic) UIImageView *nwadImageView;
@property (nonatomic) UILabel *exhibitLabel;
@property (nonatomic) UIView *organizationContainerView;
@property (nonatomic) AvatarView *organizationImageView;
@property (nonatomic) UILabel *organizationName;
@property (nonatomic) UILabel *organizationMomentsCount;
@property (nonatomic) UILabel *secondaryScreenInfoLabel;
@property (nonatomic) BOOL secondaryScreenConnected;
@property (nonatomic) BOOL secondaryScreenRequired;
@property (nonatomic) BOOL organizationSet;
@end

@implementation OverviewView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;

        self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OverviewBackground"]];
        self.backgroundImageView.alpha = 0.3f;
        [self addSubview:self.backgroundImageView];

        self.logoContainerView = [UIView new];
        [self addSubview:self.logoContainerView];

        self.nwadImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NWADLogoPicto"]];
        [self.logoContainerView addSubview:self.nwadImageView];

        self.exhibitLabel = [UILabel new];
        self.exhibitLabel.text = @"Exhibit";
        self.exhibitLabel.font = [UIFont fontWithName:@"Lato-Light" size:40];
        self.exhibitLabel.textColor = [UIColor whiteColor];
        [self.logoContainerView addSubview:self.exhibitLabel];

        self.organizationContainerView = [UIView new];
        self.organizationContainerView.alpha = 0;
        [self addSubview:self.organizationContainerView];

        self.organizationImageView = [[AvatarView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        [self.organizationContainerView addSubview:self.organizationImageView];

        self.organizationName = [UILabel new];
        self.organizationName.font = [UIFont fontWithName:@"Lato-Bold" size:30];
        self.organizationName.textColor = [UIColor whiteColor];
        [self.organizationContainerView addSubview:self.organizationName];

        self.organizationMomentsCount = [UILabel new];
        self.organizationMomentsCount.font = [UIFont fontWithName:@"Lato-Normal" size:14];
        self.organizationMomentsCount.textColor = [UIColor whiteColor];
        [self.organizationContainerView addSubview:self.organizationMomentsCount];

        self.secondaryScreenInfoLabel = [UILabel new];
        self.secondaryScreenInfoLabel.font = [UIFont fontWithName:@"Lato-Italic" size:14];
        self.secondaryScreenInfoLabel.textColor = [UIColor lightGrayColor];
        self.secondaryScreenInfoLabel.textAlignment = NSTextAlignmentCenter;
        self.secondaryScreenInfoLabel.numberOfLines = 0;
        [self addSubview:self.secondaryScreenInfoLabel];

        self.startSlideshowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.startSlideshowButton setTitle:NSLocalizedString(@"overview_start_slideshow", nil) forState:UIControlStateNormal];
        [self.startSlideshowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.startSlideshowButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [self.startSlideshowButton setBackgroundImage:[UIImage mc_generateImageOfSize:CGSizeMake(2, 2) color:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        self.startSlideshowButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.startSlideshowButton.layer.borderWidth = 1;
        self.startSlideshowButton.layer.cornerRadius = 5.0f;
        self.startSlideshowButton.clipsToBounds = YES;
        self.startSlideshowButton.enabled = NO;
        self.startSlideshowButton.alpha = 0.5f;
        [self addSubview:self.startSlideshowButton];

        self.configureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.configureButton setTitle:NSLocalizedString(@"overview_configure_button", nil) forState:UIControlStateNormal];
        [self.configureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.configureButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [self.configureButton setBackgroundImage:[UIImage mc_generateImageOfSize:CGSizeMake(2, 2) color:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        self.configureButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.configureButton.layer.borderWidth = 1;
        self.configureButton.layer.cornerRadius = 5.0f;
        self.configureButton.clipsToBounds = YES;
        self.configureButton.hidden = YES;
        [self addSubview:self.configureButton];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize backgroundImageSize = self.backgroundImageView.image.size;
    CGSize backgroundImageViewSize = CGSizeMake(self.mc_height / backgroundImageSize.height * backgroundImageSize.width, self.mc_height);
    [self.backgroundImageView mc_setSize:backgroundImageViewSize];

    CGSize startSlideshowButtonSize = [self.startSlideshowButton sizeThatFits:CGSizeZero];
    startSlideshowButtonSize.width += 20;

    [self.logoContainerView mc_setPosition:MCViewPositionCenters withMargins:UIEdgeInsetsMake(0, 0, 100, 0) size:CGSizeMake(130, 130)];

    [self.nwadImageView mc_setPosition:MCViewPositionTopHCenter withMargins:UIEdgeInsetsZero size:CGSizeMake(70, 70)];
    [self.exhibitLabel mc_setPosition:MCViewPositionBottomHCenter withMargins:UIEdgeInsetsZero size:[self.exhibitLabel sizeThatFits:CGSizeZero]];

    [self.organizationContainerView mc_setSize:CGSizeMake(self.mc_width, 200)];
    self.organizationContainerView.center = self.logoContainerView.center;

    [self.organizationImageView mc_setPosition:MCViewPositionTopHCenter];
    [self.organizationMomentsCount mc_setPosition:MCViewPositionBottomHCenter withMargins:UIEdgeInsetsZero size:[self.organizationMomentsCount sizeThatFits:CGSizeZero]];
    [self.organizationName mc_setRelativePosition:MCViewRelativePositionAboveCentered toView:self.organizationMomentsCount withMargins:UIEdgeInsetsMake(0, 0, 5, 0) size:[self.organizationName sizeThatFits:CGSizeZero]];

    [self.startSlideshowButton mc_setPosition:MCViewPositionBottomHCenter withMargins:UIEdgeInsetsMake(0, 0, 40, 0) size:startSlideshowButtonSize];

    UIView *secondaryScreenInfoReferralView = self.startSlideshowButton;

    if (!self.configureButton.hidden) {
        [self.configureButton mc_setRelativePosition:MCViewRelativePositionAboveCentered toView:self.startSlideshowButton withMargins:UIEdgeInsetsMake(0, 0, 10, 0) size:startSlideshowButtonSize];
        secondaryScreenInfoReferralView = self.configureButton;
    }

    CGFloat secondaryScreenInfoLabelMaxWidth = self.mc_width * 0.8f;
    [self.secondaryScreenInfoLabel mc_setRelativePosition:MCViewRelativePositionAboveCentered toView:secondaryScreenInfoReferralView withMargins:UIEdgeInsetsMake(0, 0, 40, 0) size:[self.secondaryScreenInfoLabel sizeThatFits:CGSizeMake(secondaryScreenInfoLabelMaxWidth, 0)]];
}

- (void)setOrganization:(AUBOrganization *)organization
{
    if (organization) {
        self.organizationSet = YES;
        [self.organizationImageView setImageWithURL:organization.avatar.large];
        self.organizationName.text = organization.name;
        self.organizationMomentsCount.text = [NSString stringWithFormat:@"(%i moments)", organization.momentsCount];
        [self setNeedsLayout];

        [UIView animateWithDuration:0.5f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.logoContainerView.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.organizationContainerView.alpha = 1;
                [self updateSecondaryScreenInfoLabel];
            } completion:nil];
        }];
    }
}

- (void)setSecondaryScreenConnected:(BOOL)connected
{
    _secondaryScreenConnected = connected;
    [self updateSecondaryScreenInfoLabel];

}

- (void)setSecondaryScreenRequired:(BOOL)required
{
    _secondaryScreenRequired = required;
    [self updateSecondaryScreenInfoLabel];
}

//------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------

- (void)startPanningBackround
{
    if ([self.backgroundImageView.layer animationForKey:@"panning"]) return;

    CATransform3D transform = CATransform3DMakeTranslation(-(self.backgroundImageView.mc_width - self.mc_width), 0, 0);
    CABasicAnimation *panningAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    panningAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    panningAnim.toValue = [NSValue valueWithCATransform3D:transform];
    panningAnim.duration = 120;
    panningAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    panningAnim.autoreverses = YES;
    panningAnim.repeatCount = MAXFLOAT;
    [self.backgroundImageView.layer addAnimation:panningAnim forKey:@"panning"];
}

- (void)updateSecondaryScreenInfoLabel
{
    [self setNeedsLayout];
    NSString *disconnectedSecondaryScreenStringKey = (self.secondaryScreenRequired ? @"overview_secondary_screen_required_disconnected_info" : @"overview_secondary_screen_disconnected_info");
    NSString *stringKey = (self.secondaryScreenConnected ? @"overview_secondary_screen_connected_info" : disconnectedSecondaryScreenStringKey);
    [UIView transitionWithView:self.secondaryScreenInfoLabel duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.secondaryScreenInfoLabel.text = NSLocalizedString(stringKey, nil);
    } completion:nil];
    BOOL enabled = (self.secondaryScreenConnected || !self.secondaryScreenRequired) && self.organizationSet;
    self.startSlideshowButton.alpha = (enabled ? 1 : 0.5f);
    self.startSlideshowButton.enabled = enabled;
}
@end