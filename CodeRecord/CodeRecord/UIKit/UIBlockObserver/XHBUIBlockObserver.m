//
//  XHBUIBlockObserver.m
//  CodeRecord
//
//  Created by xiehongbiao on 2022/6/6.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import "XHBUIBlockObserver.h"
#import "XHBBacktraceLogger.h"

@interface XHBUIBlockObserver ()

@property (nonatomic, assign) BOOL monitoring;
@property (nonatomic, strong) dispatch_queue_t monitorQueue;
@property (nonatomic, strong) dispatch_semaphore_t monitorSemaphore;

@end

@implementation XHBUIBlockObserver

- (instancetype)init {
    
    if (self = [super init]) {
        _monitoring = NO;
        _monitorQueue = dispatch_queue_create("com.xhb.monitor.queue", NULL);
        _monitorSemaphore = dispatch_semaphore_create(0);
    }
    
    return self;
}

- (void)startMonitoring {
    if (self.monitoring) { return; }
    self.monitoring = YES;
    dispatch_async(self.monitorQueue, ^{
        while (self.monitoring) {
            __block BOOL timeout = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                timeout = NO;
                dispatch_semaphore_signal(self.monitorSemaphore);
            });
            [NSThread sleepForTimeInterval:0.05];
            if (timeout) {
                NSString *backtrace = [XHBBacktraceLogger backtraceForMainThread];
                NSLog(@"%@",backtrace);
            }
            dispatch_semaphore_wait(self.monitorSemaphore, DISPATCH_TIME_FOREVER);
        }
    });
}

- (void)stopMonitoring {
    if (!self.monitoring) { return; }
    self.monitoring = NO;
}

@end
