//
// Created by Simon de Carufel on 15-06-07.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <MCUIViewLayout/UIView+MCLayout.h>
#import "SettingsViewController.h"
#import "NSDictionary+MCTypeSafety.h"
#import "KeyValueTableViewCell.h"
#import "Settings.h"
#import "Formatting.h"
#import "SingleSelectTableViewCell.h"
#import "SettingsController.h"
#import "SettingsSection.h"
#import "SettingsField.h"

static NSString *const SettingsTitleKey = @"title";
static NSString *const SettingsSectionsKey = @"sections";
static NSString *const SettingsLinkedValueKey = @"linkedValue";
static NSString *const SettingsSectionHeaderKey = @"header";
static NSString *const SettingsSectionRowsKey = @"fields";
static NSString *const SettingsSectionRowTypeKey = @"type";
static NSString *const SettingsSectionRowCaptionKey = @"caption";
static NSString *const SettingsSectionRowValueKey = @"value";
static NSString *const SettingsSectionRowLinkedValueKey = @"linkedValue";
static NSString *const SettingsSectionRowFormatterKey = @"formatter";
static NSString *const SettingsSectionRowTargetKey = @"target";

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) SettingsController *settingsController;
@property (nonatomic, weak) Settings *settings;
@property (nonatomic) NSIndexPath *selectedRowIndexPath;
@end

@implementation SettingsViewController
- (instancetype)initWithLayoutFileName:(NSString *)fileName settings:(Settings *)settings
{
    if (self = [super init]) {
        _settingsController = [[SettingsController alloc] initWithLayoutFileName:fileName settings:settings];
        _settings = settings;
    }
    return self;
}

- (void)loadView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.view = self.tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[KeyValueTableViewCell class] forCellReuseIdentifier:@"keyValue"];
    [self.tableView registerClass:[SingleSelectTableViewCell class] forCellReuseIdentifier:@"singleSelect"];
    self.title = self.settingsController.settingsTitle;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    UIEdgeInsets contentInset = UIEdgeInsetsMake(self.navigationController.navigationBar.mc_height, 0, 0, 0);
    self.tableView.contentInset = contentInset;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

//------------------------------------------------------------------------------
#pragma mark - SettingsObserver
//------------------------------------------------------------------------------

- (void)settingsDidChange
{
    [self.tableView reloadData];
}

//------------------------------------------------------------------------------
#pragma mark - UITableView Delegate & DataSource
//------------------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.settingsController.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SettingsSection *settingsSection = [self.settingsController sectionAtIndex:section];
    return settingsSection.fields.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsSection *settingsSection = [self.settingsController sectionAtIndex:indexPath.section];
    SettingsField *settingsField = settingsSection.fields[indexPath.row];

    BaseSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingsField.type forIndexPath:indexPath];

    [cell setCaption:settingsField.caption];
    [cell setValue:settingsField.value];
    [cell setFormattedValue:settingsField.formattedValue];

    if (settingsField.value) {
        id settingsLinkedValue = [self.settingsController linkedValue];
        if ([settingsField.value isEqual:settingsLinkedValue]) {
            [cell setAsSelected:YES];
            self.selectedRowIndexPath = indexPath;
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsSection *settingsSection = [self.settingsController sectionAtIndex:indexPath.section];
    SettingsField *settingsField = settingsSection.fields[indexPath.row];

    NSString *target = settingsField.target;
    BaseSettingsTableViewCell *selectedCell = (BaseSettingsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    id selectedValue = selectedCell.value;

    if (target.length > 0) {
        SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithLayoutFileName:target settings:self.settings];
        [self.navigationController pushViewController:settingsViewController animated:YES];
    } else if (self.settingsController.linkedValue) {
        [self.settingsController setLinkedValue:selectedValue];
        if (self.selectedRowIndexPath) {
            BaseSettingsTableViewCell *previousSelectedCell = (BaseSettingsTableViewCell *) [tableView cellForRowAtIndexPath:self.selectedRowIndexPath];
            [previousSelectedCell setAsSelected:NO];
        }
        [selectedCell setAsSelected:YES];
        self.selectedRowIndexPath = indexPath;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end