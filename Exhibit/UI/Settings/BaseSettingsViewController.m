//
// Created by Simon de Carufel on 15-06-09.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "BaseSettingsViewController.h"
#import "Settings.h"

@interface BaseSettingsViewController ()
@end

@implementation BaseSettingsViewController
- (instancetype)initWithSettings:(Settings *)settings
{
    if (self = [super init]) {
        self.settings = settings;
    }
    return self;
}
@end