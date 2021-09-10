//
//  XHBThemeManager.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/8/21.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *XHBThemeStyle;

UIKIT_EXTERN XHBThemeStyle const XHBThemeStyleDark;
UIKIT_EXTERN XHBThemeStyle const XHBThemeStyleLight;


@protocol XHBThemeUpdatable <NSObject>

@optional

- (void)updateTheme:(id)theme forStyle:(XHBThemeStyle)style;

@end

@interface XHBThemeManager : NSObject

+ (instancetype)sharedManager;

- (void)setTheme:(id)theme style:(XHBThemeStyle)style forView:(id<XHBThemeUpdatable>)view inScene:(id)scene;

- (void)switchToStyle:(XHBThemeStyle)style;

- (void)cleanForView:(id<XHBThemeUpdatable>)view inScene:(id)scene;

- (void)cleanInScene:(id)scene;

@end

NS_ASSUME_NONNULL_END
