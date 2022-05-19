//
//  XHBStateMachine.m
//  CodeRecord
//
//  Created by xiehongbiao on 2022/5/18.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import "XHBStateMachine.h"
#import "XHBTransition.h"
#import "NSObject+XHBExtension.h"

@interface XHBStateMachine ()

@property (nonatomic, strong) dispatch_queue_t lockQueue;
@property (nonatomic, strong) dispatch_queue_t machineQueue;
@property (nonatomic, strong) dispatch_queue_t executionQueue;

@property (nonatomic, readwrite, strong) id currentState;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<XHBTransition *> *> *eventTransitionInfo;

@end

@implementation XHBStateMachine

+ (instancetype)stateMachineWithState:(id)state {
    return [self stateMachineWithState:state executionQueue:nil];
}

+ (instancetype)stateMachineWithState:(id)state executionQueue:(dispatch_queue_t)executionQueue {
    return [[self alloc] initWithState:state executionQueue:executionQueue];
}

- (instancetype)initWithState:(id)state executionQueue:(dispatch_queue_t)executionQueue {
    
    if (self = [self init]) {
        self.currentState = state;
        self.executionQueue = executionQueue ?: dispatch_get_main_queue();
    }
    return self;
}

- (instancetype)init {
    
    if (self = [super init]) {
        self.lockQueue = dispatch_queue_create("com.xhb.state.machine.lock.queue", DISPATCH_QUEUE_SERIAL);
        self.machineQueue = dispatch_queue_create("com.xhb.state.machine.work.queue", DISPATCH_QUEUE_SERIAL);
        self.eventTransitionInfo = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)registerEvent:(NSString *)event
                 from:(id)from
                   to:(id)to
           completion:(nullable XHBTransitionChangeBlock)completion {
    if (![event isKindOfClass:[NSString class]]) {
        return;
    }
    XHBTransition *transition = [XHBTransition transitionWithEvent:event
                                                              from:from
                                                                to:to
                                              willChangeStateBlock:nil
                                                    didChangeBlock:completion];
    [self registerTransition:transition];
}

- (void)registerTransition:(XHBTransition *)transition {
    XHB_WEAK_SELF_DECLARED
    dispatch_sync(self.lockQueue, ^{
        
        NSString *event = transition.event;
        if (![event isKindOfClass:[NSString class]]) {
            return;
        }
        NSMutableArray<XHBTransition *> *transitions = weakSelf.eventTransitionInfo[event];
        if ([transitions isKindOfClass:[NSMutableArray class]]) {
            NSArray<XHBTransition *> *sameTransitions = [transitions filterUsingBlock:^BOOL(XHBTransition * _Nonnull element) {
                return [element.from isEqual:transition.from];
            }];
            if (sameTransitions.count > 0) {
                NSAssert(NO, @"Same Transition has been added more than once.");
            } else {
                [transitions addObject:transition];
                weakSelf.eventTransitionInfo[event] = transitions;
            }
        } else {
            weakSelf.eventTransitionInfo[event] = [NSMutableArray arrayWithObjects:transition, nil];
        }
    });
}

- (void)triggerByEvent:(NSString *)event {
    [self triggerByEvent:event execution:nil];
}

- (void)triggerByEvent:(NSString *)event
             execution:(nullable dispatch_block_t)execution {
    [self triggerByEvent:event execution:execution completion:nil];
}

- (void)triggerByEvent:(NSString *)event
             execution:(nullable dispatch_block_t)execution
            completion:(void(^_Nullable)(BOOL result))completion {
    if (![event isKindOfClass:[NSString class]]) {
        return;
    }
    __block NSMutableArray<XHBTransition *> *transitions = nil;
    XHB_WEAK_SELF_DECLARED
    dispatch_sync(self.lockQueue, ^{
        transitions = weakSelf.eventTransitionInfo[event];
    });
    
    dispatch_async(self.machineQueue, ^{
        
        NSArray<XHBTransition *> *performTransitions = [transitions filterUsingBlock:^BOOL(XHBTransition * _Nonnull element) {
            return [element.from isEqual:self.currentState];
        }] ?: @[];
        
        if (performTransitions.count != 1) {
            dispatch_async(weakSelf.executionQueue, ^{
                if (completion) {
                    completion(NO);
                }
            });
            return;
        }
        
        XHBTransition *performTransition = performTransitions.firstObject;
        
        dispatch_async(weakSelf.executionQueue, ^{
            [performTransition willChangeState];
            if (execution) {
                execution();
            }
        });
        
        weakSelf.currentState = performTransition.to;
        
        dispatch_async(weakSelf.executionQueue, ^{
            [performTransition didChangeState];
            if (completion) {
                completion(YES);
            }
        });
    });
}

@end
