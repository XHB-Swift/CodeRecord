//
//  GradientProgressViewController.swift
//  CodeRecord-Swift
//
//  Created by 谢鸿标 on 2022/4/17.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

import UIKit

class GradientProgressViewController: UIViewController {

    var gradientProgressView: LineGradientProgressView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        let progressView = LineGradientProgressView(frame: CGRect(x: 50, y: 100, width: 250, height: 10))
        progressView.backgroundLayer.strokeColor = UIColor.init(argbHexString: "CDCDB4")?.cgColor
        progressView.progressLayer.strokeColor = progressView.backgroundLayer.strokeColor
        progressView.setGradientColors(["FFFACD", "D2691E"])
        progressView.setLocations([0,1])
        progressView.setStartPoint(CGPoint(x: 0, y: 0))
        progressView.setEndPoint(CGPoint(x: 1, y: 1))
        view.addSubview(progressView)
        gradientProgressView = progressView
        
        let slider = UISlider(frame: CGRect(x: 50, y: 200, width: 250, height: 15))
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.addTarget(self, action: #selector(sliderAction(_:)), for: .valueChanged)
        view.addSubview(slider)
    }
    
    @objc func sliderAction(_ sender: UISlider) {
        gradientProgressView?.progress = CGFloat(sender.value)
    }
}
