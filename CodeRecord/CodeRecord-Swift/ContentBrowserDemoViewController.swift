//
//  ContentBrowserDemoViewController.swift
//  CodeRecord-Swift
//
//  Created by xiehongbiao on 2021/9/6.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

import UIKit

class ContentBrowserDemoViewController: UIViewController {
    
    var contentBrowserView: ContentBrowserView<String>?
    var contentBrowserViewModel = ContentBrowserImageViewModel<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let cbview = ContentBrowserView<String>(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width))
        cbview.viewModel = contentBrowserViewModel
        view.addSubview(cbview)
        contentBrowserView = cbview
        contentBrowserViewModel.append([imageUrl1,imageUrl2,imageUrl3])
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        contentBrowserView?.y = 100
    }
}
