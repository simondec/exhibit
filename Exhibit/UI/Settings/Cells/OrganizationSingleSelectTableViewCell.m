//
// Created by Simon de Carufel on 15-06-09.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "OrganizationSingleSelectTableViewCell.h"
#import "AUBOrganization.h"

@interface OrganizationSingleSelectTableViewCell ()
@end

@implementation OrganizationSingleSelectTableViewCell

- (void)setFormattedValue:(NSString *)value
{
    // Do Nothing with it.
}

- (void)setValue:(id)value
{
    [super setValue:value];
    AUBOrganization *organization = value;
    self.textLabel.text = organization.name;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.userInteractionEnabled = YES;
}

- (BOOL)valueIsEqual:(id)value
{
    return [((AUBOrganization *)value).objectID isEqual:((AUBOrganization *)self.value).objectID];
}
@end