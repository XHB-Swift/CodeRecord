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
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) UIViewAnimationOptions option;

- (void)doAnimationFrom:(UIView *)from to:(UIView *)to transitionContext:(id<UIViewControllerContextTransitioning>)context;

@end

@interface XHBCustomPresentationController: UIPresentationController

@end

@interface XHBCustomTransitioning: NSObject

@property (nonatomic, nullable, strong) id<UIViewControllerInteractiveTransitioning> interactiveTransitioning;

@end

@interface XHBCustomModalTransitioning : XHBCustomTransitioning <UIViewControllerTransitioningDelegate>

@property (nonatomic, nullable, strong) UIPresentationController *presentationController;
@property (nonatomic, nullable, strong) XHBCustomTransitioningAnimator *presentAnimation;
@property (nonatomic, nullable, strong) XHBCustomTransitioningAnimator *dismissAnimation;

+ (instancetype)customModalTransitioningWithPresentAnimation:(XHBCustomTransitioningAnimator *)presentAnimation
                                            dismissAnimation:(XHBCustomTransitioningAnimator *)dismissAnimation
                                      presentationController:(UIPresentationController *)presentationController;

@end

@interface XHBCustomNavigationTransitioning : XHBCustomTransitioning <UINavigationControllerDelegate>

@property (nonatomic, nullable, strong) XHBCustomTransitioningAnimator *pushAnimation;
@property (nonatomic, nullable, strong) XHBCustomTransitioningAnimator *popAnimation;

@end

@interface XHBCustomTransitioningManager : NSObject

+ (instancetype)sharedManager;

- (void)setTransitioning:(XHBCustomTransitioning *)transitioning forKey:(NSString *)key;
- (void)removeTransitioningForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
