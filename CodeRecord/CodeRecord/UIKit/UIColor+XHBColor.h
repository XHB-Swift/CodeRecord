//
//  UIColor+XHBColor.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/8/21.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (XHBColor)

+ (UIColor *)colorShortCutWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+ (UIColor *)colorShortCutWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

+ (UIColor *)colorWithARGBString:(NSString *)argbStr;

+ (UIColor *)randomBackgroundColor;
+ (NSString *)randomBackgroundColorStr;
+ (NSArray<NSString *> *)randomBackgroundColorsStrArray;

#define XHBColorMake(color, a) \
[UIColor colorWithHexString:(color) alpha:(a)]

@end

NS_ASSUME_NONNULL_END
