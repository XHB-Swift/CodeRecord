//
//  UIView+XHBTheme.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/8/21.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "UIView+XHBTheme.h"

#define UIViewThemeBackgroundColor @"UIViewThemeBackgroundColor"

@implementation UIView (XHBTheme)

- (void)theme_setBackgroundColor:(UIColor *)color forStyle:(XHBThemeStyle)style inScene:(id)scene {
    NSDictionary<NSString *,id> *theme = [NSDictionary dictionaryWithObjectsAndKeys:color, UIViewThemeBackgroundColor, nil];
    [[XHBThemeManager sharedManager] setTheme:theme style:style forView:self inScene:scene];
}

- (void)updateTheme:(id)theme forStyle:(XHBThemeStyle)style {
    if (![theme isKindOfClass:[NSDictionary class]]) {
        return;
    }
    UIColor *bgColor = theme[UIViewThemeBackgroundColor];
    if (![bgColor isKindOfClass:[UIColor class]]) {
        return;
    }
    self.backgroundColor = bgColor;
}

@end
