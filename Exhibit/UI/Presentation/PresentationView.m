//
// Created by Simon de Carufel on 15-06-02.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "PresentationView.h"
#import "UIView+MCLayout.h"
#import "SlideView.h"
#import "Moment.h"

@interface PresentationView ()
@property (nonatomic) CGSize referenceSize;
@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) UIImageView *nwadLogoImageView;
@property (nonatomic) SlideView *currentSlideView;
@property (nonatomic) BOOL moveLeft;
@property (nonatomic) NSTimeInterval duration;
@end

@implementation PresentationView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.activityIndicatorView setHidesWhenStopped:YES];
        [self.activityIndicatorView startAnimating];
        [self addSubview:self.activityIndicatorView];

        self.backgroundImageView = [UIImageView new];
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundImageView.alpha = 0.9f;
        [self addSubview:self.backgroundImageView];

        self.nwadLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NWADLogoPicto"]];
        self.nwadLogoImageView.alpha = 0;
        [self addSubview:self.nwadLogoImageView];

        self.moveLeft = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!CGSizeEqualToSize(self.mc_size, self.referenceSize)) {
        self.referenceSize = self.mc_size;
        CGSize backgroundSize = self.mc_size;
        [self.activityIndicatorView mc_setPosition:MCViewPositionCenters];
        [self.backgroundImageView mc_setPosition:MCViewPositionVCenterLeft withMargins:UIEdgeInsetsZero size:backgroundSize];
        [self.nwadLogoImageView mc_setPosition:MCViewPositionBottomLeft withMargins:UIEdgeInsetsMake(0, 10, 10, 0) size:CGSizeMake(40, 40)];
        [self.currentSlideView mc_setPosition:MCViewPositionCenters withMargins:UIEdgeInsetsZero size:self.mc_size];
    }
}

//------------------------------------------------------------------------------
#pragma mark - Public Methods
//------------------------------------------------------------------------------

- (void)transitionToMoment:(Moment *)moment duration:(NSTimeInterval)duration
{
    self.duration = duration;
    self.moveLeft = !self.moveLeft;

    if (self.activityIndicatorView.isAnimating) {
        [self.activityIndicatorView stopAnimating];
    }

    if (self.currentSlideView) {
        [self.currentSlideView dismissMoment:^{
            [self.currentSlideView removeFromSuperview];
            self.currentSlideView = nil;
            [self transitionBackground:moment.blurredBackground duration:duration];
        }];
    } else {
        [self transitionBackground:moment.blurredBackground duration:duration];
    }

    [self performSelector:@selector(presentMoment:) withObject:moment afterDelay:1.0f];

    if (self.nwadLogoImageView.alpha < 1) {
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.nwadLogoImageView.alpha = 1;
        } completion:nil];
    }
}

//------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------

- (void)transitionBackground:(UIImage *)backgroundImage duration:(NSTimeInterval)duration
{
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionFade;
    [self.backgroundImageView.layer addAnimation:transition forKey:nil];
    self.backgroundImageView.image = backgroundImage;

}

- (void)presentMoment:(Moment *)moment
{
    if (self.currentSlideView) return;
    
    self.currentSlideView = [[SlideView alloc] initWithMoment:moment moveLeft:self.moveLeft];
    [self addSubview:self.currentSlideView];
    [self.currentSlideView mc_setPosition:MCViewPositionCenters withMargins:UIEdgeInsetsZero size:self.mc_size];

    [self.currentSlideView presentMoment:^{
        if ([self.delegate respondsToSelector:@selector(didCompleteTransition)]) {
            [self.delegate didCompleteTransition];
        }
    }];

    CGFloat translationX = (self.moveLeft ? -30 : 30);

    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.currentSlideView.transform = CGAffineTransformMakeTranslation(translationX, 0);
    } completion:^(BOOL finished) {
    }];
}
@end