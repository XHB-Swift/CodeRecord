//
//  MainEntranceManager.swift
//  CodeRecord-Swift
//
//  Created by 谢鸿标 on 2022/6/16.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

import UIKit

private struct MainEntranceModel {
    var title: String
    var vcName: String
}

public final class MainEntranceManager {
    
    public static let shared = MainEntranceManager()
    
    public class var entranceCount: Int {
        return shared.entrances.count
    }
    
    private var entrances = Array<MainEntranceModel>()
    
    private init() {}
    
    public class func register(entrance title: String, viewControllerClassName: String) {
        let newEntrance = MainEntranceModel(title: title, vcName: viewControllerClassName)
        shared.entrances.append(newEntrance)
    }
    
    public class func entranceTitle(at index: Int) -> String {
        return shared.entrances[index].title
    }
    
    public class func viewController(at index: Int) -> UIViewController? {
        let vcName = shared.entrances[index].vcName
        guard let objClassName = vcName.objectClassName,
              let vcClass = NSClassFromString(objClassName),
              let vcType = vcClass as? UIViewController.Type
        else { return nil }
        let targetVC = vcType.init()
        return targetVC
    }
}
