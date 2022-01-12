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

struct MainEntranceModel {
    var title: String
    var vcName: String
}

class MainEntranceViewModel: NSObject, UITableViewDataSource {
    
    weak var tableView: UITableView? {
        didSet {
            tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "MainEntranceTableErrorCell")
            tableView?.register(MainEntranceTableCell.self, forCellReuseIdentifier: MainEntranceTableCell.cellIdentifier)
        }
    }
    private var mainEntrances = Array<MainEntranceModel>()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainEntrances.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let count = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
        if let cell = tableView.dequeueReusableCell(withIdentifier: MainEntranceTableCell.cellIdentifier, for: indexPath) as? MainEntranceTableCell,
           index < count {
            cell.update(title: mainEntrances[index].title)
            return cell
        }else {
            return tableView.dequeueReusableCell(withIdentifier: "MainEntranceTableErrorCell", for: indexPath)
        }
    }
    
    func append(_ entrance: MainEntranceModel) {
        mainEntrances.append(entrance)
        tableView?.reloadData()
    }
    
    func appendEntrance(with title: String, vcName: String) {
        mainEntrances.append(MainEntranceModel(title: title, vcName: vcName))
        tableView?.reloadData()
    }
    
    func append(_ entrances: [MainEntranceModel]) {
        if entrances.isEmpty { return }
        mainEntrances.append(contentsOf: entrances)
        tableView?.reloadData()
    }
    
    func entranceVCName(at index: Int) -> String? {
        return mainEntrances[index].vcName.objectClassName
    }
}

class MainEntranceViewController: UIViewController {
    
    var tableView: UITableView?
    var mainEntranceViewModel = MainEntranceViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupSubviews()
        setupEntrances()
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
    
    func setupEntrances() {
        mainEntranceViewModel.append([
            MainEntranceModel(title: "自定义模态转场", vcName: "CustomTransitionDemoViewController"),
            MainEntranceModel(title: "缓存网络图片", vcName: "ImageWebCacheDemoViewController"),
            MainEntranceModel(title: "CollectionView轮播", vcName: "ContentBrowserDemoViewController"),
            MainEntranceModel(title: "主题切换", vcName: "ThemeSwitchDemoViewController"),
            MainEntranceModel(title: "富文本插值初始化", vcName: "InterpotaionStringDemoViewController")
        ])
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}


extension MainEntranceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vcName = mainEntranceViewModel.entranceVCName(at: indexPath.row),
              let vcClass = NSClassFromString(vcName),
              let vcType = vcClass as? UIViewController.Type
        else { return }
        let targetVC = vcType.init()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
}

