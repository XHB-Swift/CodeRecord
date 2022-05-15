//
//  NSObject+XHBExtension.m
//  CodeRecord
//
//  Created by xiehongbiao on 2021/9/13.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "NSObject+XHBExtension.h"
#import <CommonCrypto/CommonCrypto.h>
#import <objc/runtime.h>

NSError *NSErrorMake(NSErrorDomain errorDomain, NSInteger code, NSString *_Nullable localizedDescription) {
    NSDictionary<NSErrorUserInfoKey, id> *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      localizedDescription, NSLocalizedDescriptionKey, nil];
    return [NSError errorWithDomain:errorDomain code:code userInfo:userInfo];
}

@implementation NSObject (XHBExtension)

+ (instancetype)archivedDataForObject:(id)object {
    NSData *archivedData = nil;
    if (object && [object conformsToProtocol:@protocol(NSCoding)]) {
        SEL newSEL = NSSelectorFromString(@"archivedDataWithRootObject:requiringSecureCoding:error:");
        SEL oldSEL = NSSelectorFromString(@"archivedDataWithRootObject:");
        BOOL canExecuteNewMethod = (newSEL != NULL &&
                                    [NSKeyedArchiver respondsToSelector:newSEL]);
        IMP targetIMP = [NSKeyedArchiver methodForSelector:(canExecuteNewMethod ? newSEL : oldSEL)];
        if (targetIMP != NULL) {
            Class objectClass = [object class];
            Class archiverClass = [NSKeyedArchiver class];
            [NSKeyedArchiver setClassName:NSStringFromClass(objectClass) forClass:objectClass];
            if (canExecuteNewMethod) {
                NSData *(*func)(id,SEL,id,BOOL,NSError **) = (void *)targetIMP;
                NSError *error = nil;
                BOOL secureCoding = [object conformsToProtocol:@protocol(NSSecureCoding)];
                archivedData = func(archiverClass,newSEL,object,secureCoding,&error);
                if (error) {
                    NSLog(@"归档失败：%@",error);
                }
            }else {
                NSData *(*func)(id,SEL,id) = (void *)targetIMP;
                archivedData = func(archiverClass,oldSEL,object);
            }
        }
    }
    return archivedData;
}

+ (nullable id)unarchivedObjectFromData:(NSData *)data expectedClasses:(nullable NSArray<Class> *)expectedClasses {
    id unarchivedObject = nil;
    if ([data isKindOfClass:[NSData class]]) {
        SEL newSEL = NSSelectorFromString(@"unarchivedObjectOfClasses:fromData:error:");
        SEL oldSEL = NSSelectorFromString(@"unarchiveObjectWithData:");
        BOOL canExecuteNewMethod = (newSEL != NULL &&
                                    [NSKeyedUnarchiver respondsToSelector:newSEL]);
        IMP targetIMP = [NSKeyedUnarchiver methodForSelector:(canExecuteNewMethod ? newSEL : oldSEL)];
        if (targetIMP != NULL) {
            Class unarchivedClass = [NSKeyedUnarchiver class];
            if (canExecuteNewMethod) {
                NSError *error = nil;
                NSMutableArray<Class> *defaultClasses = [NSMutableArray arrayWithObjects:
                                                         [NSData class],
                                                         [NSDate class],
                                                         [NSNull class],
                                                         [NSValue class],
                                                         [NSString class],
                                                         [NSSet class],
                                                         [NSAttributedString class],
                                                         [NSArray class],
                                                         [NSDictionary class], nil];
                if ([expectedClasses isKindOfClass:[NSArray class]] &&
                    (expectedClasses.count > 0)) {
                    [defaultClasses addObjectsFromArray:expectedClasses];
                }
                id (*func)(id,SEL,NSSet<Class> *,NSData *,NSError **) = (void *)targetIMP;
                NSSet<Class> *classSet = [NSSet setWithArray:defaultClasses];
                unarchivedObject = func(unarchivedClass,newSEL,classSet,data,&error);
                if (error) {
                    NSLog(@"解档失败：%@", error);
                }
            }else {
                id (*func)(id,SEL,NSData *) = (void *)targetIMP;
                unarchivedObject = func(unarchivedClass,oldSEL,data);
            }
        }
    }
    return unarchivedObject;
}

