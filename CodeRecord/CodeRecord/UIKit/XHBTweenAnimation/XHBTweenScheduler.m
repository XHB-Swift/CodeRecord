//
//  XHBTweenScheduler.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2022/5/14.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import "XHBTweenScheduler.h"
#import "NSObject+XHBExtension.h"

@interface XHBTweenScheduler ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSTimeInterval lastTimestamp;

@end

@implementation XHBTweenScheduler

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appWillResignActiveNotif:) name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidBecomeActiveNotif:) name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    
    return self;
}

#pragma mark - Public

- (void)startScheduler {
    if (self.displayLink) {
        return;
    }
    XHB_WEAK_SELF_DECLARED
    self.displayLink = [CADisplayLink displayLinkWithAction:^(NSTimeInterval timeInterval){
        [weakSelf handleDisplayLinkAction];
    }
                                           loopCommonModes:YES];
    self.lastTimestamp = CFAbsoluteTimeGetCurrent();
}

- (void)stopScheduler {
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
        self.lastTimestamp = 0;
    }
}

#pragma mark - Private

- (void)handleDisplayLinkAction {
    if (![self.delegate respondsToSelector:@selector(scheduler:didUpdateForDuration:)]) {
        return;
    }
    CGFloat duration = (CFAbsoluteTimeGetCurrent() - self.lastTimestamp);
    duration = MAX(duration, 0);
    [self.delegate scheduler:self didUpdateForDuration:duration];
}

- (void)appWillResignActiveNotif:(NSNotification *)sender {
    self.displayLink.paused = YES;
    self.lastTimestamp = 0;
}

- (void)appDidBecomeActiveNotif:(NSNotification *)sender {
    self.lastTimestamp = 0;
    self.displayLink.paused = NO;
}

@end
