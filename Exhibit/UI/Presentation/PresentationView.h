//
// Created by Simon de Carufel on 15-06-02.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Moment;
@protocol PresentationViewDelegate;
@class AUBOrganization;

@interface PresentationView : UIView
@property (nonatomic, weak) id <PresentationViewDelegate> delegate;
- (void)setOrganization:(AUBOrganization *)organization;
- (void)transitionToMoment:(Moment *)moment duration:(NSTimeInterval)duration;
@end

@protocol PresentationViewDelegate <NSObject>
- (void)didCompleteTransition;
@end