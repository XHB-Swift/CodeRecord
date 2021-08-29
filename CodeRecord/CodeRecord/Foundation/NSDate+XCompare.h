//
//  NSDate+XCompare.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2020/4/17.
//  Copyright © 2020 谢鸿标. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XDateUnit) {
    XDateUnitSecond = 1, //秒
    XDateUnitMinute = 60, //分
    XDateUnitHour   = 3600, //时
    XDateUnitDay    = 86400, //日
};

@interface NSDate (XCompare)

/// 判断是否为同一天
/// @param date 日期
- (BOOL)xcr_isSameDate:(NSDate *)date;

/// 计算与目标日期的时间间隔
/// @param date 目标日期
/// @param unit 计算单位
- (NSTimeInterval)xcr_durationSinceDate:(NSDate *)date unit:(XDateUnit)unit;

@end

NS_ASSUME_NONNULL_END
