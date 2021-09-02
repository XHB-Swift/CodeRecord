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
        textLayer?.font = CTFontCreateWithName(("PingFang-SC-Medium") as CFString, 18, nil)
        textLayer?.fontSize = 18
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
    
    weak var tableView: UITableView?
    private var mainEntrances = Array<String>()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainEntrances.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let count = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
        if index < count {
            return tableView.dequeueReusableCell(withIdentifier: MainEntranceTableCell.cellIdentifier, for: indexPath)
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
    }
    
    func setupSubviews() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView?.rowHeight = 60
        tableView?.delegate = self
        tableView?.dataSource = mainEntranceViewModel
        tableView?.tableFooterView = UIView()
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "MainEntranceTableErrorCell")
        tableView?.register(MainEntranceTableCell.self, forCellReuseIdentifier: MainEntranceTableCell.cellIdentifier)
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
        
    }
}

