//
//  AttributedInterpotationString.swift
//  CodeRecord-Swift
//
//  Created by xiehongbiao on 2021/12/23.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

import UIKit

public struct AttributedInterpotationString {
    
    public let attributedString: NSAttributedString
}

extension AttributedInterpotationString: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.attributedString = NSAttributedString(string: value)
    }
}

extension AttributedInterpotationString: CustomStringConvertible {
    
    public var description: String {
        return String(describing: self.attributedString)
    }
}

extension AttributedInterpotationString: ExpressibleByStringInterpolation {
    public init(stringInterpolation: StringInterpolation) {
        self.attributedString = NSAttributedString(attributedString: stringInterpolation.attributedString)
    }
    
    public struct StringInterpolation: StringInterpolationProtocol {
        public var attributedString: NSMutableAttributedString
        
        public init(literalCapacity: Int, interpolationCount: Int) {
            self.attributedString = NSMutableAttributedString()
        }
        
        public func appendLiteral(_ literal: String) {
            let astr = NSAttributedString(string: literal)
            self.attributedString.append(astr)
        }
        
        public func appendInterpolation(_ string: String, _ attributes: [NSAttributedString.Key : Any]) {
            let astr = NSAttributedString(string: string, attributes: attributes)
            self.attributedString.append(astr)
        }
        
        public func appendInterpolation(image: UIImage, scale: CGFloat = 1.0) {
            let attachment = NSTextAttachment()
            let size = CGSize(
                width: image.size.width * scale,
                height: image.size.height * scale
            )
            attachment.image = image
            attachment.bounds = CGRect(origin: .zero, size: size)
            self.attributedString.append(NSAttributedString(attachment: attachment))
        }
    }
}

extension AttributedInterpotationString {
    public struct Style {
        public let attributes: [NSAttributedString.Key : Any]
        public static func font(_ font: UIFont) -> Style {
            return Style(attributes: [.font : font])
        }
        public static func color(_ color: UIColor) -> Style {
            return Style(attributes: [.foregroundColor : color])
        }
        public static func bgColor(_ color: UIColor) -> Style {
            return Style(attributes: [.backgroundColor : color])
        }
        public static func link(_ link: URL) -> Style {
            return Style(attributes: [.link : link])
        }
        public static func link(_ link: String) -> Style {
            return Style(attributes: [.link : link])
        }
        public static let oblique = Style(attributes: [.obliqueness : 0.1])
        public static func underline(_ color: UIColor, _ style: NSUnderlineStyle) -> Style {
            return Style(attributes: [
                .underlineStyle : style.rawValue,
                .underlineColor : color,
            ])
        }
        public static func alignment(_ alignment: NSTextAlignment) -> Style {
            let ps  = NSMutableParagraphStyle()
            ps.alignment = alignment
            return Style(attributes: [
                .paragraphStyle : ps
            ])
        }
    }
}

extension AttributedInterpotationString.StringInterpolation {
    func appendInterpolation(_ string: String, _ styles: AttributedInterpotationString.Style...) {
        var attrs: [NSAttributedString.Key : Any] = [:]
        styles.forEach { attrs.merge($0.attributes, uniquingKeysWith: { $1 }) }
        let astr = NSAttributedString(string: string, attributes: attrs)
        attributedString.append(astr)
    }
    
    func appendInterpolation(_ string: AttributedInterpotationString, _ styles: AttributedInterpotationString.Style...) {
        var attrs: [NSAttributedString.Key : Any] = [:]
        styles.forEach { attrs.merge($0.attributes, uniquingKeysWith: { $1 }) }
        let mas = NSMutableAttributedString(attributedString: string.attributedString)
        let fullRange = NSRange(mas.string.startIndex..<mas.string.endIndex, in: mas.string)
        mas.addAttributes(attrs, range: fullRange)
        attributedString.append(mas)
    }
}
