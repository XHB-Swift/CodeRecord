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

public protocol ThemeAttribute {}

extension UIFont: ThemeAttribute {}
extension UIImage: ThemeAttribute {}
extension UIColor: ThemeAttribute {}
extension NSAttributedString: ThemeAttribute {}

public protocol ThemeStyle {
    func toAttribute() -> ThemeAttribute?
}

public protocol ThemeSimple: ThemeAttribute, ThemeStyle {}
extension ThemeSimple {
    public func toAttribute() -> ThemeAttribute? { return self }
}

extension Int: ThemeSimple {}
extension CGFloat: ThemeSimple {}
extension UIBarStyle: ThemeSimple {}
extension Dictionary: ThemeSimple {}
extension UIStatusBarStyle: ThemeSimple {}

public final class ColorStyle: ThemeStyle {
    
    public var color: String?
    public var alpha: CGFloat?
    
    public init(color: String, alpha: CGFloat) {
        self.color = color
        self.alpha = alpha
    }
    
    public func toAttribute() -> ThemeAttribute? {
        
        guard let colorStr = color else { return nil }
        return UIColor(hexString: colorStr, alpha: alpha ?? 1)
    }
}

public final class FontStyle: ThemeStyle {
    
    public var fontName: String?
    public var fontSize: CGFloat?
    
    public init(fontName: String, fontSize: CGFloat) {
        self.fontName = fontName
        self.fontSize = fontSize
    }
    
    public func toAttribute() -> ThemeAttribute? {
        guard let name = fontName, let size = fontSize else { return nil }
        return UIFont(name: name, size: size)
    }
}

//如果是网络图片，先下载到本地，再将本地资源路径设置，UIImage属于大内存的资源，不应该大量持有
public final class ImageStyle: ThemeStyle {
    
    public var localPath: String?
    
    public init(localPath: String) {
        self.localPath = localPath
    }
    
    public func toAttribute() -> ThemeAttribute? {
        guard let path = localPath else { return nil }
        return UIImage(contentsOfFile: path)
    }
}

public final class RichTextStyle: ThemeStyle {
    
    public typealias RichTextAttributes = [NSAttributedString.Key : Any]
    public var string: String?
    public var attributes: [NSAttributedString.Key:ThemeStyle]?
    
    public func toAttribute() -> ThemeAttribute? {
        guard let str = string else { return nil }
        var attributes0 = RichTextAttributes()
        attributes?.forEach({ key, value in
            guard let v = value.toAttribute() else { return }
            attributes0[key] = v
        })
        return NSAttributedString(string: str, attributes: attributes0)
    }
}

@objc public protocol ThemeUpdatable {
    
    @objc func theme_effect(for style: String, theme: AnyObject?)
}

open class Theme {
    
    //表示该主题针对view的哪个属性
    open var property: AnyKeyPath
    
    open var style: ThemeStyle
    
    public init(property: AnyKeyPath, style: ThemeStyle) {
        self.property = property
        self.style = style
    }
}

fileprivate class ThemeObject {
    
    fileprivate static let shouldReleaseObject = NSNotification.Name(rawValue: "shouldReleaseObject")
    
    fileprivate var viewId: String
    fileprivate weak var view: ThemeUpdatable?
    fileprivate var themeInfo = Dictionary<String, Theme>()
    
    public init(viewId: String) {
        self.viewId = viewId
    }
    
    fileprivate func update(style: String) {
        guard let theme = themeInfo[style] else { return }
        view?.theme_effect(for: style, theme: theme)
    }
}

fileprivate class ThemeScene {
    
    fileprivate var sceneId: String
    fileprivate var themeObjects = Dictionary<String,ThemeObject>()
    
    public init(sceneId: String) {
        self.sceneId = sceneId
    }
    
    public func update(style: String) {
        themeObjects.forEach { key, value in
            value.update(style: style)
        }
    }
}

open class ThemeManager {
    
    private init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(releaseThemeObject(_:)),
                                               name: ThemeObject.shouldReleaseObject,
                                               object: nil)
    }
    public static let shared = ThemeManager()
    /*
     {
      "scene-1":{
          "view-1" : {
            "style1": {}
         }
       }
     }
    */
    private var themeObjects = Dictionary<String, ThemeObject>()
    
    open func set(theme: Theme, style: String, for view: ThemeUpdatable) {
        
        let viewId = "\(view)"
        if let themeObject = themeObjects[viewId] {
            themeObject.themeInfo[style] = theme
        }else {
            let themeObject = ThemeObject(viewId: viewId)
            themeObject.view = view
            themeObject.themeInfo[style] = theme
            themeObjects[viewId] = themeObject
        }
    }
    
    @objc fileprivate func releaseThemeObject(_ sender: Notification) {
        guard let themeObject = sender.object as? ThemeObject else { return }
        print("releaseThemeObject = \(themeObject.viewId)")
        _ = themeObjects.removeValue(forKey: themeObject.viewId)
    }
    
    open func clean(for view: ThemeUpdatable) {
        clean(for: [view])
    }
    
    open func clean(for views: [ThemeUpdatable]) {
        views.forEach { view in
            let viewId = "\(view)"
            _ = themeObjects.removeValue(forKey: viewId)
        }
    }
    
    open func cleanAll() {
        themeObjects.removeAll()
    }
    
    open func switchTo(style: String) {
        themeObjects.forEach { key, value in
            value.update(style: style)
        }
    }
}

