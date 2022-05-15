//
//  XHBTweenInterpolatorQueue.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2022/5/14.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class
XHBTweenInterpolator,
XHBTweenInterpolatorQueue;

typedef void(^XHBTweenAnimationBlock)(id value);
typedef void(^XHBTweenCompletionBlock)(void);

@protocol XHBTweenInterpolatorQueueDelegate <NSObject>

- (void)interpolatorQueueDidFinish:(XHBTweenInterpolatorQueue *)interpolatorQueue;
- (void)interpolatorQueue:(XHBTweenInterpolatorQueue *)interpolatorQueue didUpdateToValue:(id)value;

@end

@interface XHBTweenInterpolatorQueue : NSObject

@property (nonatomic, weak) id<XHBTweenInterpolatorQueueDelegate> delegate;

- (void)addInterpolator:(XHBTweenInterpolator *)interpolator
              animation:(XHBTweenAnimationBlock )animation
             completion:(nullable XHBTweenCompletionBlock)completion;

- (void)playAnimation;
- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
