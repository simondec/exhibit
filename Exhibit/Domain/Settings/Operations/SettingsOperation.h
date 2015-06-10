//
// Created by Simon de Carufel on 15-06-10.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SettingsOperation <NSObject>
- (void)performOperation:(void (^)(NSArray *fields, NSError *error))completion;
@end