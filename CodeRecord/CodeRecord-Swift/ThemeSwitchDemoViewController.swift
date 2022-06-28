//
//  ThemeSwitchDemoViewController.swift
//  CodeRecord-Swift
//
//  Created by xiehongbiao on 2021/9/9.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

import UIKit
import XHBCommonSwiftLib

extension String {
    static let theme_dark = "dark"
    static let theme_light = "light"
}

class ThemeSwitchDemoViewController: UIViewController {
    
    let view1 = UIView(frame: .zero)
    let view2 = UIView(frame: .zero)
    
    let label1 = UILabel(frame: .zero)
    let label2 = UILabel(frame: .zero)
    
    let themeSwicther = UISwitch(frame: .zero)
    
    deinit {
        NotificationCenter.default.removeAllThemeObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.theme_backgroundColor = .init(value: "FFFFFFFF", type: .theme_light)
        view.theme_backgroundColor = .init(value: "FF000000", type: .theme_dark)
        setupSubviews()
    }
    
    func setupSubviews() {
        setupColorViews()
        setupColorLabels()
        view.addSubview(themeSwicther)
        themeSwicther.addTarget(self, action: #selector(switchThemeAction(_:)), for: .touchUpInside)
        themeSwicther.isOn = false
        self.currentThemeType = .theme_light
    }
    
    func setupColorViews() {
        view.addSubview(view1)
        view.addSubview(view2)
        
        view1.theme_backgroundColor = .init(value: "FF6A5ACD", type: .theme_light)
        view2.theme_backgroundColor = .init(value: "FF4169E1", type: .theme_light)
        view1.theme_backgroundColor = .init(value: "FFFFE4E1", type: .theme_dark)
        view2.theme_backgroundColor = .init(value: "FFE6E6FA", type: .theme_dark)
    }
    
    func setupColorLabels() {
        view.addSubview(label1)
        view.addSubview(label2)
        
        label1.text = "测试测试"
        label2.text = "测试测试"
        
        label1.theme_textColor = .init(value: "FF483D8B", type: .theme_light)
        label2.theme_textColor = .init(value: "FF006400", type: .theme_light)
        
        label1.theme_textColor = .init(value: "FFBBFFFF", type: .theme_dark)
        label2.theme_textColor = .init(value: "FFFFFFE0", type: .theme_dark)
    }
    
    @objc func switchThemeAction(_ sender: UISwitch) {
        self.currentThemeType = sender.isOn ? .theme_dark : .theme_light
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view1.frame = CGRect(origin: .init(x: 50, y: 120), size: .init(width: 60, height: 60))
        view2.frame = CGRect(origin: .init(x: 50, y: view1.bottom + 10), size: .init(width: 60, height: 60))
        label1.frame = CGRect(origin: .init(x: view1.right + 10, y: view1.y), size: .init(width: 70, height: 30))
        label2.frame = CGRect(origin: .init(x: view2.right + 10, y: view2.y), size: .init(width: 70, height: 30))
        themeSwicther.size = .init(width: 60, height: 30)
        themeSwicther.center = .init(x: view.width / 2, y: view.height / 2)
    }
}
