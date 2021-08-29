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

- (void)theme_setBackgroundColor:(nullable UIColor *)color forName:(NSString *)name {
    NSDictionary<NSString *,id> *theme = [NSDictionary dictionaryWithObjectsAndKeys:color, UIViewThemeBackgroundColor, nil];
    [[XHBThemeManager sharedManager] setTheme:theme forName:name view:self];
}

- (void)shouldUpdateTheme:(NSDictionary<NSString *,id> *)theme forName:(NSString *)name {
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
