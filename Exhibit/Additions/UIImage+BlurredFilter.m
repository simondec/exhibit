//
// Created by Simon de Carufel on 15-06-04.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "UIImage+BlurredFilter.h"
#import "GPUImagePicture.h"
#import "GPUImageiOSBlurFilter.h"

@implementation UIImage (BlurredFilter)
- (UIImage *)blurredImage
{
    GPUImagePicture *imageSource = [[GPUImagePicture alloc] initWithImage:self];
    GPUImageiOSBlurFilter *blurFilter = [[GPUImageiOSBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = 6.0f;
    blurFilter.rangeReductionFactor = 0.3f;
    [imageSource addTarget:blurFilter];
    [blurFilter useNextFrameForImageCapture];
    [imageSource processImage];

    UIImage *blurredImage = [blurFilter imageFromCurrentFramebufferWithOrientation:self.imageOrientation];

    return blurredImage;
}
@end