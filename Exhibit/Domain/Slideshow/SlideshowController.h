//
// Created by Simon de Carufel on 15-06-02.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Configuration;
@class Moment;
@class TTTTimeIntervalFormatter;

@protocol SlideshowObserver;


@interface SlideshowController : NSObject
- (void)addSlideshowObserver:(id <SlideshowObserver>)observer;
- (void)removeSlideshowObserver:(id <SlideshowObserver>)observer;
- (instancetype)initWithConfiguration:(Configuration *)configuration;
- (void)didSelectMomentAtChronologicalIndex:(NSUInteger)index;
- (NSTimeInterval)slideDuration;
- (NSInteger)numberOfMoments;
- (NSURL *)momentMediaURLAtChronologicalIndex:(NSUInteger)index;

- (void)startSlideshow;
@end

@protocol SlideshowObserver <NSObject>
@optional
- (void)displayMoment:(Moment *)moment atChronologicalIndex:(NSInteger)index;
- (void)didLoadMoments:(NSInteger)numberOfMoments;
@end