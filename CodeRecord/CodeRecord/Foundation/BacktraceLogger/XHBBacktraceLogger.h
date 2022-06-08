//
//  XHBBacktraceLogger.h
//  CodeRecord
//
//  Created by xiehongbiao on 2022/6/7.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHBBacktraceLogger : NSObject

+ (NSString *)backtraceForMainThread;
+ (NSString *)backtraceForCurrentThread;

@end

NS_ASSUME_NONNULL_END
