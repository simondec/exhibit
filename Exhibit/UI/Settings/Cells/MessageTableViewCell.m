//
// Created by Simon de Carufel on 15-06-09.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "MessageTableViewCell.h"

@interface MessageTableViewCell ()
@end

@implementation MessageTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.textColor = [UIColor lightGrayColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}

@end