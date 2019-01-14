//
//  UIFont+Extension.swift
//  LYSegmentController
//
//  Created by 刃 on 2019/1/10.
//  Copyright © 2019年 CocoaPods. All rights reserved.
//

import UIKit

extension UIFont{
    
    class func getFontWith(size:CGFloat, fontName:String) -> UIFont {
        if SCREEN_WIDTH <= 500 {
            return UIFont.init(name: fontName, size: size * SCREEN_WIDTH / 375)!
        }
        return UIFont.init(name: fontName, size: size )!
    }

    class func getNormalFontWith(size:CGFloat) -> UIFont {
        if SCREEN_WIDTH <= 500 {
            return UIFont.systemFont(ofSize: size * SCREEN_WIDTH / 375)
        }
        return UIFont.systemFont(ofSize: size )
    }
}
