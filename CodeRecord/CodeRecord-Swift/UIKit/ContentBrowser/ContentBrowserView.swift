//
//  ContentBrowserView.swift
//  CodeRecord-Swift
//
//  Created by xiehongbiao on 2021/9/3.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

import UIKit

open class ContentBrowserViewCell: UICollectionViewCell {
    
    open class var cellIdentifier: String {
        return String(describing: self)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func update<T>(_ content: T) {}
}

open class ContentBrowserViewModel<T>: NSObject, UICollectionViewDataSource {
    
    open weak var collectionView: UICollectionView? {
        didSet {
            collectionView?.register(ContentBrowserViewCell.self,
                                     forCellWithReuseIdentifier: ContentBrowserViewCell.cellIdentifier)
            collectionView?.register(ContentBrowserViewCell.self, forCellWithReuseIdentifier: "ContentBrowserViewErrorCell")
        }
    }
    private var contents = Array<T>()
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let content = content(at: indexPath.item),
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentBrowserViewCell.cellIdentifier, for: indexPath) as? ContentBrowserViewCell {
            cell.update(content)
            return cell
        }else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "ContentBrowserViewErrorCell", for: indexPath)
        }
        
    }
    
    open func content(at index: Int) -> T? {
        if index < contents.count {
            return contents[index]
        }else {
            return nil
        }
    }
    
    open func append(_ content: T) {
        contents.append(content)
        collectionView?.reloadData()
    }
    
    open func append(_ contentArr: [T]) {
        contents.append(contentsOf: contentArr)
        collectionView?.reloadData()
    }
    
    open func scroll(to page: Int) {
        collectionView?.contentOffset = CGPoint(x: (collectionView?.width ?? 0) * CGFloat(page), y: 0)
    }
}

open class ContentBrowserFlowlayout: UICollectionViewFlowLayout {
    
    open var pageMargin: CGFloat = 20
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init() {
        super.init()
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        sectionInset = .zero
        scrollDirection = .horizontal
    }
    
    open override func prepare() {
        super.prepare()
        
        guard let pageSize = collectionView?.size else { return }
        itemSize = pageSize
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let copyAttrs = super.layoutAttributesForElements(in: rect)
        guard let collection = collectionView else { return copyAttrs }
        let halfWidth = collection.width / 2.0
        let centerX = collection.contentOffset.x + halfWidth
        
        copyAttrs?.forEach({ attribute in
            let x = attribute.center.x + (attribute.center.x - centerX) / halfWidth * pageMargin / 2
            attribute.center = CGPoint(x: x, y: attribute.center.y)
        })
        
        return copyAttrs
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

open class ContentBrowserCollectionView: UICollectionView {
    
    open var centerCell: UICollectionViewCell? {
        guard var cell = visibleCells.first else { return nil }
        let pageCenterX = contentOffset.x + width / 2.0
        for i in 1..<visibleCells.count {
            let icell = visibleCells[i]
            if abs(icell.centerX - pageCenterX) < abs(cell.centerX - pageCenterX) {
                cell = icell
            }
        }
        return cell
    }
    private(set) var flowlayout: ContentBrowserFlowlayout?
    private var cellIdentifiers = Set<String>()
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public init(frame: CGRect) {
        let layout = ContentBrowserFlowlayout()
        super.init(frame: frame, collectionViewLayout: layout)
        flowlayout = layout
    }
    
    open func scroll(to page: Int) {
        guard let layout = flowlayout else { return }
        switch layout.scrollDirection {
        case .horizontal:
            contentOffset = CGPoint(x: width * CGFloat(page), y: 0)
            break
        case .vertical:
            contentOffset = CGPoint(x: 0, y: height * CGFloat(page))
            break
        @unknown default:
            break
        }
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        isScrollEnabled = !(view?.isKind(of: UISlider.self) ?? false)
        return view
    }
    
    open func reuseIdentifier(for cellClass: AnyClass) -> String {
        let identifier = String(describing: cellClass)
        if !cellIdentifiers.contains(identifier) {
            self .register(cellClass, forCellWithReuseIdentifier: identifier)
        }
        return identifier
    }
}

open class ContentBrowserView<T>: UIView, UICollectionViewDelegate {
    
    fileprivate var collectionView: ContentBrowserCollectionView?
    
    open var viewModel: ContentBrowserViewModel<T>? {
        didSet {
            viewModel?.collectionView = collectionView
            collectionView?.dataSource = viewModel
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        let collection = ContentBrowserCollectionView(frame: bounds)
        collection.flowlayout?.itemSize = bounds.size
        collection.flowlayout?.scrollDirection = .horizontal
        collection.backgroundColor = .white
        collection.delegate = self;
        collection.isPagingEnabled = true
        collection.decelerationRate = .fast
        collection.alwaysBounceVertical = false
        collection.alwaysBounceHorizontal = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            collection.contentInsetAdjustmentBehavior = .never
        }
        addSubview(collection)
        collectionView = collection
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView?.frame = bounds
        collectionView?.flowlayout?.itemSize = bounds.size
    }
    
    open func scroll(to page: Int) {
        viewModel?.scroll(to: page)
    }
}

//MARK: 按通用封装

open class ContentBrowserViewImageCell: ContentBrowserViewCell, UIScrollViewDelegate {
    
    private var imageView: UIImageView?
    private var scrollView: UIScrollView?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupSubviews()
        setupGestures()
    }
    
    private func setupSubviews() {
        let scroll = UIScrollView(frame: bounds)
        scroll.minimumZoomScale = 1
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.decelerationRate = .fast
        scroll.alwaysBounceVertical = false
        scroll.alwaysBounceHorizontal = false
        if #available(iOS 11.0, *) {
            scroll.contentInsetAdjustmentBehavior = .never
        }
        contentView.addSubview(scroll)
        scrollView = scroll
        let imgView = UIImageView(frame: bounds)
        imgView.contentMode = .scaleAspectFill
        scroll.addSubview(imgView)
        imageView = imgView
    }
    
