//
// Created by Simon de Carufel on 15-06-08.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "IntegerFormatter.h"

@interface IntegerFormatter ()
@end

@implementation IntegerFormatter
- (NSString *)formattedValue:(id)value
{
    return [NSString stringWithFormat:@"%li", (long)[value integerValue]];
}
@end