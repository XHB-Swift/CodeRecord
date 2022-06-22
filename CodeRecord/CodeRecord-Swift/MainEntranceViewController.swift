//
//  MainEntranceViewController.swift
//  CodeRecord-Swift
//
//  Created by xiehongbiao on 2021/9/2.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

import UIKit

class MainEntranceTableCell: UITableViewCell {
    
    class var cellIdentifier: String {
        return NSStringFromClass(self)
    }
    
    private var textLayer: CATextLayer?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        textLayer = CATextLayer()
        textLayer?.contentsScale = UIScreen.main.scale
        textLayer?.font = CTFontCreateWithName(("PingFang-SC-Medium") as CFString, 0, nil)
        textLayer?.fontSize = 18
        textLayer?.alignmentMode = .left
        textLayer?.foregroundColor = UIColor(white: 0, alpha: 1).cgColor
        if let txtLayer = textLayer {
            contentView.layer.addSublayer(txtLayer)
        }
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        let x: CGFloat = 10,
            y: CGFloat = 10
        textLayer?.frame.origin = CGPoint(x: x, y: y)
        textLayer?.frame.size = CGSize(width: self.width * 2/3 - x, height: self.height - 2 * y)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLayer?.string = nil
        textLayer?.frame.size = .zero
    }
    
    func update(title: String) {
        textLayer?.string = title as CFString
    }
}

class MainEntranceViewModel: NSObject, UITableViewDataSource {
    
    weak var tableView: UITableView? {
        didSet {
            tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "MainEntranceTableErrorCell")
            tableView?.register(MainEntranceTableCell.self, forCellReuseIdentifier: MainEntranceTableCell.cellIdentifier)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainEntranceManager.entranceCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let count = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
        if let cell = tableView.dequeueReusableCell(withIdentifier: MainEntranceTableCell.cellIdentifier, for: indexPath) as? MainEntranceTableCell,
           index < count {
            cell.update(title: MainEntranceManager.entranceTitle(at: index))
            return cell
        }else {
            return tableView.dequeueReusableCell(withIdentifier: "MainEntranceTableErrorCell", for: indexPath)
        }
    }
}

class MainEntranceViewController: UIViewController {
    
    var tableView: UITableView?
    var mainEntranceViewModel = MainEntranceViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupSubviews()
        registerAllEntrances()
        tableView?.reloadData()
    }
    
    func setupSubviews() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView?.rowHeight = 60
        tableView?.delegate = self
        tableView?.dataSource = mainEntranceViewModel
        tableView?.tableFooterView = UIView()
        guard let table = tableView else { return }
        view.addSubview(table)
        mainEntranceViewModel.tableView = tableView
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}


extension MainEntranceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = MainEntranceManager.viewController(at: indexPath.row) else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainEntranceViewController {
    
    public func registerAllEntrances() {
        MainEntranceManager.register(entrance: "自定义模态转场", viewControllerClassName: "CustomTransitionDemoViewController")
        MainEntranceManager.register(entrance: "缓存网络图片", viewControllerClassName: "ImageWebCacheDemoViewController")
        MainEntranceManager.register(entrance: "CollectionView轮播", viewControllerClassName: "ContentBrowserDemoViewController")
        MainEntranceManager.register(entrance: "主题切换", viewControllerClassName: "ThemeSwitchDemoViewController")
        MainEntranceManager.register(entrance: "富文本插值初始化", viewControllerClassName: "InterpotaionStringDemoViewController")
        MainEntranceManager.register(entrance: "渐变进度条", viewControllerClassName: "GradientProgressViewController")
        MainEntranceManager.register(entrance: "状态机", viewControllerClassName: "StateMachineViewController")
        MainEntranceManager.register(entrance: "自定义气泡", viewControllerClassName: "CustomBubbleTipsViewController")
        MainEntranceManager.register(entrance: "自定义CollectionView", viewControllerClassName: "CustomCollectionViewController")
    }
    
}