+ (nullable id)objectFromPlistName:(NSString *)plistName
                          inBundle:(nullable NSBundle *)bundle
                            option:(NSPropertyListMutabilityOptions)option {
    
    if (![plistName isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSBundle *targetBundle = [bundle isKindOfClass:[NSBundle class]] ? bundle : [NSBundle mainBundle];
    NSString *plistFile = [targetBundle pathForResource:plistName ofType:@"plist"];
    if (![plistFile isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSData *plistData = [NSData dataWithContentsOfFile:plistFile];
    NSError *error = nil;
    return [NSPropertyListSerialization propertyListWithData:plistData options:option format:NULL error:&error];
}

- (BOOL)hasPropertyWithName:(NSString *)propertyName {
    NSString *setterName = [propertyName propertyToSetter];
    if (![setterName isKindOfClass:[NSString class]]) {
        return NO;
    }
    return [self respondsToSelector:NSSelectorFromString(setterName)];
}

@end

@implementation NSDate (XHBExtension)

- (BOOL)isSameDate:(NSDate *)date {
    BOOL isSame = NO;
    if ([date isKindOfClass:[NSDate class]]) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit calendarUnit = NSCalendarUnitYear |
                                      NSCalendarUnitMonth |
                                      NSCalendarUnitDay;
        NSDateComponents *comp1 = [calendar components:calendarUnit fromDate:self];
        NSDateComponents *comp2 = [calendar components:calendarUnit fromDate:date];
        isSame = (comp1.year == comp2.year) &&
                 (comp1.month == comp2.month) &&
                 (comp1.day == comp2.day);
    }
    return isSame;
}

@end

@implementation NSString (XHBExtension)

+ (instancetype)asciiNumberTable {
    NSMutableArray<NSString *> *numbers = [NSMutableArray arrayWithCapacity:10];
    for (unichar i = 48; i < 57; i += 1) {
        [numbers addObject:[NSString stringWithFormat:@"%c", i]];
    }
    return [numbers componentsJoinedByString:@","];
}

+ (instancetype)asciiVisibleTable {
    NSMutableArray<NSString *> *visibles = [NSMutableArray arrayWithCapacity:94];
    for (unichar i = 33; i < 127; i += 1) {
        [visibles addObject:[NSString stringWithFormat:@"%c", i]];
    }
    return [visibles componentsJoinedByString:@","];
}

+ (instancetype)stringWithRoundedNumber:(NSNumber *)roundedNumber digit:(NSUInteger)digit unitSymbol:(NSString *)unitSymbol {
    if (![roundedNumber isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    static NSNumberFormatter *numberFormatter = nil;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        numberFormatter = [[NSNumberFormatter alloc] init];
    });
    numberFormatter.decimalSeparator = @".";
    numberFormatter.maximumFractionDigits = digit;
    numberFormatter.positiveSuffix = unitSymbol;
    numberFormatter.roundingMode = NSNumberFormatterRoundHalfUp;
    return [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:roundedNumber]];
}

- (NSString *)md5String {
    NSMutableString *md5String = [NSMutableString string];
    
    const char *data = [self UTF8String];
    if (data != NULL) {
        CC_LONG dataLength = (CC_LONG)strlen(data);
        if (@available(iOS 13, *)) {
            unsigned char result[CC_SHA256_DIGEST_LENGTH];
            CC_SHA256(data, dataLength, result);
            for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i += 1) {
                [md5String appendFormat:@"%02x", result[i]];
            }
        }else {
            unsigned char result[CC_MD5_DIGEST_LENGTH];
            CC_MD5(data, dataLength, result);
            for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i += 1) {
                [md5String appendFormat:@"%02x", result[i]];
            }
        }
    }
    
    return [md5String copy];
}

- (NSString *)propertyToSetter {
    
    if (self.length == 0) {
        return nil;
    }
    
    NSString *upperCaseFirstProperty = [self stringByReplacingCharactersInRange:(NSRange){0,1}
                                                                     withString:[[self substringToIndex:1] uppercaseString]];
    return [NSString stringWithFormat:@"set%@:",upperCaseFirstProperty];
}

