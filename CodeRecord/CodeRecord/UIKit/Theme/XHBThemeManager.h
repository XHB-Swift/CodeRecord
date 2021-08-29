//
//  XHBThemeManager.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/8/21.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XHBThemeObject <NSObject>

@optional

- (void)shouldUpdateTheme:(NSDictionary<NSString *,id> *)theme forName:(NSString *)name;

@end

@interface XHBThemeManager : NSObject

+ (instancetype)sharedManager;

- (void)setTheme:(NSDictionary<NSString *,id> *)theme forName:(NSString *)name view:(__kindof UIView<XHBThemeObject> *)view;
- (nullable NSDictionary<NSString *,id> *)themeForName:(NSString *)name withView:(__kindof UIView<XHBThemeObject> *)view;
- (void)removeThemeForName:(NSString *)name view:(__kindof UIView<XHBThemeObject> *)view;
- (void)removeThemeForName:(NSString *)name views:(NSArray<__kindof UIView<XHBThemeObject> *> *)views;
- (void)removeThemeForName:(NSString *)name;

- (void)updateThemeForName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
