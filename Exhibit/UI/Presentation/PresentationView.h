//
// Created by Simon de Carufel on 15-06-02.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Moment;


@interface PresentationView : UIView
- (void)transitionToMoment:(Moment *)moment duration:(NSTimeInterval)duration;
@end