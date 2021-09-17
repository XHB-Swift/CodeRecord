//
//  UIBarItem+XHBTheme.h
//  CodeRecord
//
//  Created by xiehongbiao on 2021/9/17.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "XHBThemeManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIBarItem (XHBTheme) <XHBThemeUpdatable>

- (void)theme_setImage:(id)image forStyle:(XHBThemeStyle)style inScene:(id)scene;

@end

NS_ASSUME_NONNULL_END
