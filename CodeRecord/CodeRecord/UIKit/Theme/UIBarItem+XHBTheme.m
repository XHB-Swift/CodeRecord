//
//  UIBarItem+XHBTheme.m
//  CodeRecord
//
//  Created by xiehongbiao on 2021/9/17.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "UIBarItem+XHBTheme.h"

@implementation UIBarItem (XHBTheme)

- (void)theme_setImage:(id)image forStyle:(XHBThemeStyle)style inScene:(id)scene {
    if (![image isKindOfClass:[NSURL class]] ||
        ![image isKindOfClass:[NSString class]]) {
        return;
    }
    XHBTheme *theme = [[XHBTheme alloc] init];
    theme.keyPath = @"image";
    theme.themeAttribute = image;
    [[XHBThemeManager sharedManager] setTheme:theme style:style forView:self inScene:scene];
}

- (void)updateTheme:(XHBTheme *)theme forStyle:(XHBThemeStyle)style {
    
}

@end
