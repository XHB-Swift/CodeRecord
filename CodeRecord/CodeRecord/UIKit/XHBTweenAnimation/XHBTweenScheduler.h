//
//  XHBTweenScheduler.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2022/5/14.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class
XHBTweenScheduler;

@protocol XHBTweenSchedulerDelegate <NSObject>

- (void)scheduler:(XHBTweenScheduler *)scheduler didUpdateForDuration:(NSTimeInterval)duration;

@end

@interface XHBTweenScheduler : NSObject

@property (nonatomic, weak) id<XHBTweenSchedulerDelegate> delegate;

- (void)startScheduler;

- (void)stopScheduler;

@end

NS_ASSUME_NONNULL_END
