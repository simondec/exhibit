//
// Created by Simon de Carufel on 15-06-08.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Settings;


@interface SettingsField : NSObject
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *caption;
@property (nonatomic) id value;
@property (nonatomic) NSString *formattedValue;
@property (nonatomic) NSString *targetFile;
@property (nonatomic) NSString *targetController;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary settings:(Settings *)settings;
@end