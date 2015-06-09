//
// Created by Simon de Carufel on 15-06-08.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "SettingsField.h"
#import "NSDictionary+MCTypeSafety.h"
#import "Settings.h"
#import "Formatting.h"

static NSString *const SettingsSectionRowTypeKey = @"type";
static NSString *const SettingsSectionRowCaptionKey = @"caption";
static NSString *const SettingsSectionRowValueKey = @"value";
static NSString *const SettingsSectionRowLinkedValueKey = @"linkedValue";
static NSString *const SettingsSectionRowFormatterKey = @"formatter";
static NSString *const SettingsSectionRowTargetKey = @"target";

@interface SettingsField ()
@property (nonatomic, weak) Settings *settings;
@property (nonatomic) NSString *linkedValueKeyPath;
@property (nonatomic) id <Formatting> formatter;
@property (nonatomic) id staticValue;
@end

@implementation SettingsField
- (instancetype)initWithDictionary:(NSDictionary *)dictionary settings:(Settings *)settings
{
    if (self = [super init]) {
        _settings = settings;

        _type = [dictionary stringForKey:SettingsSectionRowTypeKey];

        NSString *captionKey = [dictionary stringForKey:SettingsSectionRowCaptionKey];
        if (captionKey.length > 0) {
            _caption = NSLocalizedString(captionKey, nil);
        }

        NSString *formatterClassName = [dictionary stringForKey:SettingsSectionRowFormatterKey];
        if (formatterClassName) {
            _formatter = (id <Formatting>)[NSClassFromString(formatterClassName) new];
        }

        _linkedValueKeyPath = [dictionary stringForKey:SettingsSectionRowLinkedValueKey];
        _staticValue = dictionary[SettingsSectionRowValueKey];
        _target = [dictionary stringForKey:SettingsSectionRowTargetKey];
    }
    return self;
}

- (id)value
{
    id value = nil;

    if (self.linkedValueKeyPath.length > 0) {
        value = [self.settings valueForKeyPath:self.linkedValueKeyPath];
    } else {
        value = self.staticValue;
    }
    return value;
}

- (NSString *)formattedValue
{
    NSString *formattedValue = nil;
    id value = self.value;

    if (value) {
        if (self.formatter) {
            formattedValue = [self.formatter formattedValue:value];
        } else {
            formattedValue = value;
        }
    }
    return formattedValue;
}
@end