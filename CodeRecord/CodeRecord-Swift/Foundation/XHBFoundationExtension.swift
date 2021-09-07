//
//  XHBFoundationExtension.swift
//  CodeRecord-Swift
//
//  Created by 谢鸿标 on 2021/8/26.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

import Foundation
import CryptoKit
import CommonCrypto

public struct FoundationError: Error {
    
    let code: Int
    let description: String
}

extension FoundationError {
    
    public static let nilValue    = FoundationError(code: -98, description: "nil值")
    public static let emptyString = FoundationError(code: -99, description: "空字符串")
    public static let notFoundDir = FoundationError(code: -100, description: "找不到文件夹")
    public static let notFoundBundleName = FoundationError(code: -101, description: "找不到包名")
    public static let needToDebugDetails = FoundationError(code: -1024, description: "Need to Debug here")
}

extension String {
    
    public var hexStringToInt: Int {
        return Int(self, radix: 16) ?? 0
    }
    
    subscript(i: Int) -> Self? {
        if i >= count {
            return nil
        }
        if i == 0 {
            return String(self[startIndex])
        }
        if i == count - 1 {
            return String(self[endIndex])
        }
        
        let targetIndex = index(startIndex, offsetBy: i)
        return String(self[targetIndex])
    }
    
    subscript(r: Range<Int>) -> Self? {
        if r.lowerBound < 0 {
            return nil
        }
        if r.lowerBound >= count {
            return nil
        }
        if r.upperBound > count {
            return nil
        }
        let index0 = index(startIndex, offsetBy: r.lowerBound)
        let index1 = index(startIndex, offsetBy: r.upperBound)
        return String(self[index0..<index1])
    }
    
    subscript(r: NSRange) -> Self? {
        guard let rr = Range(r) else { return nil }
        return self[rr]
    }
    
    public var objectClassName: String? {
        
        guard let space = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else { return nil }
        return "\(space.replacingOccurrences(of: "-", with: "_")).\(self)"
    }
    
    public var md5String: String {
        if isEmpty { return self }
        if #available(iOS 13.0, *) {
            guard let d = self.data(using: .utf8) else { return "" }
            return Insecure.MD5.hash(data: d).map {
                String(format: "%02hhx", $0)
            }.joined()
        }else {
            let data = Data(utf8)
            let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
                var array = Array<UInt8>(repeating: 0, count: Int(CC_MD5_BLOCK_BYTES))
                CC_MD5(bytes.baseAddress, CC_LONG(data.count), &array)
                return array
            }
            return hash.map { String(format: "%02x", $0) }.joined()
        }
    }
    
}

extension Double {
    
    public static let pi_2 = pi / 2
    public static let pi_3 = pi / 3
    public static let pi_4 = pi / 4
    public static let pi_6 = pi / 6
    public static let m_2_pi = pi * 2
}

extension Timer {
    
    public typealias TimerUpdateAction = (TimeInterval)->Void
    
    public class func scheduled(interval: TimeInterval,
                                loopInCommonModes: Bool,
                                repeats: Bool,
                                action: @escaping TimerUpdateAction) -> Timer {
        
        let timer = Timer.scheduledTimer(timeInterval: interval,
                                         target: self,
                                         selector: #selector(timerAction(_:)),
                                         userInfo: action,
                                         repeats: repeats)
        
        if loopInCommonModes {
            RunLoop.current.add(timer, forMode: .common)
        }
        
        return timer
    }
    
    @objc private class func timerAction(_ sender: Timer) {
        guard let action = sender.userInfo as? TimerUpdateAction else { return }
        action(sender.timeInterval)
    }
}
