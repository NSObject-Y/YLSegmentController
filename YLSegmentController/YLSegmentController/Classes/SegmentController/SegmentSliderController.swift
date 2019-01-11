//
//  SegmentSliderController.swift
//
//
//  Created by ik100 on 2018/9/27.
//  Copyright © 2018年 shack. All rights reserved.
//

import UIKit


private let kScrollLineH : CGFloat = 3
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)
private var totalLabelWidth:CGFloat = 0


public protocol SegementSliderDetegate: NSObjectProtocol{
    func segmentController(_ controller:SegmentSliderController, selectIndex index:Int)
    
    func selectImageClick()
}

public class SegmentSliderController: UIView {
    
    open weak var delegate: SegementSliderDetegate?
    //选中的颜色
    public var selectTitleColor: UIColor = UIColor.blue
    //未选中的颜色
    public var noSelectTitleColor: UIColor = UIColor.black
    //默认选择index = 0
    public var selectIndex: Int = 0
    //滚动线条颜色
    public var segmentLineColor: UIColor =  UIColor.red
    //segmenSlider color default==white
    public var segmentSliderColor: UIColor = UIColor.white
    //是否隐藏下划线
    public var isHiddenLine: Bool = false
    //segment 类型（导航、正常）
    public var segmentType: SegmentControllerType = .Navigation
    
    //titleArray
    public var titles: [String]{
        didSet {
            for label in titleLabels {
                label.removeFromSuperview()
            }
            titleLabels.removeAll()
            self.navView?.removeFromSuperview()
            self.setUI(segmentSliderHeight: self.segmentSilder_height ?? 40.0)
        }
    }
    //未选中字体
    public var titleNormalFont: CGFloat = 12.0
    //选中后的字体
    public var titleSelectFont: CGFloat = 15.0
    
