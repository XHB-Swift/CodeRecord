//
//  UILabel+XHBTheme.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/8/21.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "UIView+XHBTheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (XHBTheme) <XHBThemeUpdatable>

- (void)theme_setFont:(UIFont *)font forStyle:(XHBThemeStyle)style inScene:(id)scene;
- (void)theme_setTextColor:(UIColor *)textColor forStyle:(XHBThemeStyle)style inScene:(id)scene;

@end

NS_ASSUME_NONNULL_END
