//
//  ThemeSwitchDemoViewController.swift
//  CodeRecord-Swift
//
//  Created by xiehongbiao on 2021/9/9.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

import UIKit


class ThemeSwitchDemoViewController: UIViewController {
    
    var textLabel: UILabel?
    var switchControl: UISwitch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.theme_set(backgroundColor: ColorStyle(color: "ffffff", alpha: 1), for: .light)
        view.theme_set(backgroundColor: ColorStyle(color: "000000", alpha: 1), for: .dark)
        let label = UILabel()
        label.text = "123456"
        label.textColor = .black
        label.theme_set(textColor: ColorStyle(color: "000000", alpha: 1), for: .light)
        label.theme_set(textColor: ColorStyle(color: "ffffff", alpha: 1), for: .dark)
        label.font = UIFont(name: "PingFangSC-Regular", size: 18)
        label.sizeToFit()
        view.addSubview(label)
        textLabel = label
        
        let switchCtrl = UISwitch(frame: CGRect(origin: .zero, size: CGSize(width: 60, height: 30)))
        switchCtrl.isOn = true
        switchCtrl.addTarget(self, action: #selector(switchCtrlAction(_:)), for: .touchUpInside)
        view.addSubview(switchCtrl)
        switchControl = switchCtrl
    }
    
    @objc func switchCtrlAction(_ sender: UISwitch) {
        ThemeManager.shared.switchTo(style: sender.isOn ? .light : .dark)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        textLabel?.y = 100
        textLabel?.centerX = view.width / 2
        
        switchControl?.y = (textLabel?.bottom ?? 0) + 30
        switchControl?.centerX = textLabel?.centerX ?? 0
    }
}
