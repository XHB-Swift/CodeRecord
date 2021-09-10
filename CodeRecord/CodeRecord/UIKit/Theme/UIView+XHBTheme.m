//
//  UIView+XHBTheme.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/8/21.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "UIView+XHBTheme.h"

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
    if (keyPath.length > 0) {
        NSString *uKeyPath = [keyPath stringByReplacingCharactersInRange:(NSRange){0,1} withString:[[keyPath substringToIndex:1] uppercaseString]];
        NSString *keyPathSetter = [NSString stringWithFormat:@"set%@:",uKeyPath];
        if ([self respondsToSelector:NSSelectorFromString(keyPathSetter)]) {
            [self setValue:[themeAttribute themeAttribute] forKeyPath:keyPath];
        }
    }
}

@end
