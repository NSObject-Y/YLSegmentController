//
//  ScreenDefine.swift
//  LYSegmentController
//
//  Created by 刃 on 2019/1/10.
//  Copyright © 2019年 CocoaPods. All rights reserved.
//

import UIKit
import Foundation


public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
public let SCREEN_WIDTH = UIScreen.main.bounds.size.width


//设备
public let iPhone_X = UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ?  __CGSizeEqualToSize(CGSize.init(width: 1125, height: 2436), (UIScreen.main.currentMode?.size)!) : false

public let iPhone_Xr = UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ?  __CGSizeEqualToSize(CGSize.init(width: 828, height: 1792), (UIScreen.main.currentMode?.size)!) : false

public let iPhone_Xs = UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ?  __CGSizeEqualToSize(CGSize.init(width: 1125, height: 2436), (UIScreen.main.currentMode?.size)!) : false

public let iPhone_Xs_Max = UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ?  __CGSizeEqualToSize(CGSize.init(width: 1242, height: 2688), (UIScreen.main.currentMode?.size)!) : false


public let safeAreaTopHeight:CGFloat = ((iPhone_X || iPhone_Xr || iPhone_Xs || iPhone_Xs_Max) ? 88 : 64)
public let safeAreaBottomHeight:CGFloat = ((iPhone_X || iPhone_Xr || iPhone_Xs || iPhone_Xs_Max) ? 84 : 50)
public let safeAreaStatusHeight:CGFloat = ((iPhone_X || iPhone_Xr || iPhone_Xs || iPhone_Xs_Max) ? 44 : 20)
public let safeAreaBottomStatusHeight:CGFloat = ((iPhone_X || iPhone_Xr || iPhone_Xs || iPhone_Xs_Max) ? 34 : 0)


public enum SegmentControllerType: NSInteger {
    case Navigation = 0
    case Normal = 1
}
