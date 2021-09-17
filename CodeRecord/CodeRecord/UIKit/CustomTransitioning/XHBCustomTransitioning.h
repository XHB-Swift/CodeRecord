//
//  XHBCustomTransitioning.h
//  CodeRecord
//
//  Created by xiehongbiao on 2021/9/13.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHBCustomTransitioningAnimator: NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL forward;
@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign, getter=isTransitioning) BOOL transitioning;

- (void)doAnimationFrom:(UIView *)from to:(UIView *)to
      transitionContext:(nullable id<UIViewControllerContextTransitioning>)context
             completion:(void(^_Nullable)(void))completion;
- (void)animationWillBeginWithSrcView:(UIView *)srcView dstView:(UIView *)dstView;
- (void)animationDidBeginWithSrcView:(UIView *)srcView dstView:(UIView *)dstView;

@end

@protocol XHBCustomPresentationControllerDelegate <NSObject>

@optional

- (CGRect)frameOfPresetedViewInContainerView:(nullable UIView *)containerView;

@end

@interface XHBCustomPresentationController: UIPresentationController

@property (nonatomic, weak) id<XHBCustomPresentationControllerDelegate> customPresetationDelegate;

@end

@interface XHBCustomTransitioning: NSObject

@property (nonatomic, nullable, strong) id<UIViewControllerInteractiveTransitioning> interactiveTransitioning;

@end

@interface XHBCustomModalTransitioningConfiguration : NSObject <XHBCustomPresentationControllerDelegate>

@property (nonatomic, assign) BOOL effect;
@property (nonatomic, assign) CGSize displayedSize;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign, getter=isTransitioning) BOOL transitioning;

@property (nonatomic, readonly, nullable, strong) XHBCustomTransitioningAnimator *presentAnimation;
@property (nonatomic, readonly, nullable, strong) XHBCustomTransitioningAnimator *dismissAnimation;

@end

@interface XHBCustomModalTransitioning : XHBCustomTransitioning <UIViewControllerTransitioningDelegate>

@property (nonatomic, nullable, strong) UIPresentationController *presentationController;
@property (nonatomic, nullable, strong) XHBCustomModalTransitioningConfiguration *configuration;

+ (instancetype)customModalTransitioningWithTransitioningConfiguration:(XHBCustomModalTransitioningConfiguration *)configuration
                                                presentationController:(UIPresentationController *)presentationController;

@end

@interface XHBCustomNavigationTransitioning : XHBCustomTransitioning <UINavigationControllerDelegate>

@property (nonatomic, nullable, strong) XHBCustomTransitioningAnimator *pushAnimation;
@property (nonatomic, nullable, strong) XHBCustomTransitioningAnimator *popAnimation;

@end

@interface XHBCustomTabTransitioning: XHBCustomTransitioning <UITabBarControllerDelegate>

@property (nonatomic, nullable, strong) XHBCustomTransitioningAnimator *tabTransitionAnimation;

@end

@interface UIViewController (XHBCustomTransitioning)

- (void)customModalPresentViewController:(UIViewController *)vc
                           configuration:(nullable XHBCustomModalTransitioningConfiguration *)configuration
                              completion:(void(^_Nullable)(void))completion;

- (void)dismissCustomModalAnimated:(BOOL)animated completion:(void(^_Nullable)(void))completion;

@end

@interface UIViewController (XHBCustomPopup)

- (void)showViewController:(UIViewController *)viewController configuration:(XHBCustomModalTransitioningConfiguration *)configuration;

- (void)disapear;

@end

NS_ASSUME_NONNULL_END
