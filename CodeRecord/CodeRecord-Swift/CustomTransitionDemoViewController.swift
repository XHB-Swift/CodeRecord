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
        
        title = "ViewController1"
        view.backgroundColor = .randomColor
        
        let button = UIButton(type: .custom)
        button.setTitle("返回", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        button.sizeToFit()
        button.origin = CGPoint(x: 50, y: 100)
        view.addSubview(button)
        btn = button
        
        if navigationController != nil {
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
        navigationController?.pushViewController(ViewController2(), animated: true)
    }
}

class ViewController2: UIViewController {
    
    var btn: UIButton?
    var txtField: UITextField?
    var keyboardOffsetY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "ViewController2"
        view.backgroundColor = .randomColor
        let button = UIButton(type: .custom)
        button.setTitle("返回", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        button.sizeToFit()
        view.addSubview(button)
        btn = button
        
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        textField.textColor = .black
        textField.borderStyle = .bezel
        view.addSubview(textField)
        txtField = textField
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardControl(_:)), name: UITextField.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardControl(_:)), name: UITextField.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        _ = view.endEditing(true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        btn?.center = CGPoint(x: (view.width-(btn?.width ?? 0)) / 2,
                              y: (view.height-(btn?.height ?? 0)) / 2)
        txtField?.centerX = btn?.centerX ?? 0
        txtField?.bottom = (view.height - 20)
    }
    
    @objc func btnAction(_ sender: UIButton) {
        dismissCustomModal(animated: true, completion: nil)
    }
    
    @objc func keyboardControl(_ sender: Notification) {
        guard let keyboardRect = sender.userInfo?[UITextField.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentView: UIView = navigationController?.view ?? view
        
        if keyboardRect.minY < contentView.bottom {
            keyboardOffsetY = contentView.bottom - keyboardRect.minY
            contentView.bottom -= keyboardOffsetY
        }else {
            contentView.bottom += keyboardOffsetY
        }
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
        let halfWindowConfig = UIViewController.CustomTransitioningConfig(direction: .bottom,
                                                                          displaySize: CGSize(width: view.width,
                                                                                              height: view.height / 2))
        present(viewController: UINavigationController(rootViewController: ViewController1()),
                animated: true,
                transitionConfig: halfWindowConfig,
                completion: nil)
    }
}