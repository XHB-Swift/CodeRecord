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
let imageUrl4 = "https://pic.rmb.bdstatic.com/bd2f0ede6689a44d6585ffcfc195fd2e.jpeg@wm_2,t_55m+5a625Y+3L+WQrOWwj+Wuh+ivnQ==,fc_ffffff,ff_U2ltSGVp,sz_24,x_15,y_15"
let imageUrl5 = "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201702%2F12%2F20170212172519_jwZYe.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1633595557&t=4a13ce3e78950bca019b096743f40d33"

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
        imgView = imageView
        imgView?.setImage(with: imageUrl1, thumbnail: ThumbnailConfig(pointSize: imageView.size, scale: .auto))
        
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
        let url = imgs[indexPath.row]
        let thumbnail = ThumbnailConfig(pointSize: imgView?.size ?? .zero, scale: .auto)
        imgView?.setImage(with: url, thumbnail: thumbnail)
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
