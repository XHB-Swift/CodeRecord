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

- (void)theme_setBackgroundColor:(UIColor *)color forStyle:(XHBThemeStyle)style inScene:(id)scene;

@end

NS_ASSUME_NONNULL_END
