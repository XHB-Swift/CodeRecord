//
//  UILabel+XHBTheme.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/8/21.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "UIView+XHBTheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (XHBTheme) <XHBThemeObject>

- (void)theme_setFont:(nullable UIFont *)font forName:(NSString *)name;
- (void)theme_setTextColor:(nullable UIColor *)textColor forName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
