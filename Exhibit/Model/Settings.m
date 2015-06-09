//
// Created by Simon de Carufel on 15-06-02.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "Settings.h"

@interface Settings ()
@end

@implementation Settings

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.organizationID forKey:@"organizationID"];
    [coder encodeDouble:self.slideDuration forKey:@"slideDuration"];
    [coder encodeInteger:self.slideCount forKey:@"slideCount"];

}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        self.organizationID = [coder decodeObjectForKey:@"organizationID"];
        self.slideDuration = [coder decodeDoubleForKey:@"slideDuration"];
        self.slideCount = [coder decodeIntegerForKey:@"slideCount"];
    }
    return self;
}

@end