//
//  InterpotaionStringDemoViewController.swift
//  CodeRecord-Swift
//
//  Created by xiehongbiao on 2021/12/23.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

import UIKit

class InterpotaionStringDemoViewController: UIViewController {
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(label)
        
        let attrString: AttributedInterpotationString = """
              Hello \("Jack", .color(.red))!
              Go here \("learn more about String Interpolation", .link("https://github.com/apple/swift-evolution/blob/master/proposals/0228-fix-expressiblebystringinterpolation.md"),
                  .color(.blue),
                  .bgColor(.init(hexString: "f98ad0")!))
        """
        label.attributedText = attrString.attributedString
        label.numberOfLines = 0
        label.sizeToFit()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        label.center = CGPoint(x: view.width / 2, y: view.height / 2)
    }
}
