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
        let isVeriticalLayout = type == .TopImageBottomText || type == .TopTextBottomImage
        if isVeriticalLayout {
            height += spacing
        }else {
            width += spacing
        }
        let center = CGPoint(x: width / 2, y: height / 2)
        if isVeriticalLayout {
            imageView?.centerX = center.x
            titleLabel?.centerX = center.x
            if type == .TopImageBottomText {
                titleLabel?.y = (imageView?.bottom ?? 0) + spacing
            }else {
                imageView?.y = (titleLabel?.bottom ?? 0) + spacing
            }
        }else {
            imageView?.centerY = center.y
            titleLabel?.centerY = center.y
            if type == .LeftImageRightText {
                titleLabel?.x = (imageView?.right ?? 0) + spacing
            }else {
                imageView?.x = (titleLabel?.right ?? 0) + spacing
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
