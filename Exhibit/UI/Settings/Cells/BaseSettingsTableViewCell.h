//
// Created by Simon de Carufel on 15-06-08.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface BaseSettingsTableViewCell : UITableViewCell
@property (nonatomic) id value;
- (void)setCaption:(NSString *)caption;
- (void)setFormattedValue:(NSString *)value;
- (void)setAsSelected:(BOOL)selected;
@end