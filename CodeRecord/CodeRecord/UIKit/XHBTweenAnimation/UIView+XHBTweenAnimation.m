//
//  UIView+XHBTweenAnimation.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2022/5/14.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import "UIView+XHBTweenAnimation.h"
#import "XHBTweenEasing.h"
#import "XHBTweenInterpolator.h"
#import "XHBTweenInterpolatorQueue.h"
#import <objc/runtime.h>

@interface UIView ()

@property (nonatomic, strong) XHBTweenInterpolatorQueue *tweenEngine;

@end

@implementation UIView (XHBTweenAnimation)

- (void)xhb_tweenAnimationForKey:(NSString *)key
                        duration:(NSTimeInterval)duration
                          easing:(XHBTweenEasing *)easing
                              to:(id)to {
    [self xhb_tweenAnimationForKey:key
                          duration:duration
                            easing:easing
                          reversed:NO
                                to:to];
}

- (void)xhb_tweenAnimationForKey:(NSString *)key
                        duration:(NSTimeInterval)duration
                          easing:(XHBTweenEasing *)easing
                        reversed:(BOOL)reversed
                              to:(id)to {
    [self xhb_tweenAnimationForKey:key
                          duration:duration
                            easing:easing
                          reversed:reversed
                              from:nil
                                to:to];
}

- (void)xhb_tweenAnimationForKey:(NSString *)key
                        duration:(NSTimeInterval)duration
                          easing:(XHBTweenEasing *)easing
                            from:(nullable id)from
                              to:(id)to {
    [self xhb_tweenAnimationForKey:key
                          duration:duration
                            easing:easing
                          reversed:NO
                              from:from
                                to:to];
}

- (void)xhb_tweenAnimationForKey:(NSString *)key
                        duration:(NSTimeInterval)duration
                          easing:(XHBTweenEasing *)easing
                        reversed:(BOOL)reversed
                            from:(nullable id)from
                              to:(id)to {
    if (![self hasPropertyWithName:key]) {
        return;
    }
    id fromValue = from;
    if (!fromValue) {
        fromValue = [self valueForKey:key];
    }
    XHBTweenInterpolator *interpolator = [XHBTweenInterpolator interpolatornWithDuration:duration
                                                                                  easing:easing
                                                                                    from:fromValue
                                                                                      to:to];
    XHB_WEAK_SELF_DECLARED
    [self.tweenEngine addInterpolator:interpolator
                            animation:^(id  _Nonnull value) {
        NSLog(@"value = %@", value);
        [weakSelf setValue:value forKey:key];
    }
                           completion:^{
        if (!reversed) { return; }
        [weakSelf setValue:fromValue forKey:key];
    }];
    [self.tweenEngine playAnimation];
}

- (void)setTweenEngine:(XHBTweenInterpolatorQueue *)tweenEngine {
    objc_setAssociatedObject(self, @selector(tweenEngine), tweenEngine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XHBTweenInterpolatorQueue *)tweenEngine {
    XHBTweenInterpolatorQueue *engine = objc_getAssociatedObject(self, @selector(tweenEngine));
    if (!engine) {
        engine = [[XHBTweenInterpolatorQueue alloc] init];
        [self setTweenEngine:engine];
    }
    return engine;
}

@end
