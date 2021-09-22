//
//  UIBarItem+XHBTheme.m
//  CodeRecord
//
//  Created by xiehongbiao on 2021/9/17.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "UIBarItem+XHBTheme.h"

@implementation UIBarItem (XHBTheme)

- (void)theme_setImage:(id<XHBURLType, XHBThemeAttribute>)image forStyle:(XHBThemeStyle)style inScene:(id)scene {
    XHBTheme *theme = [[XHBTheme alloc] init];
    theme.keyPath = @"image";
    theme.themeAttribute = image;
    [[XHBThemeManager sharedManager] setTheme:theme style:style forView:self inScene:scene];
}

- (void)updateTheme:(XHBTheme *)theme forStyle:(XHBThemeStyle)style {
    if (![theme isKindOfClass:[XHBTheme class]]) {
        return;
    }
    NSString *keyPath = theme.keyPath;
    if (![keyPath isKindOfClass:[NSString class]] ||
        ![self hasPropertyWithName:keyPath]) {
        return;
    }
    id<XHBThemeAttribute> themeAttribute = [theme themeAttribute];
    
    if ([themeAttribute conformsToProtocol:@protocol(XHBURLType)] &&
        [themeAttribute respondsToSelector:@selector(url)]) {
        id<XHBURLType> imgUrl = (id<XHBURLType>)themeAttribute;
        __weak typeof(self) weakSelf = self;
        [UIImage fetchImageWithURL:imgUrl
                        completion:^(UIImage * _Nullable image,
                                     NSError * _Nullable error) {
            [weakSelf setValue:image forKeyPath:keyPath];
        }];
        return;
    }
    
    [self setValue:themeAttribute forKeyPath:keyPath];
}

@end

@implementation UIBarButtonItem (XHBTheme)

- (void)theme_setTintColor:(XHBThemeAttributeColor *)color forStyle:(XHBThemeStyle)style inSecene:(id)scene {
    XHBTheme *theme = [[XHBTheme alloc] init];
    theme.keyPath = @"tintColor";
    theme.themeAttribute = color;
    [[XHBThemeManager sharedManager] setTheme:theme style:style forView:self inScene:scene];
}

@end