    public var childsViewControllers: [UIViewController]?{
        didSet{
            if self.childsViewControllers != nil{
                
                    if self.segmentType == .Navigation{
                        if segmentContent == nil {
                            let frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height:self.frame.size.height)
                            self.segmentContent = SegmentContentController.init(frame: frame, childVcs: self.childsViewControllers!, parentViewController: self.hostViewController)
                            segmentContent!.delegate = self
                            self.addSubview(segmentContent!)
                            self.bringSubviewToFront(self.navView!)
                        
                        }
                    }else{
                        if segmentContent == nil {
                            let frame = CGRect.init(x: 0, y: self.segmentSilder_height!, width: self.frame.size.width, height:self.frame.size.height - self.segmentSilder_height!)
                            self.segmentContent = SegmentContentController.init(frame: frame, childVcs: self.childsViewControllers!, parentViewController: self.hostViewController)
                            segmentContent!.delegate = self
                            self.addSubview(segmentContent!)
                        }
                    }
                
            }
        }
    }
    
    //line是否滚动
    public var  lineIsScroling = false{
        didSet {
            if lineIsScroling == true {
                scrollLine.isHidden = false
                for label in titleLabels {
                    if label.tag == 0 {
                        label.textColor = selectTitleColor
                    }else {
                        label.textColor = noSelectTitleColor
                    }
                }
            }else {
                scrollLine.isHidden = true
                for label in titleLabels {
                    if label.tag == 0 {
                        label.textColor = selectTitleColor
                    }else {
                        label.textColor = noSelectTitleColor
                    }
                }
            }
        }
    }
    
    lazy var searchButton:UIButton = {
        let searchButton = UIButton(type: .custom)
        searchButton.setImage(UIImage.init(named: "nav_search"), for: .normal)
        searchButton.addTarget(self, action: #selector(self.searchClick), for: .touchUpInside)
        return searchButton
    }()
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = true
        scrollView.bounces = false
        return scrollView
    }()
    fileprivate lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = segmentLineColor
        scrollLine.layer.cornerRadius = 1.5
        scrollLine.layer.masksToBounds = true
        return scrollLine
    }()
    
    private var segmentContent: SegmentContentController?
    private var  segmentSilder_height:CGFloat?
    private var  hostViewController: UIViewController!
    private lazy var titleLabels :[UILabel] = [UILabel]()
    //导航背景
    private var navView: UIView?
    
    public init(frame: CGRect = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - safeAreaStatusHeight), titles: [String], segmentSliderHeight: CGFloat = 40.0,hostViewController:UIViewController?) {
        self.titles = titles
        self.segmentSilder_height = segmentSliderHeight
        self.hostViewController = hostViewController
        super.init(frame: frame)
        setUI(segmentSliderHeight:segmentSliderHeight)
    }
    
    public convenience init(HHMade hostViewController:UIViewController,titles:[String]) {
        let frame: CGRect = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - safeAreaStatusHeight)
        self.init(frame: frame, titles: titles, segmentSliderHeight: 40.0, hostViewController: hostViewController)
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK:- 设置UI界面
extension SegmentSliderController {
    func setUI(segmentSliderHeight: CGFloat) {
        
        let navView = UIView()
        self.navView = navView
        if self.segmentType == .Navigation{
            navView.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: safeAreaTopHeight)
        }else{
            navView.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.segmentSilder_height ?? 40.0)
        }
        self.addSubview(navView)
        
        navView.addSubview(scrollView)
        var width:CGFloat = 0
        for title in titles {
            let titleWidth = UILabel.getWidthWith(title: title, font: UIFont.getNormalFontWith(size: 16)) + 20
            width += titleWidth
        }
        width = width > (SCREEN_WIDTH - 80) ? (SCREEN_WIDTH - 80) : width
        if self.segmentType == .Navigation{
            scrollView.frame = CGRect.init(x: 0, y: safeAreaTopHeight - segmentSliderHeight, width: self.frame.width - 40, height:segmentSliderHeight)
        }else{
            scrollView.frame = CGRect.init(x: 0, y: 0, width: self.frame.width - 40, height:segmentSliderHeight)
            
        }
        setupTitleLabels()
        
        navView.addSubview(searchButton)
        if self.segmentType == .Navigation{
            searchButton.frame = CGRect.init(x:self.frame.size.width - 40, y: safeAreaTopHeight - segmentSliderHeight, width: 40, height: 40)
        }else{
            searchButton.frame = CGRect.init(x:self.frame.size.width - 40, y: 0, width: 40, height: 40)
        }
        
        //设置底线和滚动的滑块
        setupBottomLineAndScrollLine()
    }
    
    fileprivate func setupBottomLineAndScrollLine() {
        //获取第一个Label
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = selectTitleColor
        
        //设置scrollLine的属性
        scrollView.addSubview(scrollLine)
        scrollLine.isHidden = self.isHiddenLine
        scrollLine.frame = CGRect(x: firstLabel.center.x - 15, y: 31, width: 30, height: kScrollLineH)
    }
    
    fileprivate func setupTitleLabels() {
        // 0.确定label的一些frame的值
        let labelH : CGFloat = 30
        let labelY : CGFloat = 5
        var lastX  : CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            // 1.创建UILabel
            let label = UILabel()
            // 2.设置Label的属性
            label.text = title
            label.tag = index
            label.font = UIFont.getFontWith(size: 16, fontName: "PingFangSC-Semibold")
            label.textColor = noSelectTitleColor
            label.textAlignment = .center
            if index != 0 {
                label.font = UIFont.getFontWith(size: 14, fontName: "PingFangSC-Regular")
            }
            // 3.设置label的frame
            let labelW : CGFloat = 20 + UILabel.getWidthWith(title: title, font: UIFont.getNormalFontWith(size: 16))
            let labelX : CGFloat = lastX
            totalLabelWidth += labelW
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            lastX = lastX + labelW
            
            // 4.将label添加到scrollView中
            scrollView.addSubview(label)
            titleLabels.append(label)
            scrollView.contentSize = CGSize.init(width: lastX, height: 40)
            
            // 5.给Label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.clickTitleLabel(_:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    
    //imageClick
    @objc func searchClick() {
        if let delegate = self.delegate{
            delegate.selectImageClick()
        }
    }
}

