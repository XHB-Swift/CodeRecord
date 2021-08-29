//
//  UIView+XHBTheme.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/8/21.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "XHBThemeManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XHBTheme) <XHBThemeObject>

- (void)theme_setBackgroundColor:(nullable UIColor *)color forName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
