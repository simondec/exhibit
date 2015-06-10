//
// Created by Simon de Carufel on 15-06-09.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Settings;


@interface BaseSettingsViewController : UIViewController
@property (nonatomic, weak) Settings *settings;
- (instancetype)initWithSettings:(Settings *)settings;
@end