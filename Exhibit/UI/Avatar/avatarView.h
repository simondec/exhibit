//
// Created by Simon de Carufel on 15-06-04.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface AvatarView : UIView
- (instancetype)initWithFrame:(CGRect)frame borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
- (instancetype)initWithFrame:(CGRect)frame borderWidth:(CGFloat)borderWidth;
- (void)setImage:(UIImage *)image;
@end