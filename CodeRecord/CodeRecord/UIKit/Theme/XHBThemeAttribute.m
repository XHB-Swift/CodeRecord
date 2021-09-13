//
//  XHBThemeAttribute.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/9/11.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "XHBThemeAttribute.h"
#import "XHBUIKitHeaders.h"

@implementation XHBThemeAttributeColor

+ (instancetype)attributeColorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    XHBThemeAttributeColor *color = [[XHBThemeAttributeColor alloc] init];
    color.hexColorString = [NSString stringWithFormat:@"%@", hexString];
    color.alpha = alpha;
    return color;
}

- (nullable id)themeAttribute {
    return [UIColor colorWithHexString:self.hexColorString alpha:self.alpha];
}

@end

@implementation XHBThemeAttributeFont

+ (instancetype)attributeFontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    XHBThemeAttributeFont *font = [[XHBThemeAttributeFont alloc] init];
    font.fontName = [NSString stringWithFormat:@"%@", fontName];
    font.fontSize = fontSize;
    return font;
}

- (nullable id)themeAttribute {
    if (![self.fontName isKindOfClass:[NSString class]]) {
        return nil;
    }
    return [UIFont fontWithName:self.fontName size:self.fontSize];
}

@end

@implementation XHBThemeAttributeRictText

+ (instancetype)attributeRichTextWithText:(NSString *)text attributes:(NSDictionary<NSAttributedStringKey,id> *)attributes {
    XHBThemeAttributeRictText *rtx = [[XHBThemeAttributeRictText alloc] init];
    rtx.text = text;
    rtx.attributes = attributes;
    return  rtx;
}

- (id)themeAttribute {
    if (![self.text isKindOfClass:[NSString class]]) {
        return nil;
    }
    return [[NSAttributedString alloc] initWithString:self.text attributes:self.attributes];
}

@end

@implementation NSValue (XHBThemeAttribute)

- (id)themeAttribute {
    return self;
}

@end

@implementation NSString (XHBThemeAttribute)

- (id)themeAttribute {
    return self;
}

@end

@implementation NSDictionary (XHBThemeAttribute)

- (id)themeAttribute {
    return self;
}

@end
