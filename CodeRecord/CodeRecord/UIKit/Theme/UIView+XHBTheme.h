//
//  UIView+XHBTheme.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/8/21.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "XHBThemeManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XHBTheme) <XHBThemeUpdatable>

- (void)theme_setBackgroundColor:(XHBThemeAttributeColor *)color forStyle:(XHBThemeStyle)style inScene:(id)scene;

@end

@interface UILabel (XHBTheme)

- (void)theme_setFont:(XHBThemeAttributeFont *)font forStyle:(XHBThemeStyle)style inScene:(id)scene;
- (void)theme_setTextColor:(XHBThemeAttributeColor *)textColor forStyle:(XHBThemeStyle)style inScene:(id)scene;
- (void)theme_setShadowColor:(XHBThemeAttributeColor *)shadowColor forStyle:(XHBThemeStyle)style inSecene:(id)scene;
- (void)theme_setAttributedText:(XHBThemeAttributeRictText *)attributedText forStyle:(XHBThemeStyle)style inScene:(id)scene;

@end

NS_ASSUME_NONNULL_END
