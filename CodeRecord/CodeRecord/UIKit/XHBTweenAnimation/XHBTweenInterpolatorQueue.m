//
//  XHBTweenInterpolatorQueue.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2022/5/14.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import "XHBTweenInterpolatorQueue.h"
#import "XHBTweenInterpolator.h"
#import "XHBTweenScheduler.h"

@class
XHBTweenAction;

typedef void(^XHBTweenActionCompletion)(XHBTweenAction *action);

@interface XHBTweenAction : NSObject
<
XHBTweenInterpolatorDelegate
>

@property (nonatomic, strong) XHBTweenInterpolator *interpolator;
@property (nonatomic, nullable, copy) XHBTweenAnimationBlock animationBlock;
@property (nonatomic, nullable, copy) XHBTweenActionCompletion completionBlock;

@end

@implementation XHBTweenAction

+ (instancetype)actionWithInterpolator:(XHBTweenInterpolator *)interpolator
                             animation:(nullable XHBTweenAnimationBlock)animtion
                            completion:(nullable XHBTweenActionCompletion)completion {
    return [[self alloc] initWithInterpolator:interpolator animation:animtion completion:completion];
}

- (instancetype)initWithInterpolator:(XHBTweenInterpolator *)interpolator
                           animation:(nullable XHBTweenAnimationBlock)animtion
                          completion:(nullable XHBTweenActionCompletion)completion {
    
    if (self = [super init]) {
        self.interpolator = interpolator;
        self.animationBlock = animtion;
        self.completionBlock = completion;
    }
    
    return self;
}

- (void)setInterpolator:(XHBTweenInterpolator *)interpolator {
    _interpolator = interpolator;
    _interpolator.delegate = self;
}

#pragma mark - XHBTweenInterpolatorDelegate

- (void)interpolatorDidFinish:(XHBTweenInterpolator *)interpolator {
    if (self.completionBlock) {
        self.completionBlock(self);
    }
}

- (void)interpolator:(XHBTweenInterpolator *)interpolator didUpdateToValue:(id)value {
    if (self.animationBlock) {
        self.animationBlock(value);
    }
}

@end

@interface XHBTweenInterpolatorQueue ()
<
XHBTweenSchedulerDelegate
>

@property (nonatomic, strong) XHBTweenScheduler *scheduler;
@property (nonatomic, strong) NSMutableOrderedSet<XHBTweenAction *> *tweenActions;

@end

@implementation XHBTweenInterpolatorQueue

- (void)addInterpolator:(XHBTweenInterpolator *)interpolator
              animation:(XHBTweenAnimationBlock )animation
             completion:(nullable XHBTweenCompletionBlock)completion {
    if (![interpolator isKindOfClass:[XHBTweenInterpolator class]]) {
        return;
    }
    XHB_WEAK_SELF_DECLARED
    XHBTweenAction *newAction = [XHBTweenAction actionWithInterpolator:interpolator
                                                             animation:^(id value) {
        [weakSelf handleActionUpdatedValue:value animation:animation];
    }
                                                            completion:^(XHBTweenAction *action) {
        [weakSelf handleActionFinished:action completion:completion];
    }];
    if ([self.tweenActions containsObject:newAction]) {
        return;
    }
    [self.tweenActions addObject:newAction];
}

- (void)playAnimation {
    [self.scheduler startScheduler];
}

- (void)stopAnimation {
    [self.scheduler stopScheduler];
}

#pragma mark - XHBTweenSchedulerDelegate

- (void)scheduler:(XHBTweenScheduler *)scheduler didUpdateForDuration:(NSTimeInterval)duration {
    if (self.tweenActions.count == 0) {
        [self stopAnimation];
        return;
    }
    [self.tweenActions.firstObject.interpolator moveToTime:duration];
}

#pragma mark - Private

- (void)handleActionUpdatedValue:(id)value animation:(XHBTweenAnimationBlock)animation {
    if (animation) {
        animation(value);
    }
    if ([self.delegate respondsToSelector:@selector(interpolatorQueue:didUpdateToValue:)]) {
        [self.delegate interpolatorQueue:self didUpdateToValue:value];
    }
}

- (void)handleActionFinished:(XHBTweenAction *)action completion:(XHBTweenCompletionBlock)completion {
    if (completion) {
        completion();
    }
    [self.tweenActions removeObject:action];
    if ([self.delegate respondsToSelector:@selector(interpolatorQueueDidFinish:)]) {
        [self.delegate interpolatorQueueDidFinish:self];
    }
}

#pragma mark - Getter

- (XHBTweenScheduler *)scheduler {
    
    if (!_scheduler) {
        _scheduler = [[XHBTweenScheduler alloc] init];
        _scheduler.delegate = self;
    }
    
    return _scheduler;
}

- (NSMutableOrderedSet<XHBTweenAction *> *)tweenActions {
    
    if (!_tweenActions) {
        _tweenActions = [NSMutableOrderedSet orderedSet];
    }
    
    return _tweenActions;
}

@end
