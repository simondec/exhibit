//
// Created by Simon de Carufel on 15-06-08.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "SingleSelectTableViewCell.h"

@interface SingleSelectTableViewCell ()
@end

@implementation SingleSelectTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)setFormattedValue:(NSString *)value
{
    self.textLabel.text = value;
}

- (void)setAsSelected:(BOOL)selected
{
    self.accessoryType = (selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
}

- (void)prepareForReuse
{
    self.accessoryType = UITableViewCellAccessoryNone;
}

@end