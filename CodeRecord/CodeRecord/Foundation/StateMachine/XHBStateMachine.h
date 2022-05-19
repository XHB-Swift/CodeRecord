//
//  XHBStateMachine.h
//  CodeRecord
//
//  Created by xiehongbiao on 2022/5/18.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XHBTransition;

@interface XHBStateMachine : NSObject

@property (nonatomic, readonly, strong) id currentState;

+ (instancetype)stateMachineWithState:(id)state;
+ (instancetype)stateMachineWithState:(id)state executionQueue:(nullable dispatch_queue_t)executionQueue;

- (void)registerEvent:(NSString *)event
                 from:(id)from
                   to:(id)to
           completion:(void(^_Nullable)(id))completion;

- (void)registerTransition:(XHBTransition *)transition;

- (void)triggerByEvent:(NSString *)event;

- (void)triggerByEvent:(NSString *)event
             execution:(nullable dispatch_block_t)execution;

- (void)triggerByEvent:(NSString *)event
             execution:(nullable dispatch_block_t)execution
            completion:(void(^_Nullable)(BOOL result))completion;

@end

NS_ASSUME_NONNULL_END
