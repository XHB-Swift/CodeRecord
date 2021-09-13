//
//  XHBCustomTransitioning.m
//  CodeRecord
//
//  Created by xiehongbiao on 2021/9/13.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "XHBCustomTransitioning.h"

@implementation XHBCustomTransitioningAnimator

- (instancetype)init {
    
    if (self = [super init]) {
        _forward = YES;
    }
    
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return transitionContext.animated ? self.duration : 0;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    UIViewController *dstController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *srcController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *dstView = dstController.view;
    UIView *srcView = srcController.view;
    if (!dstView || !srcView) {
        return;
    }
    if (self.forward) {
        [containerView insertSubview:dstView aboveSubview:srcView];
    }else {
        if (dstView.superview == nil) {
            [containerView insertSubview:dstView belowSubview:srcView];
        }
    }
    [self doAnimationFrom:srcView to:dstView transitionContext:transitionContext];
}

- (void)doAnimationFrom:(UIView *)from to:(UIView *)to transitionContext:(id<UIViewControllerContextTransitioning>)context {}

@end

@interface XHBCustomPresentationController ()

@property (nonatomic, strong) UIView *dimmingView;

@end

@implementation XHBCustomPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController {
    if (self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController]) {
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)presentationTransitionWillBegin {
    self.dimmingView.frame = self.containerView.bounds;
    self.presentedView.frame = [self frameOfPresentedViewInContainerView];
    [self.containerView addSubview:self.dimmingView];
    CGFloat alpha = self.dimmingView.alpha;
    self.dimmingView.alpha = 0;
    __weak typeof(self) weakSelf = self;
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        weakSelf.dimmingView.alpha = alpha;
        } completion:nil];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    if (!completed) {
        [self.dimmingView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin {
    __weak typeof(self) weakSelf = self;
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        weakSelf.dimmingView.alpha = 0;
    } completion:nil];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [self.dimmingView removeFromSuperview];
    }
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    if ([container isEqual:self.presentedViewController]) {
        [self.containerView setNeedsLayout];
    }
}

- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    if ([container isEqual:self.presentedViewController]) {
        return [self frameOfPresentedViewInContainerView].size;
    }else {
        return [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
    }
}

- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
    self.dimmingView.frame = self.containerView.bounds;
    self.presentedView.frame = [self frameOfPresentedViewInContainerView];
}

- (void)tapDimmingAction:(UITapGestureRecognizer *)sender {
    
}

#pragma mark - Getter

- (UIView *)dimmingView {
    
    if (!_dimmingView) {
        _dimmingView = [[UIView alloc] init];
        _dimmingView.alpha = 0.5;
        _dimmingView.backgroundColor = [UIColor blackColor];
        [_dimmingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDimmingAction:)]];
    }
    
    return _dimmingView;
}

@end

@implementation XHBCustomTransitioning

@end

@implementation XHBCustomModalTransitioning

+ (instancetype)customModalTransitioningWithPresentAnimation:(XHBCustomTransitioningAnimator *)presentAnimation
                                            dismissAnimation:(XHBCustomTransitioningAnimator *)dismissAnimation
                                      presentationController:(UIPresentationController *)presentationController {
    
    XHBCustomModalTransitioning *customModalTransitioning = [[XHBCustomModalTransitioning alloc] init];
    
    customModalTransitioning.presentAnimation = presentAnimation;
    customModalTransitioning.dismissAnimation = dismissAnimation;
    customModalTransitioning.presentationController = presentationController;
    
    return customModalTransitioning;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.presentAnimation.forward = YES;
    return self.presentAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if (self.dismissAnimation) {
        self.dismissAnimation.forward = NO;
        return self.dismissAnimation;
    }else {
        self.presentAnimation.forward = NO;
        return self.presentAnimation;
    }
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return self.presentationController;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.interactiveTransitioning;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.interactiveTransitioning;
}

@end

@implementation XHBCustomNavigationTransitioning

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        return self.pushAnimation;
    }else if (operation == UINavigationControllerOperationPop) {
        return self.popAnimation;
    }else {
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return self.interactiveTransitioning;
}

@end

@interface XHBCustomTransitioningManager ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, XHBCustomTransitioning *> *transitionings;

@end

@implementation XHBCustomTransitioningManager

+ (instancetype)sharedManager {
    static XHBCustomTransitioningManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XHBCustomTransitioningManager alloc] init];
    });
    return manager;
}

- (void)setTransitioning:(XHBCustomTransitioning *)transitioning forKey:(NSString *)key {
    if (![transitioning isKindOfClass:[XHBCustomTransitioning class]] || ![key isKindOfClass:[NSString class]]) {
        return;
    }
    self.transitionings[key] = transitioning;
}

- (void)removeTransitioningForKey:(NSString *)key {
    if (![key isKindOfClass:[NSString class]]) {
        return;
    }
    [self.transitionings removeObjectForKey:key];
}

- (NSMutableDictionary<NSString *,XHBCustomTransitioning *> *)transitionings {
    
    if (!_transitionings) {
        _transitionings = [NSMutableDictionary dictionary];
    }
    
    return _transitionings;
}

@end
