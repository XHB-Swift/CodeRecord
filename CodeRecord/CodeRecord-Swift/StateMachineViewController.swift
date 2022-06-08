//
//  StateMachineViewController.swift
//  CodeRecord-Swift
//
//  Created by 谢鸿标 on 2022/5/21.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

import UIKit

class StateMachineViewController : UIViewController {
    
    var button: UIButton?
    var textField: UITextField?
    let stateMachine = StateMachine<String,Int>(state: 0)
    
    var inputText = Trimmed("")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let btn = UIButton(type: .custom)
        btn.setTitle("正常", for: .normal)
        btn.setTitle("选中", for: .selected)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.black, for: .selected)
        btn.sizeToFit()
        btn.origin = CGPoint(x: 50, y: 100)
        btn.addTarget(self, action: #selector(switchStateAction(_:)), for: .touchUpInside);
        view.addSubview(btn)
        self.button = btn
        
        let txf = UITextField(frame: CGRect(x: 50, y: 250, width: 100, height: 30))
        txf.delegate = self
        txf.borderStyle = .roundedRect
        view.addSubview(txf)
        self.textField = txf
        
        stateMachine.register(event: "SwitchStateEvent",
                              from: Int(UIButton.State.normal.rawValue),
                              to: Int(UIButton.State.selected.rawValue)) { [weak self] state in
            let convertState = UIButton.State(rawValue: UInt(state))
            self?.button?.isSelected = (convertState == .selected)
        }
        stateMachine.register(event: "SwitchStateEvent",
                              from: Int(UIButton.State.selected.rawValue),
                              to: Int(UIButton.State.normal.rawValue)) { [weak self] state in
            let convertState = UIButton.State(rawValue: UInt(state))
            self?.button?.isSelected = (convertState == .selected)
        }
    }
    
    @objc func switchStateAction(_ sender: UIButton) {
        stateMachine.trigger(event: "SwitchStateEvent")
    }
}

extension StateMachineViewController : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.inputText.wrappedValue = textField.text ?? ""
        print("self.inputText = \(String(describing: self.inputText))")
    }
    
}
