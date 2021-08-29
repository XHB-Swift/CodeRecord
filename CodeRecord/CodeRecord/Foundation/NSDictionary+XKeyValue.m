//
//  NSDictionary+XKeyValue.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2020/4/16.
//  Copyright © 2020 谢鸿标. All rights reserved.
//

#import "NSDictionary+XKeyValue.h"

@implementation NSDictionary (XKeyValue)

- (nullable NSDictionary *)xcr_valuesForKeysRelation:(NSDictionary *)keysRelation {
    NSMutableDictionary *result = nil;
    if ([keysRelation isKindOfClass:[NSDictionary class]] &&
        (self.count > 0) &&
        (keysRelation.count > 0)) {
        result = [NSMutableDictionary dictionary];
        [keysRelation enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull srcKey,
                                                          id  _Nonnull dstKey,
                                                          BOOL * _Nonnull stop) {
            result[dstKey] = self[srcKey];
        }];
    }
    return [result copy];
}

- (nullable NSString *)xcr_sortedValuesForOrderedKeys:(NSOrderedSet *)orderedKeys
                                       joinedByString:(nullable NSString *)string {
    return [self xcr_sortedValuesForOrderedKeys:orderedKeys
                                      filterNil:YES
                                 joinedByString:string];
}

- (nullable NSString *)xcr_sortedValuesForOrderedKeys:(NSOrderedSet *)orderedKeys
                                            filterNil:(BOOL)filterNil
                                       joinedByString:(nullable NSString *)string {
    NSMutableString *result = nil;
    if ([orderedKeys isKindOfClass:[NSOrderedSet class]] &&
        (orderedKeys.count > 0) &&
        (self.count > 0)) {
        result = [NSMutableString string];
        NSString *defaultSeperator = string ?: @"";
        [orderedKeys enumerateObjectsUsingBlock:^(id  _Nonnull key,
                                                  NSUInteger idx,
                                                  BOOL * _Nonnull stop) {
            id value = self[key];
            BOOL isNilValue = (value == nil);
            if (!(filterNil && isNilValue)) {
                [result appendFormat:@"%@%@", value, defaultSeperator];
            }
        }];
    }
    return [result copy];
}

- (NSDictionary *)xcr_valuesForKeys:(NSSet *)keys {
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    if ([keys isKindOfClass:[NSSet class]] &&
        (keys.count > 0)) {
        [keys enumerateObjectsUsingBlock:^(id  _Nonnull key,
                                           BOOL * _Nonnull stop) {
            id value = self[key];
            if (value) {
                values[key] = value;
            }
        }];
    }
    return [values copy];
}

- (BOOL)xcr_containsObjectForKey:(id)key {
    return (key != nil) && (self[key] != nil);
}

#define XReturnValue(type,def,sel) \
type t =  def;\
if (key) { \
    id value = self[key]; \
    if ([value respondsToSelector:@selector(sel)]) { \
        t = [value sel]; \
    }\
}\
return t;\

- (int)xcr_intValueForKey:(id)key {
    XReturnValue(int, 0, intValue)
}

- (BOOL)xcr_boolValueForKey:(id)key {
    XReturnValue(BOOL, NO, boolValue)
}

- (float)xcr_floatValueForKey:(id)key {
    XReturnValue(float, 0.0, floatValue)
}

- (double)xcr_doubleValueForKey:(id)key {
    XReturnValue(double, 0.0, doubleValue)
}

- (NSInteger)xcr_integerValueForKey:(id)key {
    XReturnValue(NSInteger, 0, integerValue)
}

- (NSUInteger)xcr_unsignedIntegerValueForKey:(id)key {
    XReturnValue(NSUInteger, 0, unsignedIntegerValue)
}

#define XReturnObject(type) \
type *t = nil;\
if (key) { \
    t = self[key]; \
    if (![t isKindOfClass:[type class]]) { \
        t = nil;\
    }\
}\
return t;

- (nullable NSArray *)xcr_arrayValueForKey:(id)key {
    XReturnObject(NSArray)
}

- (nullable NSString *)xcr_stringValueForKey:(id)key {
    XReturnObject(NSString)
}

- (nullable NSNumber *)xcr_numberValueForKey:(id)key {
    XReturnObject(NSNumber)
}

@end