// MARK:- 对外暴露的方法
extension SegmentSliderController {
    /* 参数说明
     *
     * 第一个参数：进度
     * 第二个参数：当前位置
     * 第三个参数：目标位置
     */
    func setTitleWithProgress(_ progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        // 1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2.处理滑块的逻辑
        let moveTotalX = targetLabel.center.x - sourceLabel.center.x
        let moveX = moveTotalX * progress
        scrollLine.center.x = sourceLabel.center.x + moveX
        scrollLine.frame.size.width = 30
        selectIndex = targetIndex
        
        
        // 3.处理scrollView
        let contentOffset = scrollView.contentOffset
        let labelCenterX = targetLabel.frame.origin.x + targetLabel.frame.size.width/2.0 - contentOffset.x
        let maxScrollX = scrollView.contentSize.width - scrollView.frame.width // 最大滚动距离
        print("label的中心位置\(labelCenterX), scrollView滑动距离\(contentOffset.x), 滑动距离\(moveTotalX)")
        if targetIndex > sourceIndex { // 向右滑动
            if (labelCenterX > SCREEN_WIDTH/2.0) {
                if contentOffset.x + (labelCenterX - SCREEN_WIDTH/2.0) > maxScrollX {
                    scrollView.setContentOffset(CGPoint.init(x: maxScrollX, y: contentOffset.y), animated: true)
                }else {
                    scrollView.setContentOffset(CGPoint.init(x: contentOffset.x + (labelCenterX - SCREEN_WIDTH/2.0), y: contentOffset.y), animated: true)
                }
                
            }
        }else { // 向左滑动
            if labelCenterX < SCREEN_WIDTH/2.0 {
                if contentOffset.x + (labelCenterX - SCREEN_WIDTH/2.0) < 0 {
                    scrollView.setContentOffset(CGPoint.init(x: 0, y: contentOffset.y), animated: true)
                }else {
                    scrollView.setContentOffset(CGPoint.init(x: contentOffset.x + (labelCenterX - SCREEN_WIDTH/2.0), y: contentOffset.y), animated: true)
                }
            }
        }
        
        
        if selectIndex == 0 {
            
            if lineIsScroling == false {
                scrollLine.isHidden = true
                searchButton.setImage(UIImage.init(named: "nav_search"), for: .normal)

                targetLabel.textColor = selectTitleColor
                sourceLabel.font = UIFont.getFontWith(size: 14, fontName: "PingFangSC-Regular")
                targetLabel.font = UIFont.getFontWith(size: 16, fontName: "PingFangSC-Semibold")
                for i in 0..<titleLabels.count {
                    let label = titleLabels[i]
                    if i != 0 {
                        label.textColor = noSelectTitleColor
                    }
                }
            }else {
                scrollLine.isHidden = false
                searchButton.setImage(UIImage.init(named: "nav_search"), for: .normal)

                targetLabel.textColor = selectTitleColor
                sourceLabel.font = UIFont.getFontWith(size: 14, fontName: "PingFangSC-Regular")
                targetLabel.font = UIFont.getFontWith(size: 16, fontName: "PingFangSC-Semibold")
                for i in 0..<titleLabels.count {
                    let label = titleLabels[i]
                    if i != selectIndex {
                        label.textColor = noSelectTitleColor
                    }
                }
            }
        }else {
            scrollLine.isHidden = false
            searchButton.setImage(UIImage.init(named: "search_select"), for: .normal)
            targetLabel.textColor = selectTitleColor
            sourceLabel.font = UIFont.getFontWith(size: 14, fontName: "PingFangSC-Regular")
            targetLabel.font = UIFont.getFontWith(size: 16, fontName: "PingFangSC-Semibold")
            for i in 0..<titleLabels.count {
                let label = titleLabels[i]
                if i != selectIndex {
                    label.textColor = noSelectTitleColor
                }
            }
        }
        
    }
}


