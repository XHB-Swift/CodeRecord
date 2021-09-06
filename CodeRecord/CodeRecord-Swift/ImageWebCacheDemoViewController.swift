//
//  ImageWebCacheDemoViewController.swift
//  CodeRecord-Swift
//
//  Created by xiehongbiao on 2021/9/6.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

import UIKit

let imageUrl1 = "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20161205%2F6da202d5a03e45129b981658fc33c210_th.jpeg&refer=http%3A%2F%2Fimg.mp.itc.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1633503003&t=23ad55080640882ef56dd62e2e4a964b"
let imageUrl2 = "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fztd00.photos.bdimg.com%2Fztd%2Fw%3D700%3Bq%3D50%2Fsign%3Dfe9d19a4037b02080cc93de152e283ee%2Fbd315c6034a85edf1d2acf2240540923dd547508.jpg&refer=http%3A%2F%2Fztd00.photos.bdimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1633513057&t=8b2909c38fdd9824c7ffbf24899d6f70"
let imageUrl3 = "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fzkres2.myzaker.com%2F201905%2F5ccbb8b477ac6469a41cf263_1024.jpg&refer=http%3A%2F%2Fzkres2.myzaker.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1633513085&t=30f17a4b5d266ad3e010c7449de4e3f2"

class ImageWebCacheDemoViewController: UIViewController {
    
    var imgs = [imageUrl1,imageUrl2,imageUrl3]
    var imgView: UIImageView?
    var imgTable: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.setImage(with: imageUrl1, thumbnail: UIImageView.ThumbnailConfig(pointSize: imageView.size, scale: 1))
        imgView = imageView
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 300, height: 300), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TitleCell")
        tableView.tableFooterView = UIView(frame: .zero)
        view.addSubview(tableView)
        imgTable = tableView
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        imgView?.y = 100
        imgView?.centerX = view.width / 2
        imgTable?.y = imgView?.bottom ?? 0
        imgTable?.centerX = imgView?.centerX ?? 0
    }
}

extension ImageWebCacheDemoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        imgView?.setImage(with: imgs[indexPath.row], thumbnail: UIImageView.ThumbnailConfig(pointSize: imgView?.size ?? .zero, scale: 1))
    }
}

extension ImageWebCacheDemoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = "\(indexPath.row + 1)"
        return cell
    }
}
