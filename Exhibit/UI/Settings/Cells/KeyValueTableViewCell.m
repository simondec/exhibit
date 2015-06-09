//
// Created by Simon de Carufel on 15-06-07.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "KeyValueTableViewCell.h"

@interface KeyValueTableViewCell ()
@end

@implementation KeyValueTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setCaption:(NSString *)caption
{
    self.textLabel.text = caption;
}

- (void)setFormattedValue:(NSString *)value
{
    self.detailTextLabel.text = value;
}

@end