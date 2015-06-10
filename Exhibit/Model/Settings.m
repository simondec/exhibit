//
// Created by Simon de Carufel on 15-06-02.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "Settings.h"
#import "AUBOrganization.h"

@interface Settings ()
@end

@implementation Settings

- (void)encodeWithCoder:(NSCoder *)coder
{
    if (self.organization) {
        [coder encodeObject:self.organization.dictionaryRepresentation forKey:@"organization"];
    }

    [coder encodeObject:self.organizationID forKey:@"organizationID"];
    [coder encodeDouble:self.slideDuration forKey:@"slideDuration"];
    [coder encodeInteger:self.slideCount forKey:@"slideCount"];

}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {

        NSDictionary *organizationDict = [coder decodeObjectForKey:@"organization"];
        if (organizationDict) {
            self.organization = (AUBOrganization *)[AUBOrganization objectWithDictionary:organizationDict];
        }

        self.organizationID = [coder decodeObjectForKey:@"organizationID"];
        self.slideDuration = [coder decodeDoubleForKey:@"slideDuration"];
        self.slideCount = [coder decodeIntegerForKey:@"slideCount"];
    }
    return self;
}

@end