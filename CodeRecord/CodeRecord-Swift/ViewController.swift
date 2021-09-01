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
        let config = UIViewController.CustomTransitioningConfig(direction: .top,
                                                                displaySize: CGSize(width: view.width,
                                                                                    height: view.height / 2))
        present(viewController: ViewController1(),
                animated: true,
                transitionConfig: config,
                completion: nil)
    }
}

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
        
        let button1 = UIButton(type: .custom)
        button1.setTitle("导航", for: .normal)
        button1.setTitleColor(.black, for: .normal)
        button1.addTarget(self, action: #selector(btn1Action(_:)), for: .touchUpInside)
        button1.sizeToFit()
        button1.origin = CGPoint(x: button.right + 30, y: button.y)
        view.addSubview(button1)
    }
    
    @objc func btnAction(_ sender: UIButton) {
//        dismiss(animated: true, completion: nil)
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
//        dismiss(animated: true, completion: nil)
        dismissCustomModal(animated: true, completion: nil)
    }
}
