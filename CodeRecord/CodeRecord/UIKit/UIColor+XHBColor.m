//
//  UIColor+XHBColor.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/8/21.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "UIColor+XHBColor.h"

static inline NSUInteger hexStrToInt(NSString *str) {
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}

@implementation UIColor (XHBColor)

+ (UIColor *)colorShortCutWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

+ (UIColor *)colorShortCutWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    return [self colorWithHexString:hexString alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }
    if ([hexString length] != 6 && [hexString length] != 8) {
        return nil;
    }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^a-fA-F|0-9]" options:0 error:NULL];
    NSUInteger match = [regex numberOfMatchesInString:hexString options:NSMatchingReportCompletion range:NSMakeRange(0, [hexString length])];
    if (match != 0) {
        return nil;
    }
    
    UIColor *hexColor = [self colorWithARGBString:hexString];
    if (alpha < 0.99) {
        hexColor = [hexColor colorWithAlphaComponent:alpha];
    }
    return hexColor;
}

+ (UIColor *)colorWithARGBString:(NSString *)argbStr {
    argbStr = [argbStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    argbStr = [argbStr uppercaseString];
    if ([argbStr hasPrefix:@"#"]) {
        argbStr = [argbStr substringFromIndex:1];
    }
    
    if ([argbStr length] == 8) {
        CGFloat a, r, g, b;
        a = hexStrToInt([argbStr substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        r = hexStrToInt([argbStr substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        g = hexStrToInt([argbStr substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        b = hexStrToInt([argbStr substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    else if ([argbStr length] == 6) {
        CGFloat r, g, b;
        r = hexStrToInt([argbStr substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        g = hexStrToInt([argbStr substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        b = hexStrToInt([argbStr substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        return [UIColor colorWithRed:r green:g blue:b alpha:1.f];
    }
    else {
        return nil;
    }
}

+ (NSString *)randomBackgroundColorStr {
    NSArray *colorHexStrArray = [[self class] randomBackgroundColorsStrArray];
    NSInteger index = arc4random() % (colorHexStrArray.count);
    return [colorHexStrArray objectAtIndex:index];
}

+ (NSArray<NSString *> *)randomBackgroundColorsStrArray {
    return @[@"D4EABD", @"EAE2BD", @"B5ABAE", @"D8CAE0", @"BAC5BA", @"D6EDF1", @"EABDD1", @"B1B4BB", @"EAC7BD", @"BDD8EA", @"B8B394"];
}

+ (UIColor *)randomBackgroundColor {
    return [UIColor colorWithHexString:[self randomBackgroundColorStr]];
}


@end
