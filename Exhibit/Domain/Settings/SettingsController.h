//
// Created by Simon de Carufel on 15-06-08.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Settings;
@class SettingsSection;


@interface SettingsController : NSObject
@property (nonatomic) id linkedValue;
@property (nonatomic, readonly) NSString *settingsTitle;
- (instancetype)initWithLayoutFileName:(NSString *)fileName settings:(Settings *)settings;
- (NSInteger)numberOfSections;
- (SettingsSection *)sectionAtIndex:(NSUInteger)sectionIndex;
@end