- (nullable NSString *)stringAtIndex:(NSInteger)index {
    NSUInteger length = [self length];
    if (length > index && index > -1) {
        unichar c = [self characterAtIndex:index];
        return [NSString stringWithFormat:@"%c", c];
    }else {
        NSUInteger absIdx = 0;
        if (index < 0) {
            absIdx = index * -1;
            if (absIdx >= length) {
                absIdx = length - (absIdx % length);
            }else {
                absIdx = length - absIdx;
            }
        }else {
            absIdx = index % length;
        }
        unichar c = [self characterAtIndex:absIdx];
        return [NSString stringWithFormat:@"%c", c];
    }
}

@end

@implementation NSDictionary (XHBExtension)

- (NSString *)sortedValuesForOrderedKeys:(NSOrderedSet *)orderedKeys joinedByString:(NSString *)string {
    return [self sortedValuesForOrderedKeys:orderedKeys filterNil:YES joinedByString:string];
}

- (NSString *)sortedValuesForOrderedKeys:(NSOrderedSet *)orderedKeys filterNil:(BOOL)filterNil joinedByString:(NSString *)string {
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

- (instancetype)fetchObjectsAndKeysWithExpectedKeys:(NSArray *)expectedKeys {
    if ([expectedKeys isKindOfClass:[NSArray class]]) {
        if (expectedKeys.count > 0) {
            NSSet *keys = [NSSet setWithArray:expectedKeys];
            NSMutableDictionary *newDictionary = [NSMutableDictionary dictionary];
            __weak typeof(self) weakSelf = self;
            [keys enumerateObjectsUsingBlock:^(id  _Nonnull key,
                                               BOOL * _Nonnull stop) {
                newDictionary[key] = weakSelf[key];
            }];
            return [self initWithDictionary:newDictionary];
        }else {
            return self;
        }
    }
    return nil;
}

- (nullable instancetype)fetchObjectsAndKeysWithExpectedKeysMapping:(NSDictionary *)expectedKeysMapping {
    if ([expectedKeysMapping isKindOfClass:[NSDictionary class]]) {
        if (expectedKeysMapping.count > 0) {
            NSMutableDictionary *newDictionary = [NSMutableDictionary dictionary];
            __weak typeof(self) weakSelf = self;
            [expectedKeysMapping enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key1,
                                                                     id  _Nonnull key2,
                                                                     BOOL * _Nonnull stop) {
                newDictionary[key1] = weakSelf[key2];
            }];
            return [self initWithDictionary:newDictionary];
        }else {
            return self;
        }
    }
    return nil;
}

- (nullable instancetype)fetchObjectsAndKeysWithExceptedKeys:(NSArray *)exceptedKeys {
    if ([exceptedKeys isKindOfClass:[NSArray class]]) {
        if (exceptedKeys.count > 0) {
            NSSet *exceptedKeysSet = [NSSet setWithArray:exceptedKeys];
            NSMutableSet *allKeysSet = [NSMutableSet setWithArray:[self allKeys]];
            [allKeysSet minusSet:exceptedKeysSet];
            NSMutableDictionary *newDictionary = [NSMutableDictionary dictionary];
            __weak typeof(self) weakSelf = self;
            [allKeysSet enumerateObjectsUsingBlock:^(id  _Nonnull key,
                                                     BOOL * _Nonnull stop) {
                newDictionary[key] = weakSelf[key];
            }];
            return [self initWithDictionary:newDictionary];
        }else {
            return self;
        }
    }
    return nil;
}

- (BOOL)containsValueForKey:(id)key {
    return (key != nil) && (self[key] != nil);
}

#define XReturnValue(type,def,sel) \
type t = def;\
if (key) { \
    id value = self[key]; \
    if ([value respondsToSelector:@selector(sel)]) { \
        t = [value sel]; \
    }\
}\
return t;\

