//
//  XHBTransition.m
//  CodeRecord
//
//  Created by xiehongbiao on 2022/5/18.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import "XHBTransition.h"

@interface XHBTransition ()

@property (nonatomic, readwrite, strong) NSString *event;
@property (nonatomic, readwrite, strong) id from;
@property (nonatomic, readwrite, strong) id to;

@property (nonatomic, copy) XHBTransitionChangeBlock willChangeBlock;
@property (nonatomic, copy) XHBTransitionChangeBlock didChangeBlock;

@end

@implementation XHBTransition

+ (instancetype)transitionWithEvent:(NSString *)event
                               from:(id)from
                                 to:(id)to
               willChangeStateBlock:(XHBTransitionChangeBlock)willChangeStateBlock
                     didChangeBlock:(XHBTransitionChangeBlock)didChangeBlock {
    return [[self alloc] initWithEvent:event
                                  from:from
                                    to:to
                  willChangeStateBlock:willChangeStateBlock
                        didChangeBlock:didChangeBlock];
}

- (instancetype)initWithEvent:(NSString *)event
                         from:(id)from
                           to:(id)to
         willChangeStateBlock:(XHBTransitionChangeBlock)willChangeStateBlock
               didChangeBlock:(XHBTransitionChangeBlock)didChangeBlock {
    
    if (self = [super init]) {
        self.event = event;
        self.from = from;
        self.to = to;
        self.willChangeBlock = willChangeStateBlock;
        self.didChangeBlock = didChangeBlock;
    }
    
    return self;
}

- (void)willChangeState {
    if (self.willChangeBlock) {
        self.willChangeBlock(self.from);
    }
}

- (void)didChangeState {
    if (self.didChangeBlock) {
        self.didChangeBlock(self.to);
    }
}

@end
