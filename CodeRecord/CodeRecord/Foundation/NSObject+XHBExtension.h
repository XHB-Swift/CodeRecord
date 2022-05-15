//
//  NSObject+XHBExtension.h
//  CodeRecord
//
//  Created by xiehongbiao on 2021/9/13.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSError *NSErrorMake(NSErrorDomain errorDomain, NSInteger code, NSString *_Nullable localizedDescription);

#define XHB_WEAK_SELF_DECLARED \
__weak typeof(self) weakSelf = self;

#define NSErrorMarkFunc(code, desc) \
NSErrorMake([NSString stringWithFormat:@"%s",__func__], (code), (desc))

#define XHB_PROPERTY_DEFINED(RW, KEY, TYPE, NAME)\
@property (nonatomic, RW, KEY) TYPE NAME;

#define XHB_PROPERTY_DEFINED_READWRITE(KEY, TYPE, NAME)\
@property (nonatomic, readwrite, KEY) TYPE NAME;

#define XHB_PROPERTY_DEFINED_READONLY(KEY, TYPE, NAME)\
@property (nonatomic, readonly, KEY) TYPE NAME;

#define XHB_PROPERTY_DEFINED_READWRITE_COPY(TYPE, NAME)\
XHB_PROPERTY_DEFINED_READWRITE(copy, TYPE *, NAME)

#define XHB_PROPERTY_DEFINED_READWRITE_ASSIGN(TYPE, NAME)\
XHB_PROPERTY_DEFINED_READWRITE(assign, TYPE, NAME)

#define XHB_PROPERTY_DEFINED_READWRITE_STRONG(TYPE, NAME)\
XHB_PROPERTY_DEFINED_READWRITE(strong, TYPE *, NAME)

#define XHB_PROPERTY_DEFINED_READONLY_COPY(TYPE, NAME)\
XHB_PROPERTY_DEFINED_READONLY(copy, TYPE *, NAME)

#define XHB_PROPERTY_DEFINED_READONLY_ASSIGN(TYPE, NAME)\
XHB_PROPERTY_DEFINED_READONLY(assign, TYPE, NAME)

#define XHB_PROPERTY_DEFINED_READONLY_STRONG(TYPE, NAME)\
XHB_PROPERTY_DEFINED_READONLY(strong, TYPE *, NAME)

@interface NSObject (XHBExtension)

+ (nullable NSData *)archivedDataForObject:(id)object;
+ (nullable id)unarchivedObjectFromData:(NSData *)data expectedClasses:(nullable NSArray<Class> *)expectedClasses;

+ (nullable id)objectFromPlistName:(NSString *)plistName
                          inBundle:(nullable NSBundle *)bundle
                            option:(NSPropertyListMutabilityOptions)option;

//判断对象是否包含该属性
- (BOOL)hasPropertyWithName:(NSString *)propertyName;

@end

@interface NSDate (XHBExtension)

- (BOOL)isSameDate:(NSDate *)date;

@end

@interface NSString (XHBExtension)

+ (instancetype)asciiNumberTable;
+ (instancetype)asciiVisibleTable;
+ (instancetype)stringWithRoundedNumber:(NSNumber *)roundedNumber
                                  digit:(NSUInteger)digit
                             unitSymbol:(nullable NSString *)unitSymbol;
- (NSString *)md5String;
- (nullable NSString *)propertyToSetter;
- (nullable NSString *)stringAtIndex:(NSInteger)index;

@end

@interface NSDictionary (XHBExtension)

/// 对字典的values根据orderedKeys进行排序
/// @param orderedKeys 已排序的key名集合
/// @param string 所有值按顺序组合之后，可加上分割符，默认""
- (nullable NSString *)sortedValuesForOrderedKeys:(NSOrderedSet *)orderedKeys
                                   joinedByString:(nullable NSString *)string;

/// 对字典的values根据orderedKeys进行排序
/// @param orderedKeys 已排序的key名集合
/// @param filterNil 是否过滤nil值
/// @param string 所有值按顺序组合之后，可加上分割符，默认""
- (nullable NSString *)sortedValuesForOrderedKeys:(NSOrderedSet *)orderedKeys
                                        filterNil:(BOOL)filterNil
                                   joinedByString:(nullable NSString *)string;

/// 根据expectedKeys从字典取值
/// @param expectedKeys 期望获取到的值
- (nullable instancetype)fetchObjectsAndKeysWithExpectedKeys:(NSArray *)expectedKeys;

/// 根据expectedKeysMapping映射关系，将字典的值提取到新的字典，newDict[key1] = oldDict[key2]，@{key1 : key2}
/// @param expectedKeysMapping 映射关系
- (nullable instancetype)fetchObjectsAndKeysWithExpectedKeysMapping:(NSDictionary *)expectedKeysMapping;

/// 根据exceptedKeys从字典中排除key取值
/// @param exceptedKeys 需要被排除的key集合
- (nullable instancetype)fetchObjectsAndKeysWithExceptedKeys:(NSArray *)exceptedKeys;

/// 是否包含某个值
/// @param key 键名
- (BOOL)containsValueForKey:(id)key;

///=============================================================================
/// 获取字典中指定数据类型
///=============================================================================

