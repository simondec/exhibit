//
// Created by Simon de Carufel on 15-06-08.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "BaseSettingsTableViewCell.h"

@interface BaseSettingsTableViewCell ()
@end

@implementation BaseSettingsTableViewCell
- (void)setCaption:(NSString *)caption
{
}

- (void)setFormattedValue:(NSString *)value
{
}

- (void)setAsSelected:(BOOL)selected
{
}

- (BOOL)valueIsEqual:(id)value
{
    return [self.value isEqual:value];
}

@end