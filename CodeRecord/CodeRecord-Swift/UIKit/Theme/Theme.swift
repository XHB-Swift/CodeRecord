//
//  Theme.swift
//  CodeRecord-Swift
//
//  Created by xiehongbiao on 2021/9/8.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

import UIKit

extension String {
    
    public static let dark = "dark"
    public static let light = "light"
}

public protocol ThemeAttribute {
    
    associatedtype Attribute
    
    func toAttribute() -> Attribute?
}

public protocol ThemeUpdatable: AnyObject {
    
    func update<K: ThemeUpdatable, S: ThemeAttribute>(style: S, for property: PartialKeyPath<K>)
}

public struct Color: ThemeAttribute {
    
    public typealias Attribute = UIColor
    
    public var color: String?
    public var alpha: CGFloat?
    
    public func toAttribute() -> UIColor? {
        guard let colorStr = color else { return nil }
        return UIColor(hexString: colorStr, alpha: alpha ?? 1)
    }
}

public struct Font: ThemeAttribute {
    
    public typealias Attribute = UIFont
    
    public var fontName: String?
    public var fontSize: CGFloat?
    
    public func toAttribute() -> UIFont? {
        guard let name = fontName, let size = fontSize else { return nil }
        return UIFont(name: name, size: size)
    }
}

open class Theme<K: ThemeUpdatable, S: ThemeAttribute> {
    
    //表示该主题针对view的哪个属性
    open var property: PartialKeyPath<K>
    
    open var style: S
    
    public init(property: PartialKeyPath<K>, style: S) {
        self.property = property
        self.style = style
    }
}

fileprivate class ThemeObject<K: ThemeUpdatable, S: ThemeAttribute> {
    
    public weak var view: ThemeUpdatable?
    fileprivate var themeInfo = Dictionary<String, Theme<K, S>>()
}

open class ThemeManager {
    
    private init() {}
    public static let shared = ThemeManager()
    private var themeObjects = Dictionary<String, Any>()
    
    open func set<K: ThemeUpdatable, S: ThemeAttribute>(theme: Theme<K, S>, style: String, for view: ThemeUpdatable?) {
        guard let v = view else { return }
        
        let viewId = "\(v)"
        if let themeObject = themeObjects[viewId] as? ThemeObject<K,S> {
            themeObject.themeInfo[style] = theme
        }else {
            let themeObject = ThemeObject<K,S>()
            themeObject.themeInfo[style] = theme
            themeObjects[viewId] = themeObject
        }
    }
    
    open func switchTo(theme style: String) {
        _ = themeObjects.map { key, value in
            if let color = value as? ThemeObject<UIView, Color>,
               let view = color.view,
               let theme = color.themeInfo["\(view)"] {
                view.update(style: theme.style, for: theme.property)
            }
        }
    }
}

extension String {
    
    fileprivate static let backgroundColor = "backgroundColor"
    fileprivate static let textColor = "textColor"
    fileprivate static let font = "font"
}

extension UIView: ThemeUpdatable {
    
    open func theme_set(backgroundColor: String, for style: String) {
        let color = Color(color: backgroundColor, alpha: 1)
        let theme = Theme(property: \UIView.backgroundColor, style:color)
        ThemeManager.shared.set(theme: theme, style: style, for: self)
    }
    
    public func update<K: ThemeUpdatable, S: ThemeAttribute>(style: S, for property: PartialKeyPath<K>) {
        guard let writableKeyPath = property as? ReferenceWritableKeyPath<UIView, S> else { return }
        if let colorKeyPath = writableKeyPath as? ReferenceWritableKeyPath<UIView, UIColor?> {
            self[keyPath: colorKeyPath] = style.toAttribute() as? UIColor
        }
        if let fontKeyPath = writableKeyPath as? ReferenceWritableKeyPath<UIView, UIFont?> {
            self[keyPath: fontKeyPath] = style.toAttribute() as? UIFont
        }
    }
}

extension UILabel {

    open func theme_set(textColor: String, for style: String) {
        let color = Color(color: textColor, alpha: 1)
        let theme = Theme(property: \UILabel.textColor, style: color)
        ThemeManager.shared.set(theme: theme, style: style, for: self)
    }
    
    open func theme_set(font: UIFont, for style: String) {
        let font1 = Font(fontName: font.fontName, fontSize: font.pointSize)
        let theme = Theme(property: \UILabel.font, style: font1)
        ThemeManager.shared.set(theme: theme, style: style, for: self)
    }
}