- (int)intValueForKey:(id)key;
- (int)intValueForKey:(id)key fallback:(int)fallback;
- (BOOL)boolValueForKey:(id)key;
- (BOOL)boolValueForKey:(id)key fallback:(BOOL)fallback;
- (float)floatValueForKey:(id)key;
- (float)floatValueForKey:(id)key fallback:(float)fallback;
- (double)doubleValueForKey:(id)key;
- (double)doubleValueForKey:(id)key fallback:(double)fallback;
- (NSInteger)integerValueForKey:(id)key;
- (NSInteger)integerValueForKey:(id)key fallback:(NSInteger)fallback;
- (NSUInteger)unsignedIntegerForKey:(id)key;
- (NSUInteger)unsignedIntegerForKey:(id)key fallback:(NSUInteger)fallback;

- (nullable NSArray *)arrayValueForKey:(id)key;
- (nullable NSNumber *)numberValueForKey:(id)key;
- (nullable NSString *)stringValueForKey:(id)key;
- (nullable NSDictionary *)dictionaryValueForKey:(id)key;
- (nullable id)modelValueForKey:(id)key className:(NSString *)className;

///=============================================================================
/// 通过key-path取值
///=============================================================================

- (nullable NSArray *)arrayForKeyPath:(NSString *)keyPath;
- (nullable NSArray *)arrayForKeyPath:(NSString *)keyPath keyPathSeperator:(nullable NSString *)keyPathSeperator;

- (nullable NSString *)stringForKeyPath:(NSString *)keyPath;
- (nullable NSString *)stringForKeyPath:(NSString *)keyPath keyPathSeperator:(nullable NSString *)keyPathSeperator;

- (nullable NSNumber *)numberForKeyPath:(NSString *)keyPath;
- (nullable NSNumber *)numberForKeyPath:(NSString *)keyPath keyPathSeperator:(nullable NSString *)keyPathSeperator;

- (nullable NSDictionary *)dictionaryForKeyPath:(NSString *)keyPath;
- (nullable NSDictionary *)dictionaryForKeyPath:(NSString *)keyPath keyPathSeperator:(nullable NSString *)keyPathSeperator;

- (nullable id)objectForKeyPath:(NSString *)keyPath;
- (nullable id)objectForKeyPath:(NSString *)keyPath keyPathSeperator:(nullable NSString *)keyPathSeperator;
- (nullable id)objectForKeyPath:(NSString *)keyPath keyPathSeperator:(nullable NSString *)keyPathSeperator expectedClass:(nullable Class)expectedClass;

@end

@interface NSMutableDictionary (XHBExtension)

/// 根据键快速赋值到新字典
/// @param dictionary 数据源
/// @param expectedKeys 需要获取的值的key集合
- (void)addObjectsAndKeysFromDictionary:(NSDictionary *)dictionary expectedKeys:(NSArray *)expectedKeys;

/// 根据映射关系将值快速赋值到新字典
/// @param dictionary 数据源
/// @param expectedKeysMapping 映射关系
- (void)addObjectsAndKeysFromDictionary:(NSDictionary *)dictionary expectedKeysMapping:(NSDictionary *)expectedKeysMapping;

/// 根据键快速赋值到新字典
/// @param dictionary 数据源
/// @param exceptedKeys 需要排除的值的key集合
- (void)addObjectsAndKeysFromDictionary:(NSDictionary *)dictionary exceptedKeys:(NSArray *)exceptedKeys;

@end

@interface NSArray (XHBExtension)

- (nullable id)safeObjectAtIndex:(NSUInteger)index;
- (nullable id)safeObjectAtAnyIndex:(NSInteger)anyIndex;
- (nullable id)safeObjectAtRemindedIndex:(NSUInteger)remindedIndex;

@end

@interface NSMutableArray (XHBExtension)

- (void)reverse;

@end

typedef void(^XHBTimeUpdateAction)(NSTimeInterval timeInterval);

@interface NSTimer (XHBExtension)

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                        action:(nullable XHBTimeUpdateAction)action
                                       repeats:(BOOL)repeats;

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                        action:(nullable XHBTimeUpdateAction)action
                                       repeats:(BOOL)repeats
                               loopCommonModes:(BOOL)loopCommonModes;

@end

@interface CADisplayLink (XHBExtension)

+ (instancetype)displayLinkWithAction:(nullable XHBTimeUpdateAction)action
                      loopCommonModes:(BOOL)loopCommonModes;

+ (instancetype)displayLinkWithFrameInternal:(NSTimeInterval)timeInterval
                                      action:(nullable XHBTimeUpdateAction)action
                             loopCommonModes:(BOOL)loopCommonModes;

@end

@interface NSValue (XHBExtension)

- (BOOL)isCGRectValue;
- (BOOL)isCGSizeValue;
- (BOOL)isCGFloatValue;
- (BOOL)isCGPointValue;
- (BOOL)isUIOffsetValue;
- (BOOL)isCGVectorValue;
- (BOOL)isUIEdgeInsetsValue;
- (BOOL)isCATransform3DValue;
- (BOOL)isCGAffineTransformValue;

@end

NS_ASSUME_NONNULL_END
