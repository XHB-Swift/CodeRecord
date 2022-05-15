//
//  UIView+XHBTweenAnimation.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2022/5/14.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XHBTweenEasing;

@interface UIView (XHBTweenAnimation)

- (void)xhb_tweenAnimationForKey:(NSString *)key
                        duration:(NSTimeInterval)duration
                          easing:(XHBTweenEasing *)easing
                              to:(id)to;

- (void)xhb_tweenAnimationForKey:(NSString *)key
                        duration:(NSTimeInterval)duration
                          easing:(XHBTweenEasing *)easing
                        reversed:(BOOL)reversed
                              to:(id)to;

- (void)xhb_tweenAnimationForKey:(NSString *)key
                        duration:(NSTimeInterval)duration
                          easing:(XHBTweenEasing *)easing
                            from:(nullable id)from
                              to:(id)to;

- (void)xhb_tweenAnimationForKey:(NSString *)key
                        duration:(NSTimeInterval)duration
                          easing:(XHBTweenEasing *)easing
                        reversed:(BOOL)reversed
                            from:(nullable id)from
                              to:(id)to;

@end

NS_ASSUME_NONNULL_END
