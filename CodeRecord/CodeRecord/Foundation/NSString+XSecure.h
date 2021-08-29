//
//  NSString+XSecure.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2020/4/16.
//  Copyright © 2020 谢鸿标. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XStringTableType){
    XStringTableTypeASCII, //ASCII可见字符表
    XStringTableTypeNumber, //纯数字
    XStringTableTypeBase64, //Base64字符表
};

@interface NSString (XSecure)

/// 浮点数四舍五入保留2位
/// @param f 浮点数
+ (NSString *)xcr_round2StringWithFloat:(float)f;

/// 浮点数四舍五入保留2位
/// @param d 浮点数
+ (NSString *)xcr_round2StringWithDouble:(double)d;

/// 浮点数四舍五入保留3位
/// @param f 浮点数
+ (NSString *)xcr_round3StringWithFloat:(float)f;

/// 浮点数四舍五入保留3位
/// @param d 浮点数
+ (NSString *)xcr_round3StringWithDouble:(double)d;

/// 浮点数四舍五入
/// @param f 浮点数
/// @param digit 保留小数位数
+ (NSString *)xcr_roundStringWithFloat:(float)f digit:(NSUInteger)digit;

/// 浮点数四舍五入
/// @param d 浮点数
/// @param digit 保留小数位数
+ (NSString *)xcr_roundStringWithDouble:(double)d digit:(NSUInteger)digit;

/// 生成字符表
/// @param tpye 字符表类型
+ (NSString *)xcr_stringTableForType:(XStringTableType)tpye;

/// 生成随机字符串
/// @param length 字符串长度（<=0时默认为32位）
/// @param type 字符表类型
+ (NSString *)xcr_randomStringWithLength:(NSUInteger)length fromType:(XStringTableType)type;

/// 将字节流用十六进制字符串表示
/// @param data 字节流
/// @param upperCase 是否大写
+ (nullable NSString *)xcr_hexStringFromData:(NSData *)data shouldUpperCase:(BOOL)upperCase;

/// MD5签名，可使用"xcr_hexStringFromData:shouldUpperCase:"转成字符串
- (nullable NSData *)xcr_md5Sign;

/// AES加解密
/// @param crypto YES解密，NO加密
/// @param key AES的密钥
- (nullable NSData *)xcr_AESCrypto:(BOOL)crypto withKey:(NSString *)key;

/// RSA加密
/// @param publicKey 公钥（SecKeyRef类型）
- (nullable NSData *)xcr_RSAEncryptWithKey:(id)publicKey;

/// 参数URL编码
- (NSString *)xcr_URLEncoding;

/// 下标访问字符串
/// @param idx 下标
- (id)objectAtIndexedSubscript:(NSUInteger)idx;

/// 任意整数下标访问字符串
/// @param idx 任意整数下标
- (NSString *)xcr_stringAtIndex:(NSInteger)idx;

@end

NS_ASSUME_NONNULL_END