extension String {
    
    fileprivate static let backgroundColor = "backgroundColor"
    fileprivate static let textColor = "textColor"
    fileprivate static let font = "font"
}

extension UIBarItem: ThemeUpdatable {
    
    open func theme_set(image: ImageStyle, for style: String) {
        let theme = Theme(property: \UIBarItem.image, style: image)
        ThemeManager.shared.set(theme: theme, style: style, for: self)
    }
    
    @objc open func theme_effect(for style: String, theme: AnyObject?) {
        guard let theme0 = theme as? Theme else { return }
        if let imageProperty = theme0.property as? ReferenceWritableKeyPath<UIBarItem, UIImage?> {
            self[keyPath: imageProperty] = (theme0.style as? ImageStyle)?.toAttribute() as? UIImage
        }
    }
}

extension UINavigationBar {
    
    open func theme_set(barStyle: UIBarStyle, for style: String) {
        let theme = Theme(property: \UINavigationBar.barStyle, style: barStyle)
        ThemeManager.shared.set(theme: theme, style: style, for: self)
    }
    
    open func theme_set(barTintColor: ColorStyle, for style: String) {
        let theme = Theme(property: \UINavigationBar.barTintColor, style: barTintColor)
        ThemeManager.shared.set(theme: theme, style: style, for: self)
    }
    
    open func theme_set(titleAttributes: RichTextStyle.RichTextAttributes, for style: String) {
        let theme = Theme(property: \UINavigationBar.titleTextAttributes, style: titleAttributes)
        ThemeManager.shared.set(theme: theme, style: style, for: self)
    }
    
    open func theme_set(largeTitleAttributes: RichTextStyle.RichTextAttributes, for style: String) {
        let theme = Theme(property: \UINavigationBar.largeTitleTextAttributes, style: largeTitleAttributes)
        ThemeManager.shared.set(theme: theme, style: style, for: self)
    }
    
    @objc open override func theme_effect(for style: String, theme: AnyObject?) {
        super.theme_effect(for: style, theme: theme)
    }
}

extension UIView: ThemeUpdatable {
    
    open func theme_set(backgroundColor: ColorStyle, for style: String) {
        let theme = Theme(property: \UIView.backgroundColor, style:backgroundColor)
        ThemeManager.shared.set(theme: theme, style: style, for: self)
    }
    
    open func theme_clean(includingSubviews: Bool = true) {
        let manager = ThemeManager.shared
        manager.clean(for: self)
        subviews.forEach { subview in
            manager.clean(for: subview)
        }
    }
    
    @objc open func theme_effect(for style: String, theme: AnyObject?) {
        guard let theme0 = theme as? Theme else { return }
        if let colorProperty = theme0.property as? ReferenceWritableKeyPath<UIView, UIColor?> {
            self[keyPath: colorProperty] = (theme0.style as? ColorStyle)?.toAttribute() as? UIColor
        }
    }
}

extension UILabel {

    open func theme_set(textColor: ColorStyle, for style: String) {
        let theme = Theme(property: \UILabel.textColor, style: textColor)
        ThemeManager.shared.set(theme: theme, style: style, for: self)
    }
    
    open func theme_set(shadowColor: ColorStyle, for style: String) {
        let theme = Theme(property: \UILabel.shadowColor, style: shadowColor)
        ThemeManager.shared.set(theme: theme, style: style, for: self)
    }
    
    open func theme_set(font: FontStyle, for style: String) {
        let theme = Theme(property: \UILabel.font, style: font)
        ThemeManager.shared.set(theme: theme, style: style, for: self)
    }
    
    open func theme_set(attributedText: RichTextStyle, for style: String) {
        let theme = Theme(property: \UILabel.font, style: attributedText)
        ThemeManager.shared.set(theme: theme, style: style, for: self)
    }
    
    open func theme_set(highlightedTextColor: ColorStyle, for style: String) {
        let theme = Theme(property: \UILabel.highlightedTextColor, style: highlightedTextColor)
        ThemeManager.shared.set(theme: theme, style: style, for: self)
    }
    
    open override func theme_effect(for style: String, theme: AnyObject?) {
        super.theme_effect(for: style, theme: theme)
        guard let theme0 = theme as? Theme else { return }
        if let colorProperty = theme0.property as? ReferenceWritableKeyPath<UILabel, UIColor?> {
            self[keyPath: colorProperty] = (theme0.style as? ColorStyle)?.toAttribute() as? UIColor
        }
        if let fontProperty = theme0.property as? ReferenceWritableKeyPath<UILabel, UIFont?> {
            self[keyPath: fontProperty] = (theme0.style as? FontStyle)?.toAttribute() as? UIFont
        }
    }
}
