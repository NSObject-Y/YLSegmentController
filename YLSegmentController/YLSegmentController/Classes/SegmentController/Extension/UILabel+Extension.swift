//
//  UILabel+Extension.swift
//  LYSegmentController
//
//  Created by 刃 on 2019/1/10.
//  Copyright © 2019年 CocoaPods. All rights reserved.
//

import UIKit

extension UILabel {
    class func getWidthWith(title:String, font:UIFont) -> CGFloat {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 1000, height: 0))
        label.text = title
        label.font = font
        label.sizeToFit()
        return label.frame.size.width
    }
}
