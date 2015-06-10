//
// Created by Simon de Carufel on 15-06-02.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AUBOrganization;


@interface Settings : NSObject <NSCoding>
@property (nonatomic) AUBOrganization *organization;
@property (nonatomic) NSString *organizationID;
@property (nonatomic) NSTimeInterval slideDuration;
@property (nonatomic) NSTimeInterval recentMomentsLookupInterval;
@property (nonatomic) NSInteger slideCount;
@end
