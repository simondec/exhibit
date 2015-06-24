//
// Created by Simon de Carufel on 15-06-16.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AUBOrganization;


@interface OverviewView : UIView
@property (nonatomic) UIButton *startSlideshowButton;
@property (nonatomic) UIButton *configureButton;
- (void)setOrganization:(AUBOrganization *)organization;
- (void)setSecondaryScreenConnected:(BOOL)connected;
- (void)setSecondaryScreenRequired:(BOOL)required;
- (void)startPanningBackround;
@end