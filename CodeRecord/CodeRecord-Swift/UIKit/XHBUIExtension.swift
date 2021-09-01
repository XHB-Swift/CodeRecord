//
//  XHBUIExtension.swift
//  CodeRecord-Swift
//
//  Created by 谢鸿标 on 2021/8/26.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

import UIKit


extension UIView {
    
    var x: CGFloat {
        
        set {
            self.frame.origin.x = newValue
        }
        
        get {
            return self.frame.minX
        }
    }
    
    var y: CGFloat {
        
        set {
            self.frame.origin.y = newValue
        }
        
        get {
            return self.frame.minY
        }
        
    }
    
    var midX: CGFloat {
        
        set {
            self.frame.origin.x = newValue - self.frame.width / 2
        }
        
        get {
            return self.frame.midX
        }
    }
    
    var midY: CGFloat {
        
        set {
            self.frame.origin.y = newValue - self.frame.height / 2
        }
        
        get {
            return self.frame.midY
        }
    }
    
    var right: CGFloat {
        
        set {
            self.frame.origin.x = newValue - self.frame.width
        }
        
        get {
            return self.frame.maxX
        }
    }
    
    var bottom: CGFloat {
        
        set {
            self.frame.origin.y = newValue - self.frame.height
        }
        
        get {
            return self.frame.maxY
        }
    }
    
    var width: CGFloat {
        
        set {
            self.frame.size.width = newValue
        }
        
        get {
            return self.frame.width
        }
    }
    
    var height: CGFloat {
        
        set {
            self.frame.size.height = newValue
        }
        
        get {
            return self.frame.height
        }
    }
    
    var origin: CGPoint {
        
        set {
            self.frame.origin = newValue
        }
        
        get {
            return self.frame.origin
        }
    }
    
    var size: CGSize {
        
        set {
            self.frame.size = newValue
        }
        
        get {
            return self.frame.size
        }
    }
    
    var centerX: CGFloat {
        
        set {
            self.center.x = newValue
        }
        
        get {
            return self.center.x
        }
    }
    
    var centerY: CGFloat {
        
        set {
            self.center.y = newValue
        }
        
        get {
            return self.center.y
        }
    }
}

extension UIColor {
    
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let alpha = (0...1.0).contains(a) ? a : 1.0
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
    
    public convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var fixedHexStr = hexString
        if hexString.hasPrefix("#") {
            guard let fixedHex = hexString[(1..<hexString.count-1)] else { return nil }
            if fixedHex.count != 6 && fixedHex.count != 8 {
                return nil
            }
            fixedHexStr = fixedHex
        }
        
        do {
            let regex = try NSRegularExpression(pattern: "[^a-fA-F|0-9]", options: [])
            let match = regex.numberOfMatches(in: fixedHexStr, options: [.reportCompletion], range: NSRange(location: 0, length: fixedHexStr.count))
            if match != 0 {
                return nil
            }
            self.init(argbHexString: fixedHexStr)
        } catch {
            return nil
        }
    }
    
    public convenience init?(argbHexString: String) {
        var argbHex = argbHexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if argbHex.hasPrefix("#") {
            guard let fixedHex = argbHex[(1..<argbHex.count-1)] else { return nil }
            if fixedHex.count != 6 && fixedHex.count != 8 {
                return nil
            }
            argbHex = fixedHex
        }
        
        if argbHex.count == 8 {
            let a = CGFloat(argbHex[(0..<2)]?.hexStringToInt ?? 0) / 255.0
            let r = CGFloat(argbHex[(2..<4)]?.hexStringToInt ?? 0) / 255.0
            let g = CGFloat(argbHex[(4..<6)]?.hexStringToInt ?? 0) / 255.0
            let b = CGFloat(argbHex[(6..<8)]?.hexStringToInt ?? 0) / 255.0
            self.init(red: r, green: g, blue: b, alpha: a)
        }else if argbHex.count == 6 {
            let r = CGFloat(argbHex[(0..<2)]?.hexStringToInt ?? 0) / 255.0
            let g = CGFloat(argbHex[(2..<4)]?.hexStringToInt ?? 0) / 255.0
            let b = CGFloat(argbHex[(4..<6)]?.hexStringToInt ?? 0) / 255.0
            self.init(red: r, green: g, blue: b, alpha: 1.0)
        }else {
            return nil
        }
    }
    
    open class var randomColor: UIColor? {
        let hexColorStrs = ["D4EABD",
                            "EAE2BD",
                            "B5ABAE",
                            "D8CAE0",
                            "BAC5BA",
                            "D6EDF1",
                            "EABDD1",
                            "B1B4BB",
                            "EAC7BD",
                            "BDD8EA",
                            "B8B394"]
        
        let randomIdx = Int(arc4random() % UInt32(hexColorStrs.count))
        let hexColorStr = hexColorStrs[randomIdx]
        return UIColor(hexString: hexColorStr)
    }
    
}
