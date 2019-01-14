//
//  ViewController.swift
//  YLSegmentController
//
//  Created by yangsui92@163.com on 01/11/2019.
//  Copyright (c) 2019 yangsui92@163.com. All rights reserved.
//

import UIKit
import YLSegmentController
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let titles = ["推荐","获取","无语"];
        let segmentPageNav = YLSegmentSliderController(HHMade: self, titles: titles)
        segmentPageNav.delegate = self
        segmentPageNav.childsViewControllers = [ThreeViewController(),SecViewController(),FirstViewController()]
        self.view.addSubview(segmentPageNav)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController:SegementSliderDetegate{
    func segmentContentController(progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        print("dtabtab")
    }
    
    func segmentController(_ controller: YLSegmentSliderController, selectIndex index: Int) {
        print("dsdadada,----c=qiehuan")
    }
    
    func selectImageClick() {
        print("搜索------")
    }
}

