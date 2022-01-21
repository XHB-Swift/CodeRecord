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
    public static let keyPathSetting = FoundationError(code: -101, description: "关键属性设置失败")
    public static let notFoundBundleName = FoundationError(code: -102, description: "找不到包名")
    public static let needToDebugDetails = FoundationError(code: -1024, description: "此处需要调试")
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

extension Sequence {
    
    public func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return map { $0[keyPath: keyPath] }
    }
}

extension Collection {
    
    public func sorted<Value: Comparable>(on property: KeyPath<Element, Value>,
                                        by areIncreasingOrder: (Value, Value)->Bool) -> [Element] {
        return sorted { value1, value2 in
            areIncreasingOrder(value1[keyPath: property], value2[keyPath: property])
        }
    }
}

extension MutableCollection where Self: RandomAccessCollection {
    
    public mutating func sort<Value: Comparable>(on property: KeyPath<Element, Value>, by order: (Value, Value) throws -> Bool) rethrows {
        
        try sort { try order($0[keyPath: property], $1[keyPath: property]) }
    }
    
}

public protocol KeyPathEditable {
    
    func set<T>(value: T, for property: PartialKeyPath<Self>) throws -> Self
}

extension KeyPathEditable {
    
    func set<T>(value: T, for property: PartialKeyPath<Self>) throws -> Self {
        guard let writableProperty = property as? WritableKeyPath<Self,T> else {
            throw FoundationError.keyPathSetting
        }
        var newSelf = self
        newSelf[keyPath: writableProperty] = value
        return newSelf
    }
}


@propertyWrapper
struct Clamped<T: Comparable> {
    
    let wrappedValue: T
    
    init(wrappedValue: T, _ range: ClosedRange<T>) {
        self.wrappedValue = min(max(wrappedValue, range.lowerBound), range.upperBound)
    }
    
}

extension Dictionary where Key == String {
    
    public struct StringKeyPath {
        
        public var seperator = "."
        public var keyPathString = ""
        private(set) var keys = Array<String>()
        
        public init(keyPath: String, seperator: String = ".") {
            
            self.seperator = seperator
            self.keyPathString = keyPath
            self.keys = keyPath.components(separatedBy: seperator)
        }
        
        public init(keys: [String]) {
            self.keys = keys
        }
        
        public func next() -> (key: String, path: StringKeyPath)? {
            if keys.isEmpty { return nil }
            var nextKeys = keys
            let key = nextKeys.removeFirst()
            return (key: key, path: StringKeyPath(keys: nextKeys))
        }
        
    }
    
    public func value(for keyPath: StringKeyPath) -> Value? {
        
        switch keyPath.next() {
        case nil:
            return nil
        case let (key, path)? where path.keys.isEmpty:
            return self[key]
        case let (key, path)?:
            switch self[key] {
            case let dict as Self:
                return dict.value(for: path)
            default:
                return nil
            }
        }
        
    }
    
    public mutating func set(value: Value?, for keyPath: StringKeyPath) {
        
        switch keyPath.next() {
        case nil:
            return
        case let (key, path)? where path.keys.isEmpty:
            self[key] = value
        case let (key, path)?:
            switch self[key] {
            case var dict as Self:
                dict.set(value: value, for: path)
            default:
                return
            }
        }
    }
    
    subscript(keyPath: String, keyPathSeperator: String = ".") -> Value? {
        
        get { value(for: StringKeyPath(keyPath: keyPath, seperator: keyPathSeperator)) }
        set { set(value: newValue, for: StringKeyPath(keyPath: keyPath, seperator: keyPathSeperator)) }
    }
}

extension Dictionary {
    
    public func filter(with keys: Array<Key>, excepted: Bool = false) -> Self {
        guard !keys.isEmpty else { return self }
        let keysSet = Set(keys)
        return filter { keysSet.contains($0.key) != excepted }
    }
    
    public mutating func concat(dictionary: Self, keysMapping: Dictionary<Key,Key>) {
        
        if keysMapping.isEmpty {
            
            _ = dictionary.map { self[$0] = $1 }
            
        } else {
            
            _ = keysMapping.map { self[$0] = dictionary[$1] }
        }
        
    }
    
}

@available(iOS 13, *)
extension URLSession {
    
    public func download(for request: URLRequest) async throws -> (URL, URLResponse) {
        
        return try await withTaskCancellationHandler(operation: {
            return try await withUnsafeThrowingContinuation({ continuation in
                downloadTask(with: request, completionHandler: { url, response, error in
                    if let _url = url,
                        let _response = response {
                        continuation.resume(returning: (_url, _response))
                    } else if let _error = error {
                        continuation.resume(throwing: _error)
                    } else {
                        continuation.resume(throwing: FoundationError.needToDebugDetails)
                    }
                }).resume()
            })
            
        }, onCancel: {
            
        })
        
    }
    
    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        
        return try await withTaskCancellationHandler(operation: {
            return try await withUnsafeThrowingContinuation({ continuation in
                dataTask(with: request) { data, response, error in
                    
                    if let _data = data,
                        let _response = response {
                        continuation.resume(returning: (_data, _response))
                    } else if let _error = error {
                        continuation.resume(throwing: _error)
                    } else {
                        continuation.resume(throwing: FoundationError.needToDebugDetails)
                    }
                    
                }.resume()
            })
        }, onCancel: {
            
        })
    }
    
}
