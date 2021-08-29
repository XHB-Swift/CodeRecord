//
//  UIImage+XHBImage.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/8/21.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "UIImage+XHBImage.h"

@implementation UIImage (XHBImage)

+ (nullable UIImage *)imageWithColor:(nullable UIColor *)color
                                size:(CGSize)size {
    return [UIImage imageWithColor:color size:size cornerRadius:0];
}

+ (nullable UIImage *)imageWithColor:(nullable UIColor *)color
                                size:(CGSize)size
                        cornerRadius:(CGFloat)radius {
    return [UIImage imageWithColor:color size:size cornerRadius:radius rectCorner:(UIRectCornerAllCorners)];
}

+ (nullable UIImage *)imageWithColor:(nullable UIColor *)color
                                size:(CGSize)size
                        cornerRadius:(CGFloat)radius
                          rectCorner:(UIRectCorner)corner {
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:(CGSize){radius,radius}];
    [cornerPath addClip];
    [cornerPath fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (nullable UIImage *)decodedImage {
    CGImageRef imageRef = self.CGImage;
    if (imageRef == NULL) {
        return nil;
    }
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    if (colorSpace == NULL) {
        return nil;
    }
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    if (dataProvider == NULL) {
        return nil;
    }
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    if (data == NULL) {
        return nil;
    }
    CGDataProviderRef newDataProvider = CGDataProviderCreateWithCFData(data);
    CFRelease(data);
    if (newDataProvider == NULL) {
        return nil;
    }
    CGImageRef newImageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpace, bitmapInfo, newDataProvider, NULL, false, kCGRenderingIntentDefault);
    CFRelease(newDataProvider);
    if (newImageRef == NULL) {
        return nil;
    }
    UIImage *decodeImage = [[UIImage alloc] initWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return decodeImage;
}

- (nullable UIImage *)croppedImageInRect:(CGRect)rect {
    UIImage *cropImage = nil;
    CGSize imageSize = self.size;
    CGRect imageBounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    if (CGRectContainsRect(rect, imageBounds)) {
        CGImageRef imageRef = self.CGImage;
        CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef,rect);
        cropImage = [UIImage imageWithCGImage:imagePartRef];
        CGImageRelease(imagePartRef);
    }
    return cropImage;
}

- (nullable UIImage *)resizedImageToSize:(CGSize)size {
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    [self drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
