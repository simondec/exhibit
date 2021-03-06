//
// Created by Simon de Carufel on 15-06-08.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Settings;
@protocol SettingsOperation;


@interface SettingsSection : NSObject
@property (nonatomic, readonly) NSString *header;
@property (nonatomic, readonly) id <SettingsOperation> operation;
@property (nonatomic, readonly) NSArray *fields;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary settings:(Settings *)settings;
- (void)performOperation:(void (^)(NSError *error))completion;
@end