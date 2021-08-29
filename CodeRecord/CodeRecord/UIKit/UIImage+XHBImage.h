//
//  UIImage+XHBImage.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/8/21.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (XHBImage)

+ (nullable UIImage *)imageWithColor:(nullable UIColor *)color
                                size:(CGSize)size;

+ (nullable UIImage *)imageWithColor:(nullable UIColor *)color
                                size:(CGSize)size
                        cornerRadius:(CGFloat)radius;

+ (nullable UIImage *)imageWithColor:(nullable UIColor *)color
                                size:(CGSize)size
                        cornerRadius:(CGFloat)radius
                          rectCorner:(UIRectCorner)corner;

- (nullable UIImage *)decodedImage;

- (nullable UIImage *)croppedImageInRect:(CGRect)rect;

- (nullable UIImage *)resizedImageToSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
