//
//  XHBDirectionPresentationController.m
//  CodeRecord
//
//  Created by xiehongbiao on 2021/9/14.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "XHBCustomModalDirectionTransitioningConfiguration.h"
#import "XHBUIKitHeaders.h"

@implementation XHBDirectionTransitionAnimator

- (instancetype)init {
    
    if (self = [super init]) {
        _direction = XHBTransitionDirectionLeft;
        _options = UIViewAnimationOptionCurveEaseInOut;
    }
    return self;
}

- (void)doAnimationFrom:(UIView *)from
                     to:(UIView *)to
      transitionContext:(id<UIViewControllerContextTransitioning>)context
             completion:(void (^ _Nullable)(void))completion {
    
    [self animationWillBeginWithSrcView:from dstView:to];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:[self transitionDuration:context]
                          delay:self.delay
                        options:self.options
                     animations:^{
        [weakSelf animationDidBeginWithSrcView:from dstView:to];
    }
                     completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
        [context completeTransition:!context.transitionWasCancelled];
    }];
    
}

- (void)animationWillBeginWithSrcView:(UIView *)srcView dstView:(UIView *)dstView {
    UIView *superView = dstView.superview;
    switch (self.direction) {
        case XHBTransitionDirectionLeft: {
            if (self.forward) {
                dstView.x = -superView.width;
            }else {
                srcView.x = 0;
            }
            break;
        }
        case XHBTransitionDirectionRight: {
            if (self.forward) {
                dstView.x = superView.width;
            }else {
                srcView.x = 0;
            }
            break;
        }
        case XHBTransitionDirectionTop: {
            if (self.forward) {
                dstView.y = -superView.height;
            }else {
                srcView.y = 0;
            }
            break;
        }
        case XHBTransitionDirectionBottom: {
            if (self.forward) {
                dstView.y = superView.height;
            }else {
                srcView.bottom = superView.height;
            }
            break;
        }
        case XHBTransitionDirectionCenter: {
            if (self.forward) {
                dstView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
                dstView.alpha = 0;
            }else {
                srcView.transform = CGAffineTransformIdentity;
                srcView.alpha = 1;
            }
            break;
        }
        default:
            break;
    }
}

- (void)animationDidBeginWithSrcView:(UIView *)srcView dstView:(UIView *)dstView {
    UIView *superView = srcView.superview;
    switch (self.direction) {
        case XHBTransitionDirectionLeft: {
            if (self.forward) {
                dstView.x = 0;
            }else {
                srcView.x = -superView.width;
            }
            break;
        }
        case XHBTransitionDirectionRight: {
            if (self.forward) {
                dstView.x = 0;
            }else {
                srcView.x = superView.width;
            }
            break;
        }
        case XHBTransitionDirectionTop: {
            if (self.forward) {
                dstView.y = 0;
            }else {
                srcView.y = -superView.height;
            }
            break;
        }
        case XHBTransitionDirectionBottom: {
            if (self.forward) {
                dstView.bottom = superView.height;
            }else {
                srcView.y = superView.height;
            }
            break;
        }
        case XHBTransitionDirectionCenter: {
            if (self.forward) {
                dstView.transform = CGAffineTransformIdentity;
                dstView.alpha = 1;
            }else {
                srcView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
                srcView.alpha = 0;
            }
            break;
        }
        default:
            break;
    }
}

@end

@implementation XHBCustomModalDirectionTransitioningConfiguration

@synthesize presentAnimation = _presentAnimation, dismissAnimation = _dismissAnimation;

- (instancetype)init {
    
    if (self = [super init]) {
        _direction = XHBTransitionDirectionLeft;
    }
    
    return self;
}

- (XHBCustomTransitioningAnimator *)presentAnimation {
    if (!_presentAnimation) {
        XHBDirectionTransitionAnimator *directionAnimation = [[XHBDirectionTransitionAnimator alloc] init];
        directionAnimation.duration = self.duration;
        directionAnimation.direction = self.direction;
        directionAnimation.transitioning = self.isTransitioning;
        _presentAnimation = directionAnimation;
    }
    return _presentAnimation;
}

- (XHBCustomTransitioningAnimator *)dismissAnimation {
    return nil;
}

- (CGRect)frameOfPresetedViewInContainerView:(UIView *)containerView {
    CGRect frame = [super frameOfPresetedViewInContainerView:containerView];
    switch (self.direction) {
        case XHBTransitionDirectionLeft: {
            frame.origin.x = 0;
            break;
        }
        case XHBTransitionDirectionRight: {
            frame.origin.x = containerView.right - self.displayedSize.width;
            break;
        }
        case XHBTransitionDirectionTop: {
            frame.origin.y = 0;
            break;
        }
        case XHBTransitionDirectionBottom: {
            frame.origin.y = containerView.height - self.displayedSize.height;
            break;
        }
        case XHBTransitionDirectionCenter: {
            CGFloat x = (containerView.width - self.displayedSize.width) / 2,
                    y = (containerView.height - self.displayedSize.height) / 2;
            frame.origin = (CGPoint){x,y};
            break;
        }
        default:
            break;
    }
    return frame;
}

@end

