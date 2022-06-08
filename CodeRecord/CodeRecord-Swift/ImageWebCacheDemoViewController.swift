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

private let UnsplashApiImageUrl = "https://api.unsplash.com/photos/?client_id=p5CvNX85stB0M0lc7GcSErdFxg0I3KdJu6Y8bOhf1ro"

fileprivate struct UnsplashApi {
    
    private let mainUrl = "https://api.unsplash.com/photos/"
    private let clientId = "p5CvNX85stB0M0lc7GcSErdFxg0I3KdJu6Y8bOhf1ro"
    
    public let api: String
    public init(api: String) {
        self.api = mainUrl.appending(path: "\(api)/?client_id=\(clientId)")
    }
    public var url: URL? {
        if params.isNotEmpty {
            var url = api
            params.forEach { (key, value) in
                let valueString = "\(value)".urlEncoded
                url.append("&\(key.urlEncoded)=\(valueString)")
            }
            return URL(string: url)
        }
        return URL(string: api)
    }
    public var params: [String:Any] = [:]
}

extension UnsplashApi {
    public static let random = UnsplashApi(api: "random")
}

fileprivate struct UnsplashImageUrl: Codable {
    
    @Default.EmptyString public var raw: String
    @Default.EmptyString public var full: String
    @Default.EmptyString public var regular: String
    @Default.EmptyString public var small: String
    @Default.EmptyString public var thumb: String
    
    public init(raw: String = "",
                full: String = "",
                regular: String = "",
                small: String = "",
                thumb: String = "") {
        self.raw = raw
        self.full = full
        self.regular = regular
        self.small = small
        self.thumb = thumb
    }
}

extension UnsplashImageUrl {
    public enum Empty: DefaultValue {
        public typealias Value = UnsplashImageUrl
        public static var defaultValue = UnsplashImageUrl()
    }
}

fileprivate struct UnsplashImage: Codable {
    
    @Default<CGFloat.Zero> public var width: CGFloat
    @Default<CGFloat.Zero> public var height: CGFloat
    @Default<UnsplashImageUrl.Empty> public var urls: UnsplashImageUrl
}

class ImageWebCacheDemoViewController: UIViewController {
    
    var imgView: UIImageView?
    var imgTable: UITableView?
    private var randomImageCount = 1
    private var images: Array<UnsplashImage>? {
        didSet {
            updateImages()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.width, height: 300))
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imgView = imageView
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 300, height: 300), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TitleCell")
        tableView.tableFooterView = UIView(frame: .zero)
        view.addSubview(tableView)
        imgTable = tableView
        let randomCount = Int(arc4random() % 30)
        randomImageCount = (randomCount == 0) ? 1 : randomCount
        requestRandomImage()
    }
    
    private func manuallyLayout() {
        imgView?.y = 80
        imgView?.centerX = view.width / 2
        imgTable?.y = imgView?.bottom ?? 0
        imgTable?.centerX = imgView?.centerX ?? 0
    }
    
    private func updateImages() {
        DispatchQueue.main.async {
            self.imgTable?.reloadData()
            guard let image = self.images?.first else { return }
            let scale = image.width / image.height
            self.imgView?.height = (self.imgView?.width ?? 0) / scale
            self.imgView?.setImage(with: image.urls.regular)
            self.manuallyLayout()
        }
    }
    
    private func requestRandomImage() {
        var random = UnsplashApi.random
        random.params = ["count":randomImageCount]
        guard let url = random.url else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let jsonData = data {
                
                do {
                    if self.randomImageCount == 1 {
                        let randomImage = try JSONDecoder().decode(UnsplashImage.self, from: jsonData)
                        self.images = [randomImage]
                    } else {
                        let randomImages = try JSONDecoder().decode(Array<UnsplashImage>.self, from: jsonData)
                        self.images = randomImages
                    }
                } catch {
                    print("error = \(error)")
                }
                
            }
            
        }.resume()
    }
}

extension ImageWebCacheDemoViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let image = images?[indexPath.row] else { return }
        imgView?.setImage(with: image.urls.regular)
    }
}

extension ImageWebCacheDemoViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return randomImageCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = "\(indexPath.row + 1)"
        return cell
    }
}
