//
//  NSArray+XItem.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2020/4/17.
//  Copyright © 2020 谢鸿标. All rights reserved.
//

#import "NSArray+XItem.h"

@implementation NSArray (XItem)

- (nullable id)xcr_objectAtIndex:(NSUInteger)index {
    NSUInteger count = [self count];
    id object = nil;
    if (count > index) {
        object = self[index];
    }
    return object;
}

- (id)xcr_objectAtAnyIndex:(NSInteger)anyIndex {
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

- (id)xcr_objectAtRemainderIndex:(NSUInteger)remainderIndex {
    NSUInteger count = [self count];
    return self[remainderIndex % count];
}

@end

@implementation NSMutableArray (XItem) 

- (void)xcr_reverse {
    //参考YYKit的NSArray+YYAdd.m
    NSUInteger count = self.count;
    int mid = floor(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
}

@end
