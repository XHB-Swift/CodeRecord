//
//  XHBFoundationExtension.swift
//  CodeRecord-Swift
//
//  Created by 谢鸿标 on 2021/8/26.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

import Foundation



extension String {
    
    public var hexStringToInt: Int {
        
        let result = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        _ = withVaList([result]) { pointer in
            vsscanf(self, "%X", pointer)
        }
        
        return Int(result.pointee)
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
    
}
