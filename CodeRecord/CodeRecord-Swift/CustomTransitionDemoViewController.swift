//
//  CustomTransitionDemoViewController.swift
//  CodeRecord-Swift
//
//  Created by xiehongbiao on 2021/9/2.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

import UIKit

class ViewController1: UIViewController {
    
    var btn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .randomColor
        
        let button = UIButton(type: .custom)
        button.setTitle("返回", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        button.sizeToFit()
        button.origin = CGPoint(x: 50, y: 100)
        view.addSubview(button)
        btn = button
        
        if self.navigationController != nil {
            let button1 = UIButton(type: .custom)
            button1.setTitle("导航", for: .normal)
            button1.setTitleColor(.black, for: .normal)
            button1.addTarget(self, action: #selector(btn1Action(_:)), for: .touchUpInside)
            button1.sizeToFit()
            button1.origin = CGPoint(x: button.right + 30, y: button.y)
            view.addSubview(button1)
        }
    }
    
    @objc func btnAction(_ sender: UIButton) {
        dismissCustomModal(animated: true, completion: nil)
    }
    
    @objc func btn1Action(_ sender: UIButton) {
        
    }
}

class ViewController2: UIViewController {
    
    var btn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .randomColor
        let button = UIButton(type: .custom)
        button.setTitle("返回", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        button.sizeToFit()
        button.center = CGPoint(x: (view.width-button.width) / 2,
                                y: (view.height-button.height) / 2)
        view.addSubview(button)
        btn = button
    }
    
    @objc func btnAction(_ sender: UIButton) {
        dismissCustomModal(animated: true, completion: nil)
    }
}


class CustomTransitionDemoViewController: UIViewController {
    
    private var jumpButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let button = UIButton(type: .custom)
        button.setTitle("跳转", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(jumpButtonAction(_:)), for: .touchUpInside)
        view.addSubview(button)
        jumpButton = button
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let navigationBarBottom = navigationController?.navigationBar.height ?? 0
        jumpButton?.centerX = view.width / 2
        jumpButton?.centerY = 100 + navigationBarBottom
    }
    
    @objc func jumpButtonAction(_ sender: UIButton) {
        present(viewController: ViewController1(), animated: true, transitionConfig: .windowNormalConfig, completion: nil)
    }
}