// MARK:- 监听Label的点击
extension SegmentSliderController{
    @objc fileprivate func clickTitleLabel(_ tapGes : UITapGestureRecognizer) {
        
        // 0.获取当前Label
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        // 1.如果是重复点击同一个Title,那么直接返回
        if currentLabel.tag == selectIndex { return }
        
        // 2.获取之前的Label
        let oldLabel = titleLabels[selectIndex]
        
        let contentOffset = scrollView.contentOffset
        let labelCenterX = currentLabel.frame.origin.x + currentLabel.frame.size.width/2.0 - contentOffset.x
        let maxScrollX = scrollView.contentSize.width - scrollView.frame.width // 最大滚动距离
        if currentLabel.center.x > oldLabel.center.x { // 向右滑动
            if (labelCenterX > SCREEN_WIDTH/2.0) {
                if contentOffset.x + (labelCenterX - SCREEN_WIDTH/2.0) > maxScrollX {
                    scrollView.setContentOffset(CGPoint.init(x: maxScrollX, y: contentOffset.y), animated: true)
                }else {
                    scrollView.setContentOffset(CGPoint.init(x: contentOffset.x + (labelCenterX - SCREEN_WIDTH/2.0), y: contentOffset.y), animated: true)
                }
                
            }
        }else { // 向左滑动
            if labelCenterX < SCREEN_WIDTH/2.0 {
                if contentOffset.x + (labelCenterX - SCREEN_WIDTH/2.0) < 0 {
                    scrollView.setContentOffset(CGPoint.init(x: 0, y: contentOffset.y), animated: true)
                }else {
                    scrollView.setContentOffset(CGPoint.init(x: contentOffset.x + (labelCenterX - SCREEN_WIDTH/2.0), y: contentOffset.y), animated: true)
                }
            }
        }
        
        // 3.切换文字的颜色
        if currentLabel.tag == 0 {
            if lineIsScroling == false {
                scrollLine.isHidden = true
                searchButton.setImage(UIImage.init(named: "nav_search"), for: .normal)
                currentLabel.textColor = selectTitleColor
                for i in 0..<titleLabels.count {
                    let label = titleLabels[i]
                    if i != 0 {
                        label.textColor = noSelectTitleColor
                    }
                }
            }else {
                scrollLine.isHidden = false
                searchButton.setImage(UIImage.init(named: "nav_search"), for: .normal)
                currentLabel.textColor = selectTitleColor
                for i in 0..<titleLabels.count {
                    let label = titleLabels[i]
                    if i != currentLabel.tag {
                        label.textColor = noSelectTitleColor
                    }
                }
            }
            
            
        }else {
            scrollLine.isHidden = false
            searchButton.setImage(UIImage.init(named: "nav_search"), for: .normal)
            currentLabel.textColor = selectTitleColor
            for i in 0..<titleLabels.count {
                
                let label = titleLabels[i]
                if i != currentLabel.tag {
                    label.textColor = noSelectTitleColor
                }
            }
        }
        currentLabel.font = UIFont.getFontWith(size: 16, fontName: "PingFangSC-Semibold")
        oldLabel.font = UIFont.getFontWith(size: 14, fontName: "PingFangSC-Regular")
        
        // 4.保存最新Label的下标值
        selectIndex = currentLabel.tag
        
        // 5.滚动条位置发生改变
        let scrollLineX = currentLabel.center.x - 15
        let scrollLineWidth:CGFloat = 30
        UIView.animate(withDuration: 0.15, animations: {
            self.scrollLine.frame.origin.x = scrollLineX
            self.scrollLine.frame.size.width = scrollLineWidth
        })
        
        self.delegate?.segmentController(self, selectIndex: selectIndex)
        self.segmentContent?.setCurrentIndex(selectIndex)
    }
}


extension SegmentSliderController:segmentPageContentControllerDelegate{
    func selectIndexPageContentController(_ contentController: SegmentContentController, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        self.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