- (int)intValueForKey:(id)key {
    return [self intValueForKey:key fallback:0];
}
- (int)intValueForKey:(id)key fallback:(int)fallback {
    XReturnValue(int, fallback, intValue)
}
- (BOOL)boolValueForKey:(id)key {
    return [self boolValueForKey:key fallback:NO];
}
- (BOOL)boolValueForKey:(id)key fallback:(BOOL)fallback {
    XReturnValue(BOOL, fallback, boolValue)
}
- (float)floatValueForKey:(id)key {
    return [self floatValueForKey:key fallback:0.0];
}
- (float)floatValueForKey:(id)key fallback:(float)fallback {
    XReturnValue(float, fallback, floatValue)
}
- (double)doubleValueForKey:(id)key {
    return [self doubleValueForKey:key fallback:0.0];
}
- (double)doubleValueForKey:(id)key fallback:(double)fallback {
    XReturnValue(double, fallback, doubleValue)
}
- (NSInteger)integerValueForKey:(id)key {
    return [self integerValueForKey:key fallback:0];
}
- (NSInteger)integerValueForKey:(id)key fallback:(NSInteger)fallback {
    XReturnValue(NSInteger, fallback, integerValue)
}
- (NSUInteger)unsignedIntegerForKey:(id)key {
    return [self unsignedIntegerForKey:key fallback:0];
}
- (NSUInteger)unsignedIntegerForKey:(id)key fallback:(NSUInteger)fallback {
    XReturnValue(NSUInteger, fallback, unsignedIntegerValue)
}

#define XReturnObjectClass(cls) \
id t = nil;\
if (key) { \
    t = self[key]; \
    if (![t isKindOfClass:cls]) { \
        t = nil;\
    }\
}\
return t;

#define XReturnObject(type) \
type *t = nil;\
if (key) { \
    t = self[key]; \
    if (![t isKindOfClass:[type class]]) { \
        t = nil;\
    }\
}\
return t;

- (nullable NSArray *)arrayValueForKey:(id)key {
    XReturnObject(NSArray)
}
- (nullable NSNumber *)numberValueForKey:(id)key {
    XReturnObject(NSNumber)
}
- (nullable NSString *)stringValueForKey:(id)key {
    XReturnObject(NSString)
}
- (nullable NSDictionary *)dictionaryValueForKey:(id)key {
    XReturnObject(NSDictionary)
}
- (nullable id)modelValueForKey:(id)key className:(NSString *)className {
    if (![className isKindOfClass:[NSString class]]) {
        return nil;
    }
    Class cls = NSClassFromString(className);
    if (cls == nil) {
        return nil;
    }
    XReturnObjectClass(cls)
}

- (nullable NSArray *)arrayForKeyPath:(NSString *)keyPath {
    return [self arrayForKeyPath:keyPath keyPathSeperator:@"."];
}

- (nullable NSArray *)arrayForKeyPath:(NSString *)keyPath keyPathSeperator:(nullable NSString *)keyPathSeperator {
    return [self objectForKeyPath:keyPath keyPathSeperator:keyPathSeperator expectedClass:[NSArray class]];
}

- (nullable NSString *)stringForKeyPath:(NSString *)keyPath {
    return [self stringForKeyPath:keyPath keyPathSeperator:@"."];
}

- (nullable NSString *)stringForKeyPath:(NSString *)keyPath keyPathSeperator:(nullable NSString *)keyPathSeperator {
    return [self objectForKeyPath:keyPath keyPathSeperator:keyPathSeperator expectedClass:[NSString class]];
}

- (nullable NSNumber *)numberForKeyPath:(NSString *)keyPath {
    return [self numberForKeyPath:keyPath keyPathSeperator:@"."];
}

- (nullable NSNumber *)numberForKeyPath:(NSString *)keyPath keyPathSeperator:(nullable NSString *)keyPathSeperator {
    return [self objectForKeyPath:keyPath keyPathSeperator:keyPathSeperator expectedClass:[NSNumber class]];
}

- (nullable NSDictionary *)dictionaryForKeyPath:(NSString *)keyPath {
    return [self dictionaryForKeyPath:keyPath keyPathSeperator:@"."];
}

- (nullable NSDictionary *)dictionaryForKeyPath:(NSString *)keyPath keyPathSeperator:(nullable NSString *)keyPathSeperator {
    return [self objectForKeyPath:keyPath keyPathSeperator:keyPathSeperator expectedClass:[NSDictionary class]];
}

- (nullable id)objectForKeyPath:(NSString *)keyPath {
    return [self objectForKeyPath:keyPath keyPathSeperator:@"."];
}

