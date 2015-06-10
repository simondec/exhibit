//
// Created by Simon de Carufel on 15-06-07.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseSettingsViewController.h"

@class Settings;


@interface SettingsViewController : BaseSettingsViewController
- (instancetype)initWithLayoutFileName:(NSString *)fileName settings:(Settings *)settings;
@end