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

- (void)theme_setFont:(nullable UIFont *)font forName:(NSString *)name {
    NSDictionary<NSString *,id> *theme = [NSDictionary dictionaryWithObjectsAndKeys:font, UILabelThemeFont, nil];
    [[XHBThemeManager sharedManager] setTheme:theme forName:name view:self];
}

- (void)theme_setTextColor:(nullable UIColor *)textColor forName:(NSString *)name {
    NSDictionary<NSString *,id> *theme = [NSDictionary dictionaryWithObjectsAndKeys:textColor, UILabelThemeTextColor, nil];
    [[XHBThemeManager sharedManager] setTheme:theme forName:name view:self];
}

- (void)shouldUpdateTheme:(NSDictionary<NSString *,id> *)theme forName:(NSString *)name {
    [super shouldUpdateTheme:theme forName:name];
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
