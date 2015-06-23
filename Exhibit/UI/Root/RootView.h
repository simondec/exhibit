//
// Created by Simon de Carufel on 15-06-19.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface RootView : UIView
@property (nonatomic) UIView *leftPaneView;
@property (nonatomic) UIView *rightPaneView;
- (void)preparePanelsForDisplay;
- (void)displayPanels;
- (void)hidePanels:(void (^)(void))completion;
@end