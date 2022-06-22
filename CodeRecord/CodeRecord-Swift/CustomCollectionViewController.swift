//
//  CustomCollectionViewController.swift
//  CodeRecord-Swift
//
//  Created by 谢鸿标 on 2022/6/22.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

import UIKit
import XHBCommonSwiftLib

private class CustomAnimatedCollectionViewCell: UICollectionViewCell {
    
    private lazy var label: UILabel = ({
        let lbl = UILabel()
        lbl.frame = contentView.bounds
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "PingFangSC-Medium", size: 20)
        return lbl
    })()
    
    func setTitle(_ title: String) {
        label.text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private class CustomAnimatedCollectionViewLayout: UICollectionViewLayout {
    
    private var layoutInfo = [IndexPath : UICollectionViewLayoutAttributes]()
    private var updateItemsSet = Set<UICollectionViewUpdateItem>()
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = self.collectionView else { return }
        layoutInfo.removeAll()
        let size = collectionView.size
        let itemCount = collectionView.numberOfItems(inSection: 0)
        for index in (0..<itemCount) {
            let indexPath = IndexPath(item: index, section: 0)
            let flag = (index == itemCount - 1)
            let layoutAttr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let origin = CGPoint(x: 0, y: flag ? 0 : 10)
            layoutAttr.frame = CGRect(origin: origin, size: size)
            layoutAttr.alpha = flag ? 1 : 0
            layoutInfo[indexPath] = layoutAttr
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layouts = Array<UICollectionViewLayoutAttributes>()
        let layoutKeys = layoutInfo.keys.sorted()
        layoutKeys.forEach { indexPath in
            guard let layoutAttr = layoutInfo[indexPath] else { return }
            layouts.append(layoutAttr)
        }
        return layouts
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        updateItemsSet.formUnion(updateItems)
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttr = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        
        updateItemsSet.forEach { updateItem in
            let action = updateItem.updateAction
            switch action {
            case .move:
                break
            case .insert:
                break
            case .delete:
                layoutAttr?.frame.origin = .zero
                layoutAttr?.alpha = 1
                break
            case .reload:
                break
            case .none:
                layoutAttr?.frame.origin = .zero
                layoutAttr?.alpha = 1
                break
            @unknown default:
                break
            }
        }
        
        return layoutAttr
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttr = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        guard let view = collectionView else { return layoutAttr }
        
        updateItemsSet.forEach { updateItem in
            let action = updateItem.updateAction
            switch action {
            case .move:
                break
            case .insert:
                break
            case .delete:
                layoutAttr?.frame.origin = CGPoint(x: -view.width, y: 0)
                layoutAttr?.alpha = 0
                break
            case .reload:
                break
            case .none:
                layoutAttr?.frame.origin = CGPoint(x: 0, y: 10)
                layoutAttr?.alpha = 0
                break
            @unknown default:
                break
            }
        }
        
        return layoutAttr
    }
}


class CustomCollectionViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = ({
        let layout = CustomAnimatedCollectionViewLayout()
        let size = CGSize(width: view.width, height: 80)
        let rect = CGRect(x: (view.width - size.width) / 2, y: (view.height - 50) / 2, width: size.width, height: size.height)
        let cv = UICollectionView(frame: rect, collectionViewLayout: CustomAnimatedCollectionViewLayout())
        cv.layer.borderWidth = 1
        cv.layer.borderColor = UIColor.black.cgColor
        cv.layer.masksToBounds = true
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(CustomAnimatedCollectionViewCell.self, forCellWithReuseIdentifier: "ColorCell")
        return cv
    })()
    
    let colorStrings = [
        "FFEBCD", "FFDAB9", "00C5CD", "E6E6FA", "FFFACD", "6A5ACD",
        "8B658B", "BC8F8F", "D2B48C", "FFA54F", "FF00FF", "8A2BE2"
    ]
    
    var mColorStrings = [String]()
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mColorStrings = colorStrings
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        let button = UIButton(type: .custom, target: self, action: #selector(startTimerAction(_:)), for: .touchUpInside)
        button.setTitle("启动计时器", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.sizeToFit()
        button.origin = CGPoint(x: 50, y: 100)
        view.addSubview(button)
    }
    
    @objc func startTimerAction(_ sender: UIButton) {
        if timer != nil { return }
        timer = Timer.scheduled(interval: 5,
                                loopInCommonModes: true,
                                repeats: true,
                                action: { [weak self] duration in
            guard let strongSelf = self else { return }
            strongSelf.updateColors()
        })
    }
    
    func updateColors() {
        if mColorStrings.isEmpty {
            timer?.invalidate()
            timer = nil
            mColorStrings = colorStrings
            let count = mColorStrings.count
            let indexPaths = (0..<count).map { IndexPath(item: $0, section: 0) }
            collectionView.insertItems(at: indexPaths)
            return
        }
        let count = mColorStrings.count
        mColorStrings.remove(at: count - 1)
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut]) {
            self.collectionView.performBatchUpdates { [weak self] in
                self?.collectionView.deleteItems(at: [IndexPath(item: count - 1, section: 0)])
            }
        }
    }
}

extension CustomCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mColorStrings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
        
        if let customCell = cell as? CustomAnimatedCollectionViewCell {
            let colorString = mColorStrings[indexPath.item]
            customCell.setTitle("\(indexPath.item + 1)")
            customCell.backgroundColor = UIColor(hexString: colorString, alpha: 1)
        }
        
        return cell
    }
    
}
