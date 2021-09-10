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

- (void)theme_setFont:(UIFont *)font forStyle:(XHBThemeStyle)style inScene:(id)scene {
    NSDictionary<NSString *,id> *theme = [NSDictionary dictionaryWithObjectsAndKeys:font, UILabelThemeFont, nil];
    [[XHBThemeManager sharedManager] setTheme:theme style:style forView:self inScene:scene];
}

- (void)theme_setTextColor:(UIColor *)textColor forStyle:(XHBThemeStyle)style inScene:(id)scene {
    NSDictionary<NSString *,id> *theme = [NSDictionary dictionaryWithObjectsAndKeys:textColor, UILabelThemeTextColor, nil];
    [[XHBThemeManager sharedManager] setTheme:theme style:style forView:self inScene:scene];
}

- (void)updateTheme:(id)theme forStyle:(XHBThemeStyle)style {
    [super updateTheme:theme forStyle:style];
    if (![theme isKindOfClass:[NSDictionary class]]) {
        return;
    }
    UIFont *font = theme[UILabelThemeFont];
    if ([font isKindOfClass:[UIFont class]]) {
        self.font = font;
    }
    UIColor *textColor = theme[UILabelThemeTextColor];
    if ([textColor isKindOfClass:[UIColor class]]) {
        self.textColor = textColor;
    }
}

@end
