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
#import "OrganizationSingleSelectTableViewCell.h"

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) SettingsController *settingsController;
@property (nonatomic) NSIndexPath *selectedRowIndexPath;
@end

@implementation SettingsViewController
- (instancetype)initWithLayoutFileName:(NSString *)fileName settings:(Settings *)settings
{
    if (self = [super init]) {
        self.settings = settings;
        _settingsController = [[SettingsController alloc] initWithLayoutFileName:fileName settings:settings];
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
    [self.tableView registerClass:[OrganizationSingleSelectTableViewCell class] forCellReuseIdentifier:@"organizationSingleSelect"];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.settingsController performOperations:^(BOOL didPerformOperations, NSError *error) {
        if (didPerformOperations) {
            NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.settingsController.numberOfSections)];
            [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
}

//------------------------------------------------------------------------------
#pragma mark - Public Methods
//------------------------------------------------------------------------------

- (void)setCloseButtonVisible:(BOOL)visible
{
    UIBarButtonItem *barButtonItem = nil;

    if (visible) {
        barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeButtonTapped)];
    }

    self.navigationItem.rightBarButtonItem = barButtonItem;
}

//------------------------------------------------------------------------------
#pragma mark - Control Events
//------------------------------------------------------------------------------

- (void)closeButtonTapped
{
    if (self.delegate) {
        [self.delegate settingsViewControllerCloseButtonTapped];
    }
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    SettingsSection *settingsSection = [self.settingsController sectionAtIndex:section];
    return settingsSection.header;
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
        //[settingsField.value isEqual:settingsLinkedValue]
        if ([cell valueIsEqual:settingsLinkedValue]) {
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

    NSString *targetFile = settingsField.targetFile;
    NSString *targetController = settingsField.targetController;
    BaseSettingsTableViewCell *selectedCell = (BaseSettingsTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    id selectedValue = selectedCell.value;

    if (targetFile.length > 0) {
        SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithLayoutFileName:targetFile settings:self.settings];
        [self.navigationController pushViewController:settingsViewController animated:YES];
    } else if (targetController.length > 0) {
        Class viewControllerClass = NSClassFromString(targetController);
        id viewController = [viewControllerClass alloc];
        BaseSettingsViewController *settingsViewController = (BaseSettingsViewController *)[viewController initWithSettings:self.settings];
        [self.navigationController pushViewController:settingsViewController animated:YES];
    } else {
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