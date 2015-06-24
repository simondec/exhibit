//
// Created by Simon de Carufel on 15-06-19.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface RootView : UIView
@property (nonatomic) UIView *leftPanelView;
@property (nonatomic) UIView *rightPanelView;
- (instancetype)initWithUserInterfaceIdiom:(UIUserInterfaceIdiom)idiom;
- (void)preparePanelsForDisplay;
- (void)displayLeftPanelWithDelay:(CGFloat)delay;
- (void)displayRightPanelWithDelay:(CGFloat)delay;
- (void)hideLeftPanel:(void (^)(void))completion;
- (void)hideRightPanel:(void (^)(void))completion;
@end