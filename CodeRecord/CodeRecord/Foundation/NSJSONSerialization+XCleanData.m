//
//  NSJSONSerialization+XCleanData.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2020/4/17.
//  Copyright © 2020 谢鸿标. All rights reserved.
//

#import "NSJSONSerialization+XCleanData.h"

@implementation NSJSONSerialization (XCleanData)

+ (nullable id)xcr_removeKeysWithNullValuesForJSONObject:(nullable id)JSONObject {
    
    if ([JSONObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[(NSArray *)JSONObject count]];
        for (id value in (NSArray *)JSONObject) {
            if (![value isEqual:[NSNull null]]) {
                [mutableArray addObject:[self xcr_removeKeysWithNullValuesForJSONObject:value]];
            }
        }
        return [NSArray arrayWithArray:mutableArray];
    } else if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:JSONObject];
        for (id <NSCopying> key in [(NSDictionary *)JSONObject allKeys]) {
            id value = (NSDictionary *)JSONObject[key];
            if (!value || [value isEqual:[NSNull null]]) {
                [mutableDictionary removeObjectForKey:key];
            } else if ([self xcr_isContainerObject:value]) {
                mutableDictionary[key] = [self xcr_removeKeysWithNullValuesForJSONObject:value];
            }
        }
        return [NSDictionary dictionaryWithDictionary:mutableDictionary];
    } else if ([JSONObject isKindOfClass:[NSSet class]]) {
        NSMutableSet *mutableSet = [NSMutableSet setWithSet:JSONObject];
        for (id value in (NSSet *)JSONObject) {
            if (![value isKindOfClass:[NSNull class]]) {
                [mutableSet addObject:[self xcr_removeKeysWithNullValuesForJSONObject:value]];
            }
        }
        return [NSSet setWithSet:mutableSet];
    } else if ([JSONObject isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return JSONObject;
}

+ (BOOL)xcr_isContainerObject:(id)object {
    return [object isKindOfClass:[NSSet class]] ||
           [object isKindOfClass:[NSArray class]] ||
           [object isKindOfClass:[NSDictionary class]];
}

+ (nullable id)xcr_JSONObjectWithData:(NSData *)data
                     options:(NSJSONReadingOptions)opt
                       error:(NSError *__autoreleasing  _Nullable *)error {
    id object = nil;
    if ([data isKindOfClass:[NSData class]]) {
        object = [self JSONObjectWithData:data options:opt error:error];
        object = [self xcr_removeKeysWithNullValuesForJSONObject:object];
    }
    return object;
}

+ (nullable NSString *)xcr_JSONStringFromObject:(id)object {
    NSString *JSONString = nil;
    if (object && [self isValidJSONObject:object]) {
        NSError *error = nil;
        NSData *data = [self dataWithJSONObject:object options:0 error:&error];
        if (!error) {
            JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }else {
            NSLog(@"error = %@", error);
        }
    }
    return JSONString;
}

@end
