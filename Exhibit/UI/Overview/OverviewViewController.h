//
// Created by Simon de Carufel on 15-06-07.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Settings;
@protocol OverviewViewControllerDelegate;


@interface OverviewViewController : UIViewController
@property (nonatomic, weak) id <OverviewViewControllerDelegate> delegate;
- (instancetype)initWithSettings:(Settings *)settings secondaryScreenConnected:(BOOL)connected;
- (void)setSecondaryScreenConnected:(BOOL)connected;
- (void)setSecondaryScreenRequired:(BOOL)required;
- (void)setConfigureButtonVisible:(BOOL)visible;
@end

@protocol OverviewViewControllerDelegate <NSObject>
- (void)overviewViewControllerStartSlideshowButtonTapped;
- (void)overviewViewControllerConfigureButtonTapped;
@end