- (nullable id)objectForKeyPath:(NSString *)keyPath keyPathSeperator:(nullable NSString *)keyPathSeperator {
    return [self objectForKeyPath:keyPath keyPathSeperator:keyPathSeperator expectedClass:nil];
}

- (nullable id)objectForKeyPath:(NSString *)keyPath keyPathSeperator:(nullable NSString *)keyPathSeperator expectedClass:(nullable Class)expectedClass {
    if (![keyPath isKindOfClass:[NSString class]]) {
        return nil;
    }
    if (![keyPathSeperator isKindOfClass:[NSString class]] || keyPathSeperator.length == 0) {
        return self[keyPath];
    }
    NSArray<NSString *> *keys = [keyPath componentsSeparatedByString:keyPathSeperator];
    NSEnumerator<NSString *> *keysEnumerator = [keys objectEnumerator];
    id object = self;
    NSString *key = [keysEnumerator nextObject];
    while (key != nil) {
        object = object[key];
        if ([object isKindOfClass:[NSDictionary class]]) {
            key = [keysEnumerator nextObject];
        }else {
            break;
        }
    }
    if ([object isKindOfClass:[NSString class]] && [expectedClass isSubclassOfClass:[NSNumber class]]) {
        //获取到String，但是指定要Number
        return @([object integerValue]);
    }else if ([object isKindOfClass:[NSNumber class]] && [expectedClass isSubclassOfClass:[NSString class]]) {
        //获取到Number，但是指定要String
        return [object stringValue];
    }else if ([object isKindOfClass:expectedClass] || !expectedClass) {
        return object;
    }
    return nil;
}

@end

@implementation NSMutableDictionary (XHBExtension)

- (void)addObjectsAndKeysFromDictionary:(NSDictionary *)dictionary expectedKeys:(NSArray *)expectedKeys {
    NSDictionary *newDictionary = [dictionary fetchObjectsAndKeysWithExpectedKeys:expectedKeys];
    if ([newDictionary isKindOfClass:[NSDictionary class]]) {
        [self addEntriesFromDictionary:newDictionary];
    }
}

- (void)addObjectsAndKeysFromDictionary:(NSDictionary *)dictionary expectedKeysMapping:(NSDictionary *)expectedKeysMapping {
    NSDictionary *newDictionary = [dictionary fetchObjectsAndKeysWithExpectedKeysMapping:expectedKeysMapping];
    if ([newDictionary isKindOfClass:[NSDictionary class]]) {
        [self addEntriesFromDictionary:newDictionary];
    }
}

- (void)addObjectsAndKeysFromDictionary:(NSDictionary *)dictionary exceptedKeys:(NSArray *)exceptedKeys {
    NSDictionary *newDictionary = [dictionary fetchObjectsAndKeysWithExceptedKeys:exceptedKeys];
    if ([newDictionary isKindOfClass:[NSDictionary class]]) {
        [self addEntriesFromDictionary:newDictionary];
    }
}

@end

@implementation NSArray (XHBExtension)

- (id)safeObjectAtIndex:(NSUInteger)index {
    NSUInteger count = [self count];
    id object = nil;
    if (count > index) {
        object = self[index];
    }
    return object;
}

- (nullable id)safeObjectAtAnyIndex:(NSInteger)anyIndex {
    NSUInteger count = [self count];
    if (count > anyIndex && anyIndex > -1) {
        return self[anyIndex];
    }else {
        NSUInteger absIndex = 0;
        if (anyIndex < 0) {
            absIndex = anyIndex * -1;
            if (absIndex >= count) {
                absIndex = count - (absIndex % count);
            }else {
                absIndex = count - absIndex;
            }
        }else {
            absIndex = anyIndex % count;
        }
        return self[absIndex];
    }
}

- (nullable id)safeObjectAtRemindedIndex:(NSUInteger)remindedIndex {
    NSUInteger count = [self count];
    return self[remindedIndex % count];
}

@end

@implementation NSMutableArray (XHBExtension)

