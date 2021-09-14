//
//  XHBCustomTransitioning.m
//  CodeRecord
//
//  Created by xiehongbiao on 2021/9/13.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "XHBCustomTransitioning.h"
#import "XHBUIKitHeaders.h"

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
    UIViewController *srcController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *dstController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
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
- (void)animationWillBeginWithSrcView:(UIView *)srcView dstView:(UIView *)dstView {}
- (void)animationDidBeginWithSrcView:(UIView *)srcView dstView:(UIView *)dstView {}

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
    [self.presentedViewController dismissCustomModalAnimated:YES completion:nil];
}

- (CGRect)frameOfPresentedViewInContainerView {
    if ([self.customPresetationDelegate respondsToSelector:@selector(frameOfPresetedViewInContainerView:)]) {
        return [self.customPresetationDelegate frameOfPresetedViewInContainerView:self.containerView];
    }else {
        return [super frameOfPresentedViewInContainerView];
    }
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

@implementation XHBCustomModalTransitioningConfiguration

@synthesize presentAnimation = _presentAnimation,
            dismissAnimation = _dismissAnimation;

- (XHBCustomTransitioningAnimator *)presentAnimation {
    
    if (!_presentAnimation) {
        _presentAnimation = [[XHBCustomTransitioningAnimator alloc] init];
        _presentAnimation.forward = YES;
        _presentAnimation.duration = self.duration;
    }
    
    return _presentAnimation;
}

- (XHBCustomTransitioningAnimator *)dismissAnimation {
    
    if (!_dismissAnimation) {
        _dismissAnimation = [[XHBCustomTransitioningAnimator alloc] init];
        _dismissAnimation.forward = NO;
        _dismissAnimation.duration = self.duration;
    }
    
    return _dismissAnimation;
}

- (CGRect)frameOfPresetedViewInContainerView:(UIView *)containerView {
    if (self.displayedSize.width == 0 ||
        self.displayedSize.height == 0 ||
        self.displayedSize.height >= containerView.height) {
        return containerView.bounds;
    }else {
        return (CGRect){CGPointZero,self.displayedSize};
    }
}

@end

@implementation XHBCustomModalTransitioning

+ (instancetype)customModalTransitioningWithTransitioningConfiguration:(XHBCustomModalTransitioningConfiguration *)configuration
                                                presentationController:(UIPresentationController *)presentationController {
    XHBCustomModalTransitioning *customModalTransitioning = [[XHBCustomModalTransitioning alloc] init];
    customModalTransitioning.configuration = configuration;
    customModalTransitioning.presentationController = presentationController;
    return customModalTransitioning;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.configuration.presentAnimation.forward = YES;
    return self.configuration.presentAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if (self.configuration.dismissAnimation) {
        self.configuration.dismissAnimation.forward = NO;
        return self.configuration.dismissAnimation;
    }else {
        self.configuration.presentAnimation.forward = NO;
        return self.configuration.presentAnimation;
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

@interface XHBCustomTabTransitioning ()

@end

@implementation XHBCustomTabTransitioning

- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return self.tabTransitionAnimation;
}

- (id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
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

@implementation UIViewController (XHBCustomTransitioning)

- (void)customModalPresentViewController:(UIViewController *)vc
                           configuration:(XHBCustomModalTransitioningConfiguration *)configuration
                              completion:(void (^)(void))completion {
    
    if ([configuration isKindOfClass:[XHBCustomModalTransitioningConfiguration class]] &&
        configuration.effect) {
        XHBCustomModalTransitioning *customModalTransitioning = [[XHBCustomModalTransitioning alloc] init];
        customModalTransitioning.configuration = configuration;
        XHBCustomPresentationController *presentationController = [[XHBCustomPresentationController alloc] initWithPresentedViewController:vc presentingViewController:self];
        presentationController.customPresetationDelegate = configuration;
        customModalTransitioning.presentationController = presentationController;
        vc.transitioningDelegate = customModalTransitioning;
        [[XHBCustomTransitioningManager sharedManager] setTransitioning:customModalTransitioning
                                                                 forKey:[NSString stringWithFormat:@"%@",vc]];
    }
    
    [self presentViewController:vc animated:YES completion:completion];
    
}

- (void)dismissCustomModalAnimated:(BOOL)animated completion:(void(^_Nullable)(void))completion {
    UIViewController *dismissedVC = self.presentedViewController == nil ? self : self.presentedViewController;
    NSString *key = [NSString stringWithFormat:@"%@", dismissedVC];
    [self dismissViewControllerAnimated:animated completion:^{
        [[XHBCustomTransitioningManager sharedManager] removeTransitioningForKey:key];
        if (completion) {
            completion();
        }
    }];
}

@end
