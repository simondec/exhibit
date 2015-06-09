//
// Created by Simon de Carufel on 15-06-08.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "SettingsController.h"
#import "Settings.h"
#import "NSDictionary+MCTypeSafety.h"
#import "SettingsSection.h"

static NSString *const SettingsTitleKey = @"title";
static NSString *const SettingsSectionsKey = @"sections";
static NSString *const SettingsLinkedValueKey = @"linkedValue";

@interface SettingsController ()
@property (nonatomic, weak) Settings *settings;
@property (nonatomic) NSArray *settingsSections;
@property (nonatomic) NSString *settingsLinkedValueKey;
@end

@implementation SettingsController
- (instancetype)initWithLayoutFileName:(NSString *)fileName settings:(Settings *)settings
{
    if (self = [super init]) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        _settings = settings;

        _settingsTitle = NSLocalizedString([dictionary stringForKey:SettingsTitleKey], nil);
        _settingsLinkedValueKey = [dictionary stringForKey:SettingsLinkedValueKey];

        NSMutableArray *sections = [NSMutableArray new];
        for (NSDictionary *sectionDict in [dictionary arrayForKey:SettingsSectionsKey]) {
            SettingsSection *settingsSection = [[SettingsSection alloc] initWithDictionary:sectionDict settings:self.settings];
            [sections addObject:settingsSection];
        }

        _settingsSections = sections;
    }
    return self;
}

- (id)linkedValue
{
    id linkedValue = nil;

    if (self.settingsLinkedValueKey) {
        linkedValue = [self.settings valueForKeyPath:self.settingsLinkedValueKey];
    }

    return linkedValue;
}

- (void)setLinkedValue:(id)linkedValue
{
    if (self.settingsLinkedValueKey) {
        [self.settings setValue:linkedValue forKeyPath:self.settingsLinkedValueKey];
    }
}

- (NSInteger)numberOfSections
{
    return [self.settingsSections count];
}

- (SettingsSection *)sectionAtIndex:(NSUInteger)sectionIndex
{
    return self.settingsSections[sectionIndex];
}
@end