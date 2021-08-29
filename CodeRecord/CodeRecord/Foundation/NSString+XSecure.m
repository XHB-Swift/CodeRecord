//
//  NSString+XSecure.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2020/4/16.
//  Copyright © 2020 谢鸿标. All rights reserved.
//

#import "NSString+XSecure.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (XSecure)

+ (NSString *)xcr_round2StringWithFloat:(float)f {
    return [self xcr_roundStringWithFloat:f digit:2];
}

+ (NSString *)xcr_round2StringWithDouble:(double)d {
    return [self xcr_roundStringWithDouble:d digit:2];
}

+ (NSString *)xcr_round3StringWithFloat:(float)f {
    return [self xcr_roundStringWithFloat:f digit:3];
}

+ (NSString *)xcr_round3StringWithDouble:(double)d {
    return [self xcr_roundStringWithDouble:d digit:3];
}

+ (NSString *)xcr_roundStringWithFloat:(float)f digit:(NSUInteger)digit {
    float u = powf(10, digit);
    float r = ((NSUInteger)roundf(f * u)) / u;
    NSNumber *number = @(r);
    return number.stringValue;
}

+ (NSString *)xcr_roundStringWithDouble:(double)d digit:(NSUInteger)digit {
    double u = pow(10, digit);
    double r = ((NSUInteger)round(d * u)) / u;
    NSNumber *number = @(r);
    return number.stringValue;
}

+ (NSString *)xcr_asciiVisble {
    NSMutableString *ascii = [NSMutableString stringWithCapacity:94];
    for (unichar i = 33; i < 127; i += 1) {
        [ascii appendFormat:@"%c", i];
    }
    return [NSString stringWithString:ascii];
}

+ (NSString *)xcr_numberTable {
    NSMutableString *numbers = [NSMutableString stringWithCapacity:10];
    for (unichar i = 48; i < 57; i += 1) {
        [numbers appendFormat:@"%c", i];
    }
    return [NSString stringWithString:numbers];
}

+ (NSString *)xcr_base64Table {
    return @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
}

+ (NSString *)xcr_stringTableForType:(XStringTableType)tpye {
    switch (tpye) {
        case XStringTableTypeASCII:
            return [self xcr_asciiVisble];
        case XStringTableTypeNumber:
            return [self xcr_numberTable];
        default:
            return [self xcr_base64Table];
    }
}

+ (NSString *)xcr_randomStringWithLength:(NSUInteger)length fromType:(XStringTableType)type {
    NSString *stringTable = [self xcr_stringTableForType:type];
    NSUInteger stringLength = stringTable.length;
    NSUInteger defaultLength = (length > 0 ? length : 32);
    NSMutableString *randomString = [NSMutableString stringWithCapacity:defaultLength];
    for (NSUInteger i = 0; i < defaultLength; i += 1) {
        NSUInteger index = (arc4random() % stringLength);
        unichar c = [stringTable characterAtIndex:index];
        [randomString appendFormat:@"%c",c];
    }
    return [NSString stringWithString:randomString];
}

+ (nullable NSString *)xcr_hexStringFromData:(NSData *)data shouldUpperCase:(BOOL)upperCase {
    NSMutableString *hexString = nil;
    if ([data isKindOfClass:[NSData class]] && (data.length > 0)) {
        hexString = [NSMutableString string];
        unsigned char *bytes = (unsigned char *)data.bytes;
        NSUInteger length = data.length;
        for (NSUInteger i = 0; i < length; i += 1) {
            unsigned char byte = bytes[i];
            [hexString appendFormat:@"%02X",byte];
        }
    }
    return upperCase ? [hexString copy] : [hexString lowercaseString];
}

- (nullable NSData *)xcr_md5Sign {
    NSMutableData *md5Data = nil;
    if ((self.length > 0)) {
        md5Data = [NSMutableData data];
        const char *bytes = [self UTF8String];
        unsigned char md5[CC_MD5_DIGEST_LENGTH];
        CC_MD5(bytes, (uint32_t)strlen(bytes), md5);
        [md5Data appendBytes:md5 length:CC_MD5_DIGEST_LENGTH];
    }
    return [md5Data copy];
}