- (void)reverse {
    NSUInteger count = self.count;
    NSUInteger mid = floor(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
}

@end

@implementation NSTimer (XHBExtension)

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                        action:(void(^_Nullable)(NSTimeInterval))action
                                       repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:timeInterval
                                         action:action
                                        repeats:repeats
                                loopCommonModes:NO];
}

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                        action:(void(^_Nullable)(NSTimeInterval))action
                                       repeats:(BOOL)repeats
                               loopCommonModes:(BOOL)loopCommonModes {
    
    NSTimer *timer = [self scheduledTimerWithTimeInterval:timeInterval
                                                   target:self
                                                 selector:@selector(timerAction:)
                                                 userInfo:action
                                                  repeats:repeats];
    if (loopCommonModes) {
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    return timer;
}

+ (void)timerAction:(NSTimer *)sender {
    if ([sender isValid]) {
        void(^action)(NSTimeInterval time) = [sender userInfo];
        if (action) {
            action([sender timeInterval]);
        }
    }
}

@end

@interface CADisplayLink ()

@property (nonatomic, nullable, copy) XHBTimeUpdateAction action;

@end

@implementation CADisplayLink (XHBExtension)

+ (instancetype)displayLinkWithAction:(nullable XHBTimeUpdateAction)action
                      loopCommonModes:(BOOL)loopCommonModes {
    CADisplayLink *link = [self displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
    link.action = action;
    NSRunLoopMode runloopMode = loopCommonModes ? NSRunLoopCommonModes : NSDefaultRunLoopMode;
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:runloopMode];
    
    return link;
}

+ (instancetype)displayLinkWithFrameInternal:(NSTimeInterval)timeInterval
                                      action:(nullable XHBTimeUpdateAction)action
                             loopCommonModes:(BOOL)loopCommonModes {
    
    CADisplayLink *link = [self displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
    link.action = action;
    if (@available(iOS 10, *)) {
        link.preferredFramesPerSecond = timeInterval;
    }else {
        link.frameInterval = timeInterval;
    }
    NSRunLoopMode runloopMode = loopCommonModes ? NSRunLoopCommonModes : NSDefaultRunLoopMode;
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:runloopMode];
    
    return link;
}

+ (void)displayLinkAction:(CADisplayLink *)sender {
    XHBTimeUpdateAction action = sender.action;
    if (action) {
        if (@available(iOS 10, *)) {
            action([sender preferredFramesPerSecond]);
        }else {
            action([sender frameInterval]);
        }
    }
}

- (void)setAction:(XHBTimeUpdateAction)action {
    objc_setAssociatedObject(self, @selector(action), action, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (XHBTimeUpdateAction)action {
    return objc_getAssociatedObject(self, @selector(action));
}

@end

@implementation NSValue (XHBExtension)

/*
 
 const char *v0_objc_type = v0.objCType;
 const char *v1_objc_type = v1.objCType;
 
 const char *ch_rect = @encode(CGRect);
 const char *ch_size = @encode(CGSize);
 const char *ch_float = @encode(CGFloat);
 const char *ch_point = @encode(CGPoint);
 const char *ch_vector = @encode(CGVector);
 const char *ch_uioffset = @encode(UIOffset);
 const char *ch_edgeInset = @encode(UIEdgeInsets);
 const char *ch_transform = @encode(CGAffineTransform);
 
 */

#define XHBValueIsType(t) \
const char *ch_base = @encode(t);\
const char *ch_objc = self.objCType;\
return strcmp(ch_objc, ch_base) == 0;

- (BOOL)isCGRectValue {
    XHBValueIsType(CGRect)
}

- (BOOL)isCGSizeValue {
    XHBValueIsType(CGSize)
}

- (BOOL)isCGPointValue {
    XHBValueIsType(CGPoint)
}

- (BOOL)isCGFloatValue {
    XHBValueIsType(CGFloat)
}

- (BOOL)isUIOffsetValue {
    XHBValueIsType(UIOffset)
}

- (BOOL)isCGVectorValue {
    XHBValueIsType(CGVector)
}

- (BOOL)isUIEdgeInsetsValue {
    XHBValueIsType(UIEdgeInsets)
}

- (BOOL)isCATransform3DValue {
    XHBValueIsType(CATransform3D)
}

- (BOOL)isCGAffineTransformValue {
    XHBValueIsType(CGAffineTransform)
}

@end
