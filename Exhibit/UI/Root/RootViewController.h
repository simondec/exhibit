//
// Created by Simon de Carufel on 15-06-19.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Settings;
@protocol RootViewControllerDelegate;


@interface RootViewController : UIViewController
@property (nonatomic, weak) id <RootViewControllerDelegate> delegate;
- (instancetype)initWithSettings:(Settings *)settings secondaryScreenConnected:(BOOL)connected;
- (void)setSecondaryScreenConnected:(BOOL)connected;
@end

@protocol RootViewControllerDelegate <NSObject>
- (void)rootViewControllerStartSlideshowButtonTapped;
@end