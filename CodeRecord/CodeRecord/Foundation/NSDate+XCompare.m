//
//  NSDate+XCompare.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2020/4/17.
//  Copyright © 2020 谢鸿标. All rights reserved.
//

#import "NSDate+XCompare.h"

@implementation NSDate (XCompare)

- (BOOL)xcr_isSameDate:(NSDate *)date {
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

- (NSTimeInterval)xcr_durationSinceDate:(NSDate *)date unit:(XDateUnit)unit {
    NSTimeInterval duration = 0;
    if ([date isKindOfClass:[NSDate class]]) {
        duration = [self timeIntervalSinceDate:date];
        if (unit > 0) {
            duration /= unit;
        }
    }
    return duration;
}

@end
