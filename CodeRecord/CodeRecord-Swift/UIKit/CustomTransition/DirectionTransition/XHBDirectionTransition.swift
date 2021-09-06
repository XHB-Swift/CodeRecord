//
//  XHBDirectionTransition.swift
//  CodeRecord-Swift
//
//  Created by 谢鸿标 on 2021/8/28.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

import UIKit

public enum XHBTransitionDirection {
    case top
    case left
    case bottom
    case right
    case center
}


open class XHBDirectionAnimatedTransitioning: UIViewControllerCustomAnimatedTransitioning {
    
    //从左边进就从左边出
    open var direction: XHBTransitionDirection = .left
    
    open override func doAnimation(_ from: UIView,
                                   _ to: UIView,
                                   _ transitionContext: UIViewControllerContextTransitioning) {
        animationWillBegin(with: from, to)
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: options) { [weak self] in
            self?.animationDidBegin(with: from, to)
        } completion: { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func animationWillBegin(with srcView: UIView, _ dstView: UIView) {
        guard let superView = dstView.superview else { return }
        switch direction {
        case .left:
            if self.forward {
                dstView.x = -superView.width
            }else {
                srcView.x = 0
            }
            break
        case .right:
            if self.forward {
                dstView.x = superView.width
            }else {
                srcView.x = 0
            }
            break
        case .top:
            if self.forward {
                dstView.y = -superView.height
            }else {
                srcView.y = 0
            }
            break
        case .bottom:
            if self.forward {
                dstView.y = superView.height
            }else {
                srcView.bottom = superView.height
            }
            break
        case .center:
            if self.forward {
                dstView.transform = .identity.scaledBy(x: 0.1, y: 0.1)
                dstView.alpha = 0
            }else {
                srcView.transform = .identity
                srcView.alpha = 1
            }
            break
        }
        
    }
    
    private func animationDidBegin(with srcView: UIView, _ dstView: UIView) {
        guard let superView = srcView.superview else { return }
        switch direction {
        case .left:
            if self.forward {
                dstView.x = 0
            }else {
                srcView.x = -superView.width
            }
            break
        case .right:
            if self.forward {
                dstView.x = 0
            }else {
                srcView.x = superView.width
            }
            break
        case .top:
            if self.forward {
                dstView.y = 0
            }else {
                srcView.y = -superView.height
            }
            break
        case .bottom:
            if self.forward {
                dstView.bottom = superView.height
            }else {
                srcView.y = superView.height
            }
            break
        case .center:
            if self.forward {
                dstView.transform = .identity
                dstView.alpha = 1
            }else {
                srcView.transform = .identity.scaledBy(x: 0.1, y: 0.1)
                srcView.alpha = 0
            }
            break
        }
    }
}

open class XHBDirectionPresentationController: UIViewCustomPresentationController {
    
    fileprivate var direction: XHBTransitionDirection = .left
    
    public convenience init(presented: UIViewController, presenting: UIViewController?, direction: XHBTransitionDirection) {
        self.init(presentedViewController: presented, presenting: presenting)
        self.direction = direction
    }
    
    open override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = self.containerView else { return .zero }
        let preferredContentSize = self.presentedViewController.preferredContentSize
        if preferredContentSize.width == 0 ||
            preferredContentSize.height == 0 ||
            preferredContentSize.height >= containerView.height {
            return containerView.bounds
        }
        var frame = CGRect(origin: .zero, size: preferredContentSize)
        
        switch self.direction {
        case .left:
            frame.origin.x = 0
        case .right:
            frame.origin.x = containerView.right - preferredContentSize.width
        case .top:
            frame.origin.y = 0
        case .bottom:
            frame.origin.y = containerView.height - preferredContentSize.height
        case .center:
            frame.origin = CGPoint(x: (containerView.width - preferredContentSize.width) / 2,
                                   y: (containerView.height - preferredContentSize.height) / 2)
        }
        return frame
    }
}

fileprivate final class XHBCustomTransitioningManager {
    
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

extension UIViewController {
    
    public struct CustomTransitioningConfig {
        public var effect = true
        public var duration: TimeInterval = 0.5
        public var direction: XHBTransitionDirection = .bottom
        public var displaySize: CGSize
        public var options: UIView.AnimationOptions = [.curveEaseInOut]
        
        public static let noramlConfig = CustomTransitioningConfig(displaySize: .zero)
        public static let windowNormalConfig = CustomTransitioningConfig(direction: .center,
                                                                         displaySize: CGSize(width: 300, height: 300))
    }
    
    open func present(viewController: UIViewController,
                      animated: Bool = true,
                      transitionConfig: CustomTransitioningConfig = .noramlConfig,
                      completion: (()->Void)?) {
        
        if animated && transitionConfig.effect {
            let presentAnimation = XHBDirectionAnimatedTransitioning()
            presentAnimation.forward = true
            presentAnimation.duration = transitionConfig.duration
            presentAnimation.direction = transitionConfig.direction
            presentAnimation.options = transitionConfig.options
            let dismissAnimation = XHBDirectionAnimatedTransitioning()
            dismissAnimation.forward = false
            dismissAnimation.duration = presentAnimation.duration
            dismissAnimation.direction = transitionConfig.direction
            dismissAnimation.options = transitionConfig.options
            viewController.preferredContentSize = transitionConfig.displaySize
            let presentation = XHBDirectionPresentationController(presented: viewController,
                                                                  presenting: self,
                                                                  direction: transitionConfig.direction)
            let customModalTransition = UIViewControllerCustomModalTransitioning(presentAnimation: presentAnimation,
                                                                                 dismissAnimation: dismissAnimation,
                                                                                 presentationController: presentation)
            viewController.transitioningDelegate = customModalTransition
            XHBCustomTransitioningManager.shared.setTransitioning(customModalTransition, for: "\(viewController)")
        }
        present(viewController, animated: animated, completion: completion)
    }
    
    open func dismissCustomModal(animated: Bool, completion: (()->Void)?) {
        let key = "\(self)"
        dismiss(animated: animated) {
            XHBCustomTransitioningManager.shared.removeTransitioning(for: key)
            completion?()
        }
    }
    
}

