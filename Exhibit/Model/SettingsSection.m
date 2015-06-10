//
// Created by Simon de Carufel on 15-06-08.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "SettingsSection.h"
#import "NSDictionary+MCTypeSafety.h"
#import "SettingsField.h"
#import "Settings.h"
#import "SettingsOperation.h"

static NSString *const SettingsSectionHeaderKey = @"header";
static NSString *const SettingsSectionRowsKey = @"fields";
static NSString *const SettingsSectionOperationKey = @"operation";

@interface SettingsSection ()
@end

@implementation SettingsSection
- (instancetype)initWithDictionary:(NSDictionary *)dictionary settings:(Settings *)settings
{
    if (self = [super init]) {
        _header = NSLocalizedString([dictionary stringForKey:SettingsSectionHeaderKey], nil);

        NSArray *fieldsData = [dictionary arrayForKey:SettingsSectionRowsKey];

        NSString *operationName = [dictionary stringForKey:SettingsSectionOperationKey];

        if (operationName.length > 0) {
            Class operationClass = NSClassFromString(operationName);
            _operation = (id <SettingsOperation>)[operationClass new];
        } else {
            NSMutableArray *fields = [NSMutableArray new];
            for (NSDictionary *fieldData in fieldsData) {
                SettingsField *field = [[SettingsField alloc] initWithDictionary:fieldData settings:settings];
                [fields addObject:field];
            }
            _fields = fields;
        }

    }
    return self;
}

- (void)performOperation:(void (^)(NSError *error))completion
{
    if (!self.operation) {
        if (completion) completion(nil);
        return;
    }

    [self.operation performOperation:^(NSArray *fields, NSError *error) {
        _fields = fields;
        if (completion) completion(error);
    }];
}

@end