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

open class Theme {
    
    //表示该主题针对view的哪个属性
    open var property: String
    
    open var color: String?
    open var colorAlpha: CGFloat?
    
    open var image: String?
    
    open var fontName: String?
    open var fontSize: CGFloat?
    
    public init(property: String) {
        self.property = property
    }
    
    open var toRealColor: UIColor? {
        guard let colorStr = color else { return nil }
        return UIColor(hexString: colorStr, alpha: colorAlpha ?? 1)
    }
    
    open var toFont: UIFont? {
        guard let name = fontName, let size = fontSize else { return nil }
        return UIFont(name: name, size: size)
    }
}

public protocol ThemeUpdatable: AnyObject {
    
    func update(theme: Theme)
}

fileprivate class ThemeObject {
    
    public weak var view: ThemeUpdatable?
    fileprivate var themeInfo = Dictionary<String, Theme>()
}

open class ThemeManager {
    
    private init() {}
    public static let shared = ThemeManager()
    private var themeObjects = Dictionary<String, ThemeObject>()
    
    open func set(theme: Theme, style: String, for view: ThemeUpdatable?) {
        guard let v = view else { return }
        
        let viewId = "\(v)"
        if let themeObject = themeObjects[viewId] {
            themeObject.themeInfo[style] = theme
        }else {
            let themeObject = ThemeObject()
            themeObject.themeInfo[style] = theme
            themeObjects[viewId] = themeObject
        }
    }
    
    open func switchTo(theme style: String) {
        _ = themeObjects.map { key, value in
            guard let theme = value.themeInfo[style] else { return }
            value.view?.update(theme: theme)
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
        let theme = Theme(property: .backgroundColor)
        theme.color = backgroundColor
        ThemeManager.shared.set(theme: theme, style: style, for: self)
    }
    
    public func update(theme: Theme) {
        backgroundColor = theme.toRealColor
    }
}
