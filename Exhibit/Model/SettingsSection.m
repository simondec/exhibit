//
// Created by Simon de Carufel on 15-06-08.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "SettingsSection.h"
#import "NSDictionary+MCTypeSafety.h"
#import "SettingsField.h"
#import "Settings.h"

static NSString *const SettingsSectionHeaderKey = @"header";
static NSString *const SettingsSectionRowsKey = @"fields";

@interface SettingsSection ()
@end

@implementation SettingsSection
- (instancetype)initWithDictionary:(NSDictionary *)dictionary settings:(Settings *)settings
{
    if (self = [super init]) {
        _header = [dictionary stringForKey:SettingsSectionHeaderKey];

        NSArray *fieldsData = [dictionary arrayForKey:SettingsSectionRowsKey];
        NSMutableArray *fields = [NSMutableArray new];

        for (NSDictionary *fieldData in fieldsData) {
            SettingsField *field = [[SettingsField alloc] initWithDictionary:fieldData settings:settings];
            [fields addObject:field];
        }
        _fields = fields;

    }
    return self;
}
@end