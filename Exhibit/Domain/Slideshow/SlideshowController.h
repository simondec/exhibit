//
// Created by Simon de Carufel on 15-06-02.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Configuration;
@class Moment;
@protocol SlideshowObserver;


@interface SlideshowController : NSObject
- (instancetype)initWithConfiguration:(Configuration *)configuration;
- (void)addObserver:(id <SlideshowObserver>)observer;
- (void)removeObserver:(id <SlideshowObserver>)observer;
- (void)startSlideshow;
@end

@protocol SlideshowObserver <NSObject>
@optional
- (void)displayMoment:(Moment *)moment duration:(NSTimeInterval)duration;
@end