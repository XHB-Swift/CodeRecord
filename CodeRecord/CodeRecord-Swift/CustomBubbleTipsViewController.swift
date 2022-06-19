//
//  CustomBubbleTipsViewController.swift
//  CodeRecord-Swift
//
//  Created by 谢鸿标 on 2022/6/19.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

import UIKit
import XHBCommonSwiftLib

class CustomBubbleTipsViewController: UIViewController {
    
    let contentLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(contentLabel)
        contentLabel.numberOfLines = 0
        let attibutedString = NSAttributedString(string: "This is a bezier path bubble tips",
                                                 attributes: [
                                                    .font : UIFont(name: "PingFangSC-Medium",
                                                                   size: 16) as Any,
                                                    .foregroundColor : UIColor(argbHexString: "FFFFC1C1") as Any,
                                                 ])
        let size = attibutedString.boundingRect(with: CGSize(width: 150,
                                                     height: view.height),
                                                options: [
                                                    .usesLineFragmentOrigin,
                                                    .usesFontLeading,
                                                ],
                                                context: nil).size
        contentLabel.attributedText = attibutedString
        contentLabel.size = size
        contentLabel.center = CGPoint(x: view.width / 2, y: view.height / 2)
        
        createUpArrowTips()
        createDownArrowTips()
        createLeftArrowTips()
//        createRightArrowTips()
    }
    
    func createLabelTips(position: CGPoint, tips: String, direction: BezierPathBubbleTipsView.ArrowDirection) {
        let label = UILabel()
        label.numberOfLines = 0
        let attrString: AttributedInterpotationString = """
        This is an \(tips, .color("FFF0FFF0")) tips
        """
        label.attributedText = attrString.attributedString
        label.sizeToFit()
        let bubbleTips = BezierPathBubbleTipsView(customView: label)
        bubbleTips.frame = view.bounds
        bubbleTips.point = position
        bubbleTips.arrowDirection = direction
        bubbleTips.arrowPosition = .leading(offset: 10)
        bubbleTips.bubbleColor = UIColor(hexString: "53868B", alpha: 0.8)
        bubbleTips.contentInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        bubbleTips.updateLayout()
        view.addSubview(bubbleTips)
    }
    
    func createUpArrowTips() {
        let point = CGPoint(x: contentLabel.x, y: contentLabel.bottom + 4)
        createLabelTips(position: point, tips: "up arrow", direction: .up)
    }
    
    func createDownArrowTips() {
        let point = CGPoint(x: contentLabel.x, y: contentLabel.y - 4)
        createLabelTips(position: point, tips: "down arrow", direction: .down)
    }
    
    func createLeftArrowTips() {
        let point = CGPoint(x: contentLabel.right + 4, y: contentLabel.y + 4)
        createLabelTips(position: point, tips: "left arrow", direction: .left)
    }
    
    func createRightArrowTips() {
        let point = CGPoint(x: 0, y: contentLabel.y + 4)
        createLabelTips(position: point, tips: "right arrow", direction: .right)
    }
}
