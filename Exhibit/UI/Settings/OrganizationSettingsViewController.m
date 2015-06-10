//
// Created by Simon de Carufel on 15-06-09.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "OrganizationSettingsViewController.h"
#import <Aubergiste/AUBOrganization.h>
#import "Settings.h"
#import "OrganizationSingleSelectTableViewCell.h"
#import "MessageTableViewCell.h"

@interface OrganizationSettingsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) NSArray *organizations;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSIndexPath *selectedRowIndexPath;
@end

@implementation OrganizationSettingsViewController

- (instancetype)initWithSettings:(Settings *)settings
{
    if (self = [super initWithSettings:settings]) {
        self.organizations = @[];
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
    [self.tableView registerClass:[OrganizationSingleSelectTableViewCell class] forCellReuseIdentifier:@"organizationSingleSelect"];
    [self.tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:@"message"];
    self.title = @"Organization";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [AUBOrganization listAll:^(NSArray *array, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.organizations = array;
            [self.tableView reloadData];
        });
    }];
}

//------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------
- (BOOL)hasSelection
{
    return self.settings.organization != nil;
}

//------------------------------------------------------------------------------
#pragma mark - UITableView Delegate & DataSource
//------------------------------------------------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (self.organizations.count == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"message" forIndexPath:indexPath];
        cell.textLabel.text = @"No Organizations Found";
    } else {
        AUBOrganization *organization = self.organizations[indexPath.row];
        OrganizationSingleSelectTableViewCell *organizationCell = [tableView dequeueReusableCellWithIdentifier:@"organizationSingleSelect" forIndexPath:indexPath];
        [organizationCell setValue:organization];

        if ([[self.settings.organization objectID] isEqual:organization.objectID]) {
            [organizationCell setAsSelected:YES];
            self.selectedRowIndexPath = indexPath;
        }

        cell = organizationCell;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX(1, self.organizations.count);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Choose a company";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrganizationSingleSelectTableViewCell *selectedCell = (OrganizationSingleSelectTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];

    if (self.selectedRowIndexPath) {
        OrganizationSingleSelectTableViewCell *previouslySelectedCell = (OrganizationSingleSelectTableViewCell *) [tableView cellForRowAtIndexPath:self.selectedRowIndexPath];
        [previouslySelectedCell setAsSelected:NO];
    }

    self.settings.organization = selectedCell.value;
    [selectedCell setAsSelected:YES];
    self.selectedRowIndexPath = indexPath;
}

@end