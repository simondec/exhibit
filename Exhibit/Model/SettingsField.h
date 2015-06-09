//
// Created by Simon de Carufel on 15-06-08.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Settings;


@interface SettingsField : NSObject
@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) NSString *caption;
@property (nonatomic, readonly) id value;
@property (nonatomic, readonly) NSString *formattedValue;
@property (nonatomic, readonly) NSString *target;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary settings:(Settings *)settings;
@end