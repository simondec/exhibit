//
// Created by Simon de Carufel on 15-06-07.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseSettingsViewController.h"

@class Settings;
@protocol SettingsViewControllerDelegate;


@interface SettingsViewController : BaseSettingsViewController
@property (nonatomic, weak) id <SettingsViewControllerDelegate> delegate;
- (instancetype)initWithLayoutFileName:(NSString *)fileName settings:(Settings *)settings;
- (void)setCloseButtonVisible:(BOOL)visible;
@end

@protocol SettingsViewControllerDelegate <NSObject>
- (void)settingsViewControllerCloseButtonTapped;
@end
