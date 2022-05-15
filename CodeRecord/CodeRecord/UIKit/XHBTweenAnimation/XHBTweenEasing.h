//
//  XHBTweenEasing.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2022/5/14.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef CGFloat(^XHBTweenEasingFunction)(CGFloat t, CGFloat b, CGFloat c, CGFloat d);

@interface XHBTweenEasing : NSObject

@property (nonatomic, nullable, copy) XHBTweenEasingFunction function;

+ (instancetype)easingWithFunction:(XHBTweenEasingFunction)function;

@end

@interface XHBTweenEasing (XHBTweenConcreteEffect)

#pragma mark - Linear

+ (instancetype)linear;

#pragma mark - t^2

+ (instancetype)quadraticIn;
+ (instancetype)quadraticOut;
+ (instancetype)quadraticInOut;
+ (instancetype)quadraticOutIn;

#pragma mark - t^3

+ (instancetype)cubicIn;
+ (instancetype)cubicOut;
+ (instancetype)cubicInOut;
+ (instancetype)cubicOutIn;

#pragma mark - t^4

+ (instancetype)quarticIn;
+ (instancetype)quarticOut;
+ (instancetype)quarticInOut;
+ (instancetype)quarticOutIn;

#pragma mark - t^5

+ (instancetype)quinticIn;
+ (instancetype)quinticOut;
+ (instancetype)quinticInOut;
+ (instancetype)quinticOutIn;

#pragma mark - sin(t) 正弦渐变

+ (instancetype)sinusodialIn;
+ (instancetype)sinusodialOut;
+ (instancetype)sinusodialInOut;
+ (instancetype)sinusodialOutIn;

#pragma mark - 2^t 指数渐变

+ (instancetype)exponentialIn;
+ (instancetype)exponentialOut;
+ (instancetype)exponentialInOut;
+ (instancetype)exponentialOutIn;

#pragma mark - sqrt(1-t^2) 圆形曲线

+ (instancetype)circularIn;
+ (instancetype)circularOut;
+ (instancetype)circularInOut;
+ (instancetype)circularOutIn;

#pragma mark - 指数衰减正弦曲线

+ (instancetype)elasticIn;
+ (instancetype)elasticOut;
+ (instancetype)elasticInOut;
+ (instancetype)elasticOutIn;

#pragma mark - back

+ (instancetype)backIn;
+ (instancetype)backOut;
+ (instancetype)backInOut;
+ (instancetype)backOutIn;

#pragma mark - bounce

+ (instancetype)bounceIn;
+ (instancetype)bounceOut;
+ (instancetype)bounceInOut;
+ (instancetype)bounceOutIn;

@end

NS_ASSUME_NONNULL_END
