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
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let dstViewController = transitionContext.viewController(forKey: .to)
        let srcViewController = transitionContext.viewController(forKey: .from)
        guard let dstView = dstViewController?.view,
              let srcView = srcViewController?.view else {
            return
        }
        let srceView: UIView
        let destView: UIView
        if forward {
            containerView.insertSubview(dstView, aboveSubview: srcView)
            srceView = srcView
            destView = dstView
        } else {
            containerView.insertSubview(dstView, belowSubview: srcView)
            srceView = dstView
            destView = srcView
        }
        doAnimation(srceView, destView, transitionContext)
    }
    
    open func doAnimation(_ from: UIView, _ to: UIView, _ transitionContext: UIViewControllerContextTransitioning) {}
}

open class UIViewControllerCustomTransitioning: NSObject {
    
    public typealias Key = String
    
    open var interactionTransition: UIViewControllerInteractiveTransitioning?
    fileprivate var customAnimatedTransitioningInfo = [Key : UIViewControllerCustomAnimatedTransitioning]()
    
    open func setCustomAnimatedTransition(_ customAnimatedTransitioning: UIViewControllerCustomAnimatedTransitioning, for key: Key) {
        customAnimatedTransitioningInfo[key] = customAnimatedTransitioning
    }
    
    open func customAnimatedTransition(for key: Key) -> UIViewControllerCustomAnimatedTransitioning? {
        return customAnimatedTransitioningInfo[key]
    }
}

open class UIViewControllerCustomModalTransitioning: UIViewControllerCustomTransitioning, UIViewControllerTransitioningDelegate {
    
    public static let present: Key = "present"
    public static let dismiss: Key = "dismss"
    
    open var presentationController: UIPresentationController?
    
    open func animationController(forPresented presented: UIViewController,
                                  presenting: UIViewController,
                                  source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimatedTransition(for: UIViewControllerCustomModalTransitioning.present)
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimatedTransition(for: UIViewControllerCustomModalTransitioning.dismiss)
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
    
    public static let push: Key = "push"
    public static let pop:  Key = "pop"
    
    open func navigationController(_ navigationController: UINavigationController,
                                   animationControllerFor operation: UINavigationController.Operation,
                                   from fromVC: UIViewController,
                                   to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimatedTransition(for: UIViewControllerCustomNavigationTransitioning.push)
    }
    
    open func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionTransition
    }
}

open class UIViewControllerCustomTabTransitioning: UIViewControllerCustomTransitioning, UITabBarControllerDelegate {
    
    open func tabBarController(_ tabBarController: UITabBarController,
                               animationControllerForTransitionFrom fromVC: UIViewController,
                               to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimatedTransitioningInfo["\(tabBarController.selectedIndex)"]
    }
    
    open func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return interactionTransition
    }
}
