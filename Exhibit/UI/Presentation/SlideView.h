//
// Created by Simon de Carufel on 15-06-04.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Moment;


@interface SlideView : UIView
- (instancetype)initWithMoment:(Moment *)moment moveLeft:(BOOL)moveLeft;
- (void)presentMoment:(void (^)(void))completion;
- (void)dismissMoment:(void (^)(void))completion;
@end