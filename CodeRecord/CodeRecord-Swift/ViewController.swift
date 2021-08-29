//
//  ViewController.swift
//  CodeRecord-Swift
//
//  Created by 谢鸿标 on 2021/8/26.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .custom)
        button.setTitle("跳转", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(jumpAction(_:)), for: .touchUpInside)
        button.sizeToFit()
        button.center = CGPoint(x: (view.width-button.width) / 2,
                                y: (view.height-button.height) / 2)
        view.addSubview(button)
    }
    
    @objc func jumpAction(_ sender: UIButton) {
        customPresent(viewController: ViewController2(),
                      animated: true,
                      config: UIViewController.CustomTransitioningConfig(displaySize: CGSize(width: view.width, height: view.height / 2)),
                      completion: nil)
    }
}

class ViewController2: UIViewController {
    
    var btn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let button = UIButton(type: .custom)
        button.setTitle("返回", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(jumpAction(_:)), for: .touchUpInside)
        button.sizeToFit()
        view.addSubview(button)
        btn = button
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let btn1 = btn else { return }
        btn1.center = CGPoint(x: (view.width-btn1.width) / 2,
                              y: (view.height-btn1.height) / 2)
    }
    
    @objc func jumpAction(_ sender: UIButton) {
        let dismissAnimation = XHBDirectionAnimatedTransitioning()
        dismissAnimation.duration = 0.5
        dismissAnimation.transitionDirection = .bottom
        customDismiss(animated: true, animation: dismissAnimation, completion: nil)
    }
}
