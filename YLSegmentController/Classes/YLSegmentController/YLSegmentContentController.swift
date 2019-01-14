//
//  SegmentContentController.swift
//  HouseVideo
//
//  Created by ik100 on 2018/9/28.
//  Copyright © 2018年 shack. All rights reserved.
//

import UIKit

protocol  segmentPageContentControllerDelegate: NSObjectProtocol{
    func selectIndexPageContentController(_ contentController : YLSegmentContentController, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
}

private let ContentCellID = "ContentCellID"

class YLSegmentContentController: UIView {
    
    var childVcs : [UIViewController]
    {
        didSet {
            self.collectionView.removeFromSuperview()
            self.setUI()
        }
    }
    
    fileprivate weak var parentViewController : UIViewController?
    fileprivate var startOffsetX : CGFloat = 0
    fileprivate var isForbidScrollDelegate : Bool = false
    weak var delegate : segmentPageContentControllerDelegate?
    
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.lightGray
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollsToTop = false
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView
        }()
    
    init(frame: CGRect, childVcs : [UIViewController], parentViewController : UIViewController?) {
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        super.init(frame: frame)
        print("进入 初始化 ==\(frame)")
        // 设置UI
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        for childVc in childVcs {
            parentViewController?.addChildViewController(childVc)
        }
        addSubview(collectionView)
        collectionView.reloadData()
    }
    
}

extension YLSegmentContentController {
    func setCurrentIndex(_ currentIndex : Int) {
        //记录需要进制执行代理方法
        isForbidScrollDelegate = true
        //滚动正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}

extension YLSegmentContentController : UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        cell.backgroundColor = UIColor.white
        let childVc = childVcs[(indexPath as NSIndexPath).item]
        childVc.view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: self.frame.size.height)
        print("cell gao do --- \(self.frame.size.height)")
        cell.contentView.addSubview(childVc.view)
//        childVc.view.snp.makeConstraints { (make) in
//            make.centerX.equalTo(cell.contentView)
//            make.height.equalTo(cell.contentView)
//            make.top.equalTo(cell.contentView)
//            make.width.equalTo(SCREEN_WIDTH)
//        }
        return cell
    }
}




// MARK:- 遵守UICollectionViewDelegate
extension YLSegmentContentController : UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 0.判断是否是点击事件
        if isForbidScrollDelegate { return }
        
        // 1.定义获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        // 2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX { // 左滑
            // 1.计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            // 2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            
            // 4.如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        } else { // 右滑
            // 1.计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            // 2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
        }
        delegate?.selectIndexPageContentController(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}


