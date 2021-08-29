//
//  NSArray+XItem.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2020/4/17.
//  Copyright © 2020 谢鸿标. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (XItem)

- (nullable id)xcr_objectAtIndex:(NSUInteger)index;

- (id)xcr_objectAtAnyIndex:(NSInteger)anyIndex;

- (id)xcr_objectAtRemainderIndex:(NSUInteger)remainderIndex;

@end

@interface NSMutableArray (XItem)

- (void)xcr_reverse;

@end

NS_ASSUME_NONNULL_END
