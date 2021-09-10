//
//  UILabel+XHBTheme.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/8/21.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "UILabel+XHBTheme.h"
#import "XHBThemeManager.h"

#define UILabelThemeFont @"UILabelThemeFont"
#define UILabelThemeTextColor @"UILabelThemeTextColor"


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

//- (void)updateTheme:(XHBTheme *)theme forStyle:(XHBThemeStyle)style {
//    [super updateTheme:theme forStyle:style];
//    if ([theme isKindOfClass:[UIFont class]]) {
//        self.font = theme;
//    }
//    if ([theme isKindOfClass:[UIColor class]]) {
//        self.textColor = theme;
//    }
//}

@end
