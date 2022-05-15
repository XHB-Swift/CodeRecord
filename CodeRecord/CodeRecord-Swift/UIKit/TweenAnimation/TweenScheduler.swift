//
//  TweenScheduler.swift
//  CodeRecord-Swift
//
//  Created by 谢鸿标 on 2022/5/15.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

import UIKit

public protocol TweenSchedulerDelegate: AnyObject {
    
    func scheduler(_ scheduler: TweenScheduler, didUpdateFor duration: TimeInterval)
}

public final class TweenScheduler {
    
    public weak var delegate: TweenSchedulerDelegate?
    
    private var displayLink: CADisplayLink?
    private var lastTimestamp: TimeInterval = 0
    
    deinit {
        self.stopScheduler()
        NotificationCenter.default .removeObserver(self)
    }
    
    public init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidBecomActive(_:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillResignActive(_:)),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }
    
    @objc private func appDidBecomActive(_ sender: NSNotification) {
        self.lastTimestamp = 0
        self.displayLink?.isPaused = false
    }
    
    @objc private func appWillResignActive(_ sender: NSNotification) {
        self.displayLink?.isPaused = true
        self.lastTimestamp = 0
    }
    
    public func startScheduler() {
        if self.displayLink != nil { return }
        
        self.displayLink = CADisplayLink.scheduled(loopInCommonModes: true,
                                                   action: { [weak self] time in
            self?.handleDisplayLinkAction()
        })
        self.lastTimestamp = CFAbsoluteTimeGetCurrent()
    }
    
    public func stopScheduler() {
        if self.displayLink != nil {
            self.displayLink?.invalidate()
            self.displayLink = nil
            self.lastTimestamp = 0
        }
    }
    
    private func handleDisplayLinkAction() {
        let duration = max(CFAbsoluteTimeGetCurrent() - self.lastTimestamp, 0)
        self.delegate?.scheduler(self, didUpdateFor: duration)
    }
    
}
