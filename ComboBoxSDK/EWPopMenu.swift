//
//  EWPopMenu.swift
//  SeeneLevel
//
//  Created by 刘兴明 on 2021/1/21.
//  Copyright © 2021 刘兴明. All rights reserved.
//

import Foundation
import UIKit

public let NavigationMenuShared = EWPopMenu.shared

public class EWPopMenu: NSObject {
    public static let shared = EWPopMenu()
    private var menuView: EWPopMenuView?

    public func showPopMenuSelecteWithFrameWidth(width: CGFloat, height: CGFloat, point: CGPoint, funTitles: ((Int) -> (String, UIImage?))!, titleCount: Int, selectIndex: Int, action: @escaping ((Int) -> Void)) {
        weak var weakSelf = self
        /// 每次重置保证显示效果
        if self.menuView != nil {
            weakSelf?.hideMenu()
        }
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        self.menuView = EWPopMenuView(width: width, height: height, point: point, funTitles: funTitles, titleCount: titleCount, selectIndex: selectIndex, action: { (index) in
            ///点击回调
            action(index)
            weakSelf?.hideMenu()
        })
        menuView?.touchBlock = {
            weakSelf?.hideMenu()
            action(selectIndex)
        }
        self.menuView?.backgroundColor = UIColor.black.withAlphaComponent(0)
        window?.addSubview(self.menuView!)
    }
    public func hideMenu() {
        self.menuView?.removeFromSuperview()
        self.menuView = nil
    }
}
