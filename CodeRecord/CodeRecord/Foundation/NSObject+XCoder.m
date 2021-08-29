//
//  NSObject+XCoder.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2020/4/16.
//  Copyright © 2020 谢鸿标. All rights reserved.
//

#import "NSObject+XCoder.h"

@implementation NSObject (XCoder)

+ (nullable NSData *)xcr_archivedObject:(id)object {
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

+ (nullable id)xcr_unarchivedData:(NSData *)data
               forExpectedClasses:(nullable NSArray<Class> *)expectedClasses {
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
                if ([defaultClasses isKindOfClass:[NSArray class]] &&
                    (defaultClasses.count > 0)) {
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

@end
