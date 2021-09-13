//
//  UIView+XHBTheme.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/8/21.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "UIView+XHBTheme.h"
#import "NSObject+XHBExtension.h"

@implementation UIView (XHBTheme)

- (void)theme_setBackgroundColor:(XHBThemeAttributeColor *)color forStyle:(XHBThemeStyle)style inScene:(id)scene {
    XHBTheme *theme = [[XHBTheme alloc] init];
    theme.keyPath = @"backgroundColor";
    theme.themeAttribute = color;
    [[XHBThemeManager sharedManager] setTheme:theme style:style forView:self inScene:scene];
}

- (void)updateTheme:(XHBTheme *)theme forStyle:(XHBThemeStyle)style {
    if (![theme isKindOfClass:[XHBTheme class]]) {
        return;
    }
    id<XHBThemeAttribute> themeAttribute = [theme themeAttribute];
    if (![themeAttribute respondsToSelector:@selector(themeAttribute)]) {
        return;
    }
    NSString *keyPath = theme.keyPath;
    if ([self hasPropertyWithName:keyPath]) {
        [self setValue:[themeAttribute themeAttribute] forKeyPath:keyPath];
    }
}

@end

@implementation UILabel (XHBTheme)

- (void)theme_setFont:(XHBThemeAttributeFont *)font forStyle:(XHBThemeStyle)style inScene:(id)scene {
    XHBTheme *theme = [[XHBTheme alloc] init];
    theme.keyPath = @"font";
    theme.themeAttribute = font;
    [[XHBThemeManager sharedManager] setTheme:theme style:style forView:self inScene:scene];
}

- (void)theme_setTextColor:(XHBThemeAttributeColor *)textColor forStyle:(XHBThemeStyle)style inScene:(id)scene {
    XHBTheme *theme = [[XHBTheme alloc] init];
    theme.keyPath = @"textColor";
    theme.themeAttribute = textColor;
    [[XHBThemeManager sharedManager] setTheme:theme style:style forView:self inScene:scene];
}

- (void)theme_setShadowColor:(XHBThemeAttributeColor *)shadowColor forStyle:(XHBThemeStyle)style inSecene:(id)scene {
    XHBTheme *theme = [[XHBTheme alloc] init];
    theme.keyPath = @"shadowColor";
    theme.themeAttribute = shadowColor;
    [[XHBThemeManager sharedManager] setTheme:theme style:style forView:self inScene:scene];
}

- (void)theme_setAttributedText:(XHBThemeAttributeRictText *)attributedText forStyle:(XHBThemeStyle)style inScene:(id)scene {
    XHBTheme *theme = [[XHBTheme alloc] init];
    theme.keyPath = @"attributedText";
    theme.themeAttribute = attributedText;
    [[XHBThemeManager sharedManager] setTheme:theme style:style forView:self inScene:scene];
}

@end

