//
//  NSPropertyListSerialization+XPropertyLoader.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2020/4/17.
//  Copyright © 2020 谢鸿标. All rights reserved.
//

#import "NSPropertyListSerialization+XPropertyLoader.h"

@implementation NSPropertyListSerialization (XPropertyLoader)

+ (nullable NSArray *)xcr_arrayFromPlistData:(NSData *)plistData {
    return [self xcr_objectFromPlistData:plistData
                         withTargetClass:[NSArray class]
                                  option:(NSPropertyListImmutable)];
}

+ (nullable NSMutableArray *)xcr_mutableArrayFromPlistData:(NSData *)plistData {
    return [self xcr_objectFromPlistData:plistData
                         withTargetClass:[NSMutableArray class]
                                  option:NSPropertyListMutableContainersAndLeaves];
}

+ (nullable NSDictionary *)xcr_dictionaryFromPlistData:(NSData *)plistData {
    return [self xcr_objectFromPlistData:plistData
                         withTargetClass:[NSDictionary class]
                                  option:NSPropertyListImmutable];
}

+ (nullable NSMutableDictionary *)xcr_mutableDictionaryFromPlistData:(NSData *)plistData {
    return [self xcr_objectFromPlistData:plistData
                         withTargetClass:[NSMutableDictionary class]
                                  option:NSPropertyListMutableContainersAndLeaves];
}

+ (nullable NSArray *)xcr_arrayFromPlistFile:(NSString *)plistFile {
    return [self xcr_objectFromPlistFile:plistFile
                         withTargetClass:[NSArray class]
                                  option:NSPropertyListImmutable];
}

+ (nullable NSMutableArray *)xcr_mutableArrayFromPlistFile:(NSString *)plistFile {
    return [self xcr_objectFromPlistFile:plistFile
                         withTargetClass:[NSMutableArray class]
                                  option:NSPropertyListMutableContainersAndLeaves];
}

+ (nullable NSDictionary *)xcr_dictionaryFromPlistFile:(NSString *)plistFile {
    return [self xcr_objectFromPlistFile:plistFile
                         withTargetClass:[NSDictionary class]
                                  option:NSPropertyListImmutable];
}

+ (nullable NSMutableDictionary *)xcr_mutableDictionaryFromPlistFile:(NSString *)plistFile {
    return [self xcr_objectFromPlistFile:plistFile
                         withTargetClass:[NSMutableDictionary class]
                                  option:NSPropertyListMutableContainersAndLeaves];
}

+ (nullable NSArray *)xcr_arrayFromPlistName:(NSString *)plistName {
    return [self xcr_xcr_objectFromPlistName:plistName
                             withTargetClass:[NSArray class]
                                      option:NSPropertyListImmutable];
}

+ (nullable NSMutableArray *)xcr_mutableArrayFromPlistName:(NSString *)plistName {
    return [self xcr_xcr_objectFromPlistName:plistName
                             withTargetClass:[NSMutableArray class]
                                      option:NSPropertyListMutableContainersAndLeaves];
}

+ (nullable NSDictionary *)xcr_dictionaryFromPlistName:(NSString *)plistName {
    return [self xcr_xcr_objectFromPlistName:plistName
                             withTargetClass:[NSDictionary class]
                                      option:NSPropertyListImmutable];
}

+ (nullable NSMutableDictionary *)xcr_mutableDictionaryFromPlistName:(NSString *)plistName {
    return [self xcr_xcr_objectFromPlistName:plistName
                             withTargetClass:[NSMutableDictionary class]
                                      option:NSPropertyListMutableContainersAndLeaves];
}

+ (nullable id)xcr_xcr_objectFromPlistName:(NSString *)plistName
                           withTargetClass:(Class)targetClass
                                    option:(NSPropertyListMutabilityOptions)option {
    if (![plistName isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSString *file = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    return [self xcr_objectFromPlistFile:file
                         withTargetClass:targetClass
                                  option:option];
}

+ (nullable id)xcr_objectFromPlistFile:(NSString *)plistFile
                       withTargetClass:(Class)targetClass
                                option:(NSPropertyListMutabilityOptions)option {
    if (![plistFile isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSData *plistData = [NSData dataWithContentsOfFile:plistFile];
    return [self xcr_objectFromPlistData:plistData
                         withTargetClass:targetClass
                                  option:option];
}
 
+ (nullable id)xcr_objectFromPlistData:(NSData *)plistData
                       withTargetClass:(Class)targetClass
                                option:(NSPropertyListMutabilityOptions)option {
    if (![plistData isKindOfClass:[NSData class]]) {
        return nil;
    }
    if (targetClass == nil) {
        return nil;
    }
    NSError *error = nil;
    id object = [self propertyListWithData:plistData options:option format:NULL error:&error];
    if (![object isKindOfClass:targetClass]) {
        return nil;
    }
    return object;
}

@end
