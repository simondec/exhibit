//
// Created by Simon de Carufel on 15-07-07.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "SwitchTableViewCell.h"

@interface SwitchTableViewCell ()
@property (nonatomic) UISwitch *switchView;
@end

@implementation SwitchTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.switchView = [UISwitch new];
        [self.switchView addTarget:self action:@selector(switchValueDidChange) forControlEvents:UIControlEventValueChanged];
        self.accessoryView = self.switchView;
    }
    return self;
}

- (void)setCaption:(NSString *)caption
{
    self.textLabel.text = caption;
}

- (void)setValue:(id)value
{
    BOOL booleanValue = [value boolValue];
    self.switchView.on = booleanValue;
}

- (id)value
{
    return @(self.switchView.on);
}

- (void)switchValueDidChange
{
    if ([self.delegate respondsToSelector:@selector(valueDidChange:)]) {
        [self.delegate valueDidChange:self.value];
    }
}
@end