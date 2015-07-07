//
// Created by Simon de Carufel on 15-07-07.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "BooleanFormatter.h"

@interface BooleanFormatter ()
@end

@implementation BooleanFormatter
- (NSString *)formattedValue:(id)value
{
    BOOL booleanValue = [value boolValue];
    return NSLocalizedString(booleanValue ? @"boolean_value_yes": @"boolean_value_no", nil);
}
@end