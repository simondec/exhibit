//
// Created by Simon de Carufel on 15-06-08.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Formatting <NSObject>
- (NSString *)formattedValue:(id)value;
@end