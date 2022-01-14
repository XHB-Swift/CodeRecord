//
//  ContentBrowserDemoViewController.swift
//  CodeRecord-Swift
//
//  Created by xiehongbiao on 2021/9/6.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

import UIKit

open class ContentBrowserImageData: ContentBrowserPageData {
    
    open var content: URLType
    open var shouldCleanContent: Bool = true
    
    public init(content: URLType, shouldCleanContent: Bool = true) {
        self.content = content
        self.shouldCleanContent = shouldCleanContent
    }
}

class ContentBrowserDemoViewController: UIViewController {
    
    var contentBrowserViewModel = ContentBrowserImageViewModel<ContentBrowserImageData>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let button = UIButton(title: "弹出图片浏览", state: .normal)
        button.addTarget(self, action: #selector(tapShowBrowser(_:)), for: .touchUpInside)
        button.origin = CGPoint(x: 50, y: 100)
        view.addSubview(button)
    }
    
    @objc func tapShowBrowser(_ sender: UIButton) {
        let cbview = ContentBrowserView<ContentBrowserImageData>(frame: CGRect(x: 0, y: view.height, width: view.width, height: view.height))
        cbview.delegate = self
        cbview.collectionView?.flowlayout?.scrollDirection = .horizontal
        cbview.viewModel = contentBrowserViewModel
        contentBrowserViewModel.append([
                                        ContentBrowserImageData(content: imageUrl1),
                                        ContentBrowserImageData(content: imageUrl2),
                                        ContentBrowserImageData(content: imageUrl3),
                                        ContentBrowserImageData(content: imageUrl4),
                                        ContentBrowserImageData(content: imageUrl5)
        ])
        contentBrowserViewModel.shouldInfinitelyCarousel = true
        cbview.scroll(to: 2)
        
        UIWindow.currentWindow?.addSubview(cbview)
        
        UIView.animate(withDuration: 0.5) {
            cbview.y = 0
        }
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        contentBrowserView?.y = 100
//    }
}

extension ContentBrowserDemoViewController: ContentBrowserViewDelegate {
    
    func didClickEmptyArea<ContentBrowserImageData>(in view: ContentBrowserView<ContentBrowserImageData>) {
        UIView.animate(withDuration: 0.5) {
            view.y = view.superview?.height ?? 0
        } completion: { finished in
            view.removeFromSuperview()
        }
    }
}