    private func setupGestures() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapAction(_:)))
        singleTap.numberOfTapsRequired = 1
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction(_:)))
        doubleTap.numberOfTapsRequired = 2
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        pan.maximumNumberOfTouches = 1
        
        singleTap.require(toFail: doubleTap)
        singleTap.require(toFail: pan)
        doubleTap.require(toFail: pan)
        
        contentView.addGestureRecognizer(singleTap)
        contentView.addGestureRecognizer(doubleTap)
        contentView.addGestureRecognizer(pan)
    }
    
    @objc private func singleTapAction(_ sender: UITapGestureRecognizer) {
        
    }
    
    @objc private func doubleTapAction(_ sender: UITapGestureRecognizer) {
        
    }
    
    @objc private func panAction(_ sender: UIPanGestureRecognizer) {
        
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard var imageFrame = imageView?.frame else { return }
        
        let scrollFrame = scrollView.frame
        if imageFrame.height > scrollFrame.height {
            imageFrame.origin.y = 0
        }else {
            imageFrame.origin.y = (scrollFrame.height - imageFrame.height) / 2
        }
        if imageFrame.width > scrollFrame.width {
            imageFrame.origin.x = 0
        }else {
            imageFrame.origin.x = (scrollFrame.width - imageFrame.width) / 2
        }
        imageView?.frame = imageFrame
    }
    
    public override func update<T>(_ content: T) {
        if let url = content as? URL {
            imageView?.setImage(with: url)
            return
        }
        if let urlString = content as? String {
            imageView?.setImage(with: urlString)
            return
        }
    }
    
    open override func prepareForReuse() {
        imageView?.image = nil
        super.prepareForReuse()
    }
}

open class ContentBrowserImageViewModel<T>: ContentBrowserViewModel<T> {
    
    open override var collectionView: UICollectionView? {
        didSet {
            collectionView?.register(ContentBrowserViewImageCell.self, forCellWithReuseIdentifier: ContentBrowserViewImageCell.cellIdentifier)
            collectionView?.register(ContentBrowserViewImageCell.self, forCellWithReuseIdentifier: "ContentBrowserViewImageErrorCell")
        }
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let content = content(at: indexPath.item),
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentBrowserViewImageCell.cellIdentifier,
                                                         for: indexPath) as? ContentBrowserViewCell {
            cell.update(content)
            return cell
        }else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "ContentBrowserViewImageErrorCell", for: indexPath)
        }
    }
}
