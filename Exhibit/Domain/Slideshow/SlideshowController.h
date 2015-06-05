//
// Created by Simon de Carufel on 15-06-02.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Configuration;
@class Moment;
@class TTTTimeIntervalFormatter;

@protocol SlideshowDisplay;
@protocol SlideshowControl;


@interface SlideshowController : NSObject
@property (nonatomic, weak) id <SlideshowDisplay> slideshowDisplayDelegate;
@property (nonatomic, weak) id <SlideshowControl> slideshowControlDelegate;
- (instancetype)initWithConfiguration:(Configuration *)configuration;
- (void)didSelectMomentAtIndex:(NSUInteger)index;

- (NSInteger)numberOfMoments;
- (NSURL *)momentMediaURLAtIndex:(NSUInteger)index;

- (void)startSlideshow;
@end

@protocol SlideshowDisplay <NSObject>
@optional
- (void)displayMoment:(Moment *)moment duration:(NSTimeInterval)duration;
@end

@protocol SlideshowControl <NSObject>
@optional
- (void)didLoadMoments;
- (void)displayingMomentAtIndex:(NSInteger)index;
@end