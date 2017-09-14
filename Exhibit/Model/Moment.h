//
// Created by Simon de Carufel on 15-06-02.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Moment : NSObject
@property (nonatomic) NSString *momentDescription;
@property (nonatomic) NSString *author;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSString *relativeDate;
@property (nonatomic) UIImage *media;
@property (nonatomic) UIImage *blurredBackground;
@end