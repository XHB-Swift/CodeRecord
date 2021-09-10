//
//  UIViewControllerCustomTransition.swift
//  CodeRecord-Swift
//
//  Created by 谢鸿标 on 2021/8/28.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

import UIKit


open class UIViewControllerCustomAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    open var forward = true //true正向动画，false反向动画
    open var duration: TimeInterval = 0
    open var options: UIView.AnimationOptions = [.curveEaseInOut]
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return (transitionContext?.isAnimated ?? false) ? duration : 0
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let dstViewController = transitionContext.viewController(forKey: .to)
        let srcViewController = transitionContext.viewController(forKey: .from)
        guard let dstView = dstViewController?.view,
              let srcView = srcViewController?.view else {
            return
        }
        if forward {
            containerView.insertSubview(dstView, aboveSubview: srcView)
        } else {
            if dstView.superview == nil {
                containerView.insertSubview(dstView, belowSubview: srcView)
            }
        }
        doAnimation(srcView, dstView, transitionContext)
    }
    
    open func doAnimation(_ from: UIView, _ to: UIView, _ transitionContext: UIViewControllerContextTransitioning) {}
}

open class UIViewCustomPresentationController: UIPresentationController {
    
    private(set) lazy var dimmingView = { () -> UIView in
        let view = UIView(frame: .zero)
        view.alpha = 0.5
        view.backgroundColor = .black
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDimmingViewAction(_:))))
        return view
    }()
    
    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = .custom
    }
    
    open override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView?.bounds ?? .zero
        presentedView?.frame = frameOfPresentedViewInContainerView
        containerView?.addSubview(dimmingView)
        let tmpAlpha = dimmingView.alpha
        dimmingView.alpha = 0
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.dimmingView.alpha = tmpAlpha
        }, completion: nil)
    }
    
    open override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    open override func dismissalTransitionWillBegin() {
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.dimmingView.alpha = 0
        }, completion: nil)
    }
    
    open override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    open override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        if container.isEqual(presentedViewController) {
            containerView?.setNeedsLayout()
        }
    }
    
    open override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if container.isEqual(presentedViewController) {
            return frameOfPresentedViewInContainerView.size
        }else {
            return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
        }
    }
    
    open override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        dimmingView.frame = containerView?.bounds ?? .zero
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    @objc private func tapDimmingViewAction(_ sender: UITapGestureRecognizer) {
        presentedViewController.dismissCustomModal(animated: true, completion: nil)
    }
}

open class UIViewControllerCustomTransitioning: NSObject {
    
    open var interactionTransition: UIViewControllerInteractiveTransitioning?
}

open class UIViewControllerCustomModalTransitioning: UIViewControllerCustomTransitioning,
                                                     UIViewControllerTransitioningDelegate {
    
    open var presentationController: UIPresentationController?
    open var presentAnimation: UIViewControllerCustomAnimatedTransitioning?
    open var dismissAnimation: UIViewControllerCustomAnimatedTransitioning?
    
    deinit {
        print("deinit UIViewControllerCustomModalTransitioning")
    }
    
    public override init() {}
    
    public init(presentAnimation: UIViewControllerCustomAnimatedTransitioning?,
                dismissAnimation: UIViewControllerCustomAnimatedTransitioning? = nil,
                presentationController: UIPresentationController? = nil) {
        self.presentAnimation = presentAnimation
        self.dismissAnimation = dismissAnimation
        self.presentationController = presentationController
    }
    
    open func animationController(forPresented presented: UIViewController,
                                  presenting: UIViewController,
                                  source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentAnimation?.forward = true
        return presentAnimation
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissAnimation != nil {
            dismissAnimation?.forward = false
            return dismissAnimation
        }else {
            presentAnimation?.forward = false
            return presentAnimation
        }
    }
    
    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return interactionTransition
    }
    
    open func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return interactionTransition
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return presentationController
    }
}

open class UIViewControllerCustomNavigationTransitioning: UIViewControllerCustomTransitioning, UINavigationControllerDelegate {
    
    open var pushAnimation: UIViewControllerCustomAnimatedTransitioning?
    open var popAnimation: UIViewControllerCustomAnimatedTransitioning?
    
    open func navigationController(_ navigationController: UINavigationController,
                                   animationControllerFor operation: UINavigationController.Operation,
                                   from fromVC: UIViewController,
                                   to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return pushAnimation
    }
    
    open func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionTransition
    }
}

open class UIViewControllerCustomTabTransitioning: UIViewControllerCustomTransitioning, UITabBarControllerDelegate {
    
    open var tabSwitchAnimations: [UIViewControllerCustomAnimatedTransitioning]?
    
    open func tabBarController(_ tabBarController: UITabBarController,
                               animationControllerForTransitionFrom fromVC: UIViewController,
                               to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let selectedIdx = tabBarController.selectedIndex
        return (selectedIdx < (tabSwitchAnimations?.count ?? 0)) ? tabSwitchAnimations?[selectedIdx] : nil
    }
    
    open func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return interactionTransition
    }
}

public final class XHBCustomTransitioningManager {
    
    private var transitionings = Dictionary<String,UIViewControllerCustomTransitioning>()
    private init() {}
    public static let shared = XHBCustomTransitioningManager()
    
    public func setTransitioning(_ transitioning: UIViewControllerCustomTransitioning, for key: String) {
        transitionings[key] = transitioning
    }
    
    public func removeTransitioning(for key: String) {
        _ = transitionings.removeValue(forKey: key)
    }
}

