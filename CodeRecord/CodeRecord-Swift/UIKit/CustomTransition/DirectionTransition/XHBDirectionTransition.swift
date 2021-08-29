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
    open var transitionDirection: XHBTransitionDirection = .left
    
    open override func doAnimation(_ from: UIView, _ to: UIView, _ transitionContext: UIViewControllerContextTransitioning) {
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: animations(from, to, self.forward)) { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func animations(_ from: UIView, _ to: UIView, _ forward: Bool) -> (() -> Void) {
        switch transitionDirection {
        case .top:
            let initialeY = forward ? -from.height : 0
            let animatedY = forward ? 0 : -from.height
            to.y = initialeY
            return {
                to.y = animatedY
                to.setNeedsDisplay()
            }
        case .bottom:
            let initialeY = forward ? from.height : 0
            let animatedY = forward ? 0 : from.height
            to.y = initialeY
            return {
                to.y = animatedY
                to.setNeedsDisplay()
            }
        case .left:
            let initialeX = forward ? -from.width : 0
            let animatedX = forward ? 0 : -from.width
            to.x = initialeX
            return {
                to.y = animatedX
                to.setNeedsDisplay()
            }
        case .right:
            let initialeX = forward ? from.width : 0
            let animatedX = forward ? 0 : from.width
            to.x = initialeX
            return {
                to.y = animatedX
                to.setNeedsDisplay()
            }
        case .center:
            return {
                
            }
        }
    }
}

open class XHBDirectionPresentationController: UIPresentationController {
    
    open var controllerSize: CGSize = .zero
    open var dismissAnimation: UIViewControllerCustomAnimatedTransitioning?
    
    fileprivate var direction: XHBTransitionDirection = .left
    fileprivate lazy var dimmingView = { () -> UIView in
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDimmingViewAction(_:))))
        return view
    }()
    fileprivate var presentedFrame: CGRect = .zero
    
    public convenience init(presented: UIViewController, presenting: UIViewController?, direction: XHBTransitionDirection) {
        self.init(presentedViewController: presented, presenting: presenting)
        self.direction = direction
    }
    
    open override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = self.containerView else { return .zero }
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: self.presentedViewController, withParentContainerSize: containerView.size)
        
        let containerSize = containerView.size
        
        switch self.direction {
        case .left:
            frame.origin = .zero
        case .right:
            frame.origin.x = containerSize.width - controllerSize.width
        case .bottom:
            frame.origin.y = containerSize.height - controllerSize.width
        case .top:
            frame.origin = .zero
        case .center:
            frame.origin = CGPoint(x: (containerView.width - controllerSize.width) / 2,
                                   y: (containerView.height - controllerSize.height) / 2)
        }
        return frame
    }
    
    open override var preferredContentSize: CGSize {
        return self.controllerSize
    }
    
    open override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return self.controllerSize
    }
    
    open override func presentationTransitionWillBegin() {
        guard let containerView = self.containerView else { return }
        dimmingView.frame = containerView.bounds
        dimmingView.alpha = 0
        containerView.insertSubview(dimmingView, at: 0)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.dimmingView.alpha = 1.0
        }, completion: nil)
    }
    
    open override func dismissalTransitionWillBegin() {
        dimmingView.alpha = 1
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.dimmingView.alpha = 0
        }, completion: nil)
    }
    
    open override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    open override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    open override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        self.presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    @objc private func tapDimmingViewAction(_ sender: UITapGestureRecognizer) {
        self.presentedViewController.customDismiss(animated: true, animation: dismissAnimation, completion: nil)
    }
}

fileprivate class XHBTransitionManager: NSObject {
    
    private var transitionTable = [Int:UIViewControllerCustomTransitioning]()
    
    private override init() {
        super.init()
    }
    
    public static let shared = XHBTransitionManager()
    
    public func set(transition: UIViewControllerCustomTransitioning, for key: Int) {
        transitionTable[key] = transition
    }
    
    public func transition(for key: Int) -> UIViewControllerCustomTransitioning? {
        return transitionTable[key]
    }
    
    public func remove(transitionForKey key: Int) {
        transitionTable.removeValue(forKey: key)
    }
}

extension UIViewController {
    
    public struct CustomTransitioningConfig {
        public var effect = true
        public var duration: TimeInterval = 0.5
        public var direction: XHBTransitionDirection = .bottom
        public var displaySize: CGSize
        
        public static let noramlConfig = CustomTransitioningConfig(displaySize: .zero)
    }
    
    open func customPresent(viewController: UIViewController,
                            animated: Bool = true,
                            config: CustomTransitioningConfig = .noramlConfig,
                            completion: (()->Void)?) {
        if animated && config.effect {
            let presentAnimation = XHBDirectionAnimatedTransitioning()
            presentAnimation.duration = config.duration
            presentAnimation.transitionDirection = config.direction
            let presentation = XHBDirectionPresentationController(presented: viewController, presenting: self, direction: config.direction)
            if config.displaySize.width > 0 && config.displaySize.height > 0 {
                presentation.controllerSize = config.displaySize
            }
            let customModalTransition = UIViewControllerCustomModalTransitioning()
            customModalTransition.setCustomAnimatedTransition(presentAnimation, for: UIViewControllerCustomModalTransitioning.present)
            customModalTransition.presentationController = presentation
            viewController.modalPresentationStyle = .custom
            viewController.transitioningDelegate = customModalTransition
            XHBTransitionManager.shared.set(transition: customModalTransition, for: viewController.hash)
        }
        present(viewController, animated: animated, completion: completion)
    }
    
    open func customDismiss(animated: Bool,
                            animation: UIViewControllerCustomAnimatedTransitioning?,
                            completion: (()->Void)?) {
        dismiss(animated: animated) { [weak self] in
            guard let key = self?.hash else { return }
            XHBTransitionManager.shared.remove(transitionForKey: key)
            completion?()
        }
    }
    
}

