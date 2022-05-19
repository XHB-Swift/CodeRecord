//
//  XHBTransition.h
//  CodeRecord
//
//  Created by xiehongbiao on 2022/5/18.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^XHBTransitionChangeBlock)(id state);

@interface XHBTransition : NSObject

@property (nonatomic, readonly, strong) NSString *event;
@property (nonatomic, readonly, strong) id from;
@property (nonatomic, readonly, strong) id to;

+ (instancetype)transitionWithEvent:(NSString *)event
                               from:(id)from
                                 to:(id)to
               willChangeStateBlock:(nullable XHBTransitionChangeBlock)willChangeStateBlock
                     didChangeBlock:(nullable XHBTransitionChangeBlock)didChangeBlock;

- (void)willChangeState;
- (void)didChangeState;

@end

NS_ASSUME_NONNULL_END
