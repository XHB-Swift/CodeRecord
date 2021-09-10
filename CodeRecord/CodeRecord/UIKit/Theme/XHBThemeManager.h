//
//  XHBThemeManager.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/8/21.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "XHBThemeAttribute.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString *XHBThemeStyle;

UIKIT_EXTERN XHBThemeStyle const XHBThemeStyleDark;
UIKIT_EXTERN XHBThemeStyle const XHBThemeStyleLight;

@interface XHBTheme: NSObject

@property (nonatomic, nullable, strong) NSString *keyPath;
@property (nonatomic, nullable, strong) NSString *selector;
@property (nonatomic, nullable, strong) id<XHBThemeAttribute> themeAttribute;

@end


@protocol XHBThemeUpdatable <NSObject>

@optional

- (void)updateTheme:(XHBTheme *)theme forStyle:(XHBThemeStyle)style;

@end

@interface XHBThemeManager : NSObject

+ (instancetype)sharedManager;

- (void)setTheme:(XHBTheme *)theme style:(XHBThemeStyle)style forView:(id<XHBThemeUpdatable>)view inScene:(id)scene;

- (void)switchToStyle:(XHBThemeStyle)style;

- (void)cleanForView:(id<XHBThemeUpdatable>)view inScene:(id)scene;

- (void)cleanInScene:(id)scene;

@end

NS_ASSUME_NONNULL_END
