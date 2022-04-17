//
//  CustomStyleButton.swift
//  CodeRecord-Swift
//
//  Created by xiehongbiao on 2021/12/9.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

import UIKit

open class CustomStyleButton: UIButton {
    
    private(set) var type: StyleType = .TopImageBottomText
    
    public var spacing: CGFloat = 10

    public convenience init(style styleType: StyleType) {
        self.init(type: .custom)
        type = styleType
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.sizeToFit()
        titleLabel?.sizeToFit()
        styleLayoutImageTextContent()
    }
    
    private func styleLayoutImageTextContent() {
        let isTopText = type == .TopTextBottomImage
        let isTopImage = type == .TopImageBottomText
        let isLeftText = type == .LeftTextRightImage
        let isLeftImage = type == .LeftImageRightText
        let isVeriticalLayout = isTopText || isTopImage
        let isHorizontalLayout = isLeftText || isLeftImage
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        if isVeriticalLayout {
            
            let height: CGFloat = (imageView?.height ?? 0) + (titleLabel?.height ?? 0) + spacing
            if height > self.height {
                self.height = height
            } else {
                y = (self.height - height) / 2
            }
            
            let width: CGFloat = max((imageView?.width ?? 0), titleLabel?.width ?? 0)
            if width > self.width {
                self.width = width
            } else {
                x = (self.width - width) / 2
            }
            
            if isTopText {
                titleLabel?.origin = CGPoint(x: x, y: y)
                imageView?.y = (titleLabel?.bottom ?? 0) + spacing
                imageView?.centerX = self.width / 2
            } else if isTopImage {
                imageView?.origin = CGPoint(x: x, y: y)
                titleLabel?.y = (imageView?.bottom ?? 0) + spacing
                titleLabel?.centerX = self.width / 2
            }
            
        } else if isHorizontalLayout {
            
            let width: CGFloat = (imageView?.width ?? 0) + (titleLabel?.width ?? 0) + spacing
            if width > self.width {
                self.width = width
            } else {
                x = (self.width - width) / 2
            }
            
            let height: CGFloat = max((imageView?.height ?? 0), (titleLabel?.height ?? 0))
            if height > self.height {
                self.height = height
            } else {
                y = (self.height - height) / 2
            }
            
            if isLeftText {
                titleLabel?.origin = CGPoint(x: x, y: y)
                imageView?.x = (titleLabel?.right ?? 0) + spacing
                imageView?.centerY = self.height / 2
            } else if isLeftImage {
                imageView?.origin = CGPoint(x: x, y: y)
                titleLabel?.x = (imageView?.right ?? 0) + spacing
                titleLabel?.centerY = self.height / 2
            }
        }
    }

}

extension CustomStyleButton {
    
    public enum StyleType: Int {
        
        case TopImageBottomText = 0
        case TopTextBottomImage = 1
        case LeftImageRightText = 2
        case LeftTextRightImage = 3
        
    }
    
}
