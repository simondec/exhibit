//
// Created by Simon de Carufel on 15-06-10.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "FetchOrganizationsOperation.h"
#import "SettingsField.h"
#import <Aubergiste/AUBOrganization.h>

@interface FetchOrganizationsOperation ()
@end

@implementation FetchOrganizationsOperation
- (void)performOperation:(void (^)(NSArray *values, NSError *error))completion
{
    [AUBOrganization listAll:^(NSArray *array, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion([self fieldsFromValues:array], error);
            }
        });
    }];
}

- (NSArray *)fieldsFromValues:(NSArray *)values
{
    NSMutableArray *fields = [NSMutableArray new];
    for (AUBOrganization *organization in values) {
        SettingsField *field = [SettingsField new];
        field.value = organization;
        field.caption = organization.name;
        field.type = @"organizationSingleSelect";
        [fields addObject:field];
    }
    return fields;
}
@end