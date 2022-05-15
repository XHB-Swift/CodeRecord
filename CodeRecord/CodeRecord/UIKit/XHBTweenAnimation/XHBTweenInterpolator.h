//
//  XHBTweenInterpolator.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2022/5/14.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class
XHBTweenEasing,
XHBTweenInterpolator;

@protocol XHBTweenInterpolatorDelegate <NSObject>

- (void)interpolatorDidFinish:(XHBTweenInterpolator *)interpolator;
- (void)interpolator:(XHBTweenInterpolator *)interpolator didUpdateToValue:(id)value;

@end

@interface XHBTweenInterpolator : NSObject

@property (nonatomic, weak) id<XHBTweenInterpolatorDelegate> delegate;

+ (instancetype)interpolatornWithDuration:(NSTimeInterval)duration
                                   easing:(XHBTweenEasing *)easing
                                     from:(id)from
                                       to:(id)to;

- (void)moveToTime:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