- (nullable NSData *)xcr_AESCrypto:(BOOL)crypto withKey:(NSString *)key {
    NSData *result = nil;
    if ([key isKindOfClass:[NSString class]]) {
        char keyPtr[kCCKeySizeAES128+1];
        bzero(keyPtr, sizeof(keyPtr));
        [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
        NSData *srcData = crypto ? [[NSData alloc] initWithBase64EncodedString:self options:(NSDataBase64DecodingIgnoreUnknownCharacters)] : [self dataUsingEncoding:NSUTF8StringEncoding];
        if (srcData) {
            const void *srcBytes = [srcData bytes];
            NSUInteger srcLength = [srcData length];
            NSUInteger dstLength = srcLength + kCCBlockSizeAES128;
            void *dstBytes = malloc(dstLength);
            bzero(dstBytes, dstLength);
            
            size_t outputLength = 0;
            CCOperation operation = crypto ? kCCDecrypt : kCCEncrypt;
            CCCryptorStatus status = CCCrypt(operation,
                                             kCCAlgorithmAES128,
                                             kCCOptionPKCS7Padding,
                                             keyPtr,
                                             kCCKeySizeAES128,
                                             NULL,
                                             srcBytes,
                                             srcLength,
                                             dstBytes,
                                             dstLength,
                                             &outputLength);
            if (status == kCCSuccess) {
                result = [NSData dataWithBytesNoCopy:dstBytes length:outputLength];
            }else {
                if (dstBytes) {
                    free(dstBytes);
                    dstBytes = NULL;
                }
            }
        }
    }
    return result;
}

- (nullable NSData *)xcr_RSAEncryptWithKey:(id)publicKey {
    NSData *result = nil;
    if (publicKey) {
        SecKeyRef key = (__bridge SecKeyRef)publicKey;
        size_t srcLength = [self length];
        const uint8_t *srcBytes = (const uint8_t *)[self UTF8String];
        size_t dstLength = SecKeyGetBlockSize(key);
        uint8_t *dstBytes = malloc(dstLength);
        bzero(dstBytes, dstLength);
        OSStatus status = SecKeyEncrypt(key,
                                        kSecPaddingPKCS1,
                                        srcBytes,
                                        srcLength,
                                        dstBytes,
                                        &dstLength);
        if (status == errSecSuccess) {
            result = [NSData dataWithBytesNoCopy:dstBytes length:dstLength];
        }else {
            if (dstBytes) {
                free(dstBytes);
                dstBytes = NULL;
            }
        }
    }
    return result;
}

- (NSString *)xcr_URLEncoding {
    /**
     AFNetworking/AFURLRequestSerialization.m
     
     Returns a percent-escaped string following RFC 3986 for a query string key or value.
     RFC 3986 states that the following characters are "reserved" characters.
        - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
        - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
     In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
     query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
     should be percent-escaped in the query string.
        - parameter string: The string to be percent-escaped.
        - returns: The percent-escaped string.
     */
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < self.length) {
        NSUInteger length = MIN(self.length - index, batchSize);
        NSRange range = NSMakeRange(index, length);
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [self rangeOfComposedCharacterSequencesForRange:range];
        NSString *substring = [self substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    return escaped;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    unichar c = [self characterAtIndex:idx];
    return [NSString stringWithFormat:@"%c",c];
}

- (NSString *)xcr_stringAtIndex:(NSInteger)idx {
    NSUInteger length = [self length];
    if (length > idx && idx > -1) {
        return self[idx];
    }else {
        NSUInteger absIdx = 0;
        if (idx < 0) {
            absIdx = idx * -1;
            if (absIdx >= length) {
                absIdx = length - (absIdx % length);
            }else {
                absIdx = length - absIdx;
            }
        }else {
            absIdx = idx % length;
        }
        return self[absIdx];
    }
}

@end
