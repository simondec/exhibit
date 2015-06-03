//
// Created by Simon de Carufel on 15-06-02.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "Configuration.h"

@interface Configuration ()
@end

@implementation Configuration
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.organizationID forKey:@"organizationID"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        self.organizationID = [coder decodeObjectForKey:@"organizationID"];
    }
    return self;
}

@end