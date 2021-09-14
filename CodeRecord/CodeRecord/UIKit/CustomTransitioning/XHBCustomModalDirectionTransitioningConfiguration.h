//
//  XHBDirectionPresentationController.h
//  CodeRecord
//
//  Created by xiehongbiao on 2021/9/14.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "XHBCustomTransitioning.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XHBTransitionDirection) {
    XHBTransitionDirectionLeft,
    XHBTransitionDirectionRight,
    XHBTransitionDirectionTop,
    XHBTransitionDirectionBottom,
    XHBTransitionDirectionCenter
};

@interface XHBDirectionTransitionAnimator : XHBCustomTransitioningAnimator

@property (nonatomic, assign) XHBTransitionDirection direction;

@end

@interface XHBCustomModalDirectionTransitioningConfiguration : XHBCustomModalTransitioningConfiguration

@property (nonatomic, assign) XHBTransitionDirection direction;

@end


NS_ASSUME_NONNULL_END
