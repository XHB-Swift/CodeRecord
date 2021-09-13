//
//  XHBThemeAttribute.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/9/11.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XHBThemeAttribute <NSObject>

- (nullable id)themeAttribute;

@end

@interface XHBThemeAttributeColor: NSObject <XHBThemeAttribute>

@property (nonatomic, strong) NSString *hexColorString;
@property (nonatomic, assign) CGFloat alpha;

+ (instancetype)attributeColorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

#define XHBThemeMakeColor(color,a) \
[XHBThemeAttributeColor attributeColorWithHexString:(color) alpha:(a)]

#define XHBThemeMakeNoAlphaColor(color) XHBThemeMakeColor((color),1)

@end

@interface XHBThemeAttributeFont: NSObject <XHBThemeAttribute>

@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, assign) CGFloat fontSize;

+ (instancetype)attributeFontWithName:(NSString *)fontName size:(CGFloat)fontSize;

#define XHBThemeMakeFont(f,s) \
[XHBThemeAttributeFont attributeFontWithName:(f) size:(s)]

@end

@interface XHBThemeAttributeRictText: NSObject<XHBThemeAttribute>

@property (nonatomic, strong) NSString *text;
@property (nonatomic, nullable, strong) NSDictionary<NSAttributedStringKey, id> *attributes;

+ (instancetype)attributeRichTextWithText:(NSString *)text attributes:(nullable NSDictionary<NSAttributedStringKey,id> *)attributes;

#define XHBThemeMakeRichText(txt,attrs) \
[XHBThemeAttributeRictText attributeRichTextWithText:(txt) attributes:(attrs)]

@end

@interface NSValue (XHBThemeAttribute) <XHBThemeAttribute>
@end

@interface NSString (XHBThemeAttribute) <XHBThemeAttribute>
@end

@interface NSDictionary (XHBThemeAttribute) <XHBThemeAttribute>
@end

NS_ASSUME_NONNULL_END
