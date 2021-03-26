//
//  EWPopMenuView.swift
//  SeeneLevel
//
//  Created by 刘兴明 on 2021/1/21.
//  Copyright © 2021 刘兴明. All rights reserved.
//

import Foundation
import UIKit
/// 屏幕frame相关便捷方法
public struct ScreenInfo {
    static let Frame = UIScreen.main.bounds
    public static let Height = Frame.height
    public static let Width = Frame.width
    static let navigationHeight:CGFloat = navBarHeight()
    static func isIphoneX() -> Bool {
        return UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 375, height: 812))
    }
    static private func navBarHeight() -> CGFloat {
        return isIphoneX() ? 88 : 64
    }
}
/// 默认的cell高度宽度,可修改
let itemHeight: CGFloat = 44.0
let itemWidth: CGFloat = 213.0

open class EWPopMenuView: UIView {
    public var touchBlock: ( () -> Void )?
    /// 点击cell回调
    public var indexBlock: ( (Int) -> Void )?
    /// 起始点,tableView上三角形的顶部
    private var point:CGPoint?
    /// tableView.height
    private var layerHeight: CGFloat?
    /// tableView.width
    private var layerWidth: CGFloat?
    ///
    private var titleCount: Int?
    private var selectIndex: Int?
    /// cell标题array
    private var titleSource: ((Int) -> (String, UIImage?))!

    private var tableView: UITableView = UITableView()
    /// 下拉动画时间
    open var duration: TimeInterval = 0.5
    /// init
    ///
    /// - Parameters:
    ///   - width: tableView.width
    ///   - height: tableView最大height,如果cell数量大于4,则是tableView.frame.size.height
    ///   - point: 初始点,tableView上的三角形的顶点
    ///   - items: 每个cell的title数组
    ///   - imgSource: 每个cell的icon数组,可为空
    ///   - action: 回调方法
    init(width: CGFloat, height: CGFloat, point: CGPoint, funTitles: ((Int) -> (String, UIImage?))!, titleCount: Int, selectIndex: Int, action: ((Int) -> Void)?) {
        super.init(frame:CGRect(x: 0, y: 0, width: ScreenInfo.Width, height: ScreenInfo.Height))
        self.titleCount = titleCount
        self.titleSource = funTitles
        self.selectIndex = selectIndex
        drawMyTableView()
        /// view全屏展示
        self.frame = CGRect(x: 0, y: 0, width: ScreenInfo.Width, height: ScreenInfo.Height)
        /// 获取起始点
        self.point = CGPoint(x: point.x, y: ScreenInfo.navigationHeight + point.y)
        /// tableView高度由init方法传入
        self.layerWidth = width
        /// 弱引用防止闭包循环引用
        self.indexBlock = {[weak self] row in
            /// 点击cell回调,将点击cell.indexpath.row返回
    
            let ip = IndexPath(row: selectIndex, section: 0)
            let ip1 = IndexPath(row: row, section: 0)
            self?.selectIndex = row
            self?.tableView.reloadRows(at: [ip, ip1], with: .none)

            UIView.animate(withDuration: self!.duration, delay: 0.3, options: [], animations: { [weak self] in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.tableView.alpha = 0.0
            }){ (finished) -> Void in
                action?(row)
            }
        }
        
        /// tableView高度,如果大于4个则为4个itemHeight,使tableView可滑动,如果小于4个则动态显示
        self.layerHeight = titleCount > 4 ? height : CGFloat(CGFloat(titleCount) * itemHeight)
        self.addSubview(self.tableView)
        /// 将tableView.frame更新,使其在展示正确效果
        let y1 = (self.point?.y)! + 26
        let x2 = (self.point?.x)! - self.layerWidth! + 20
        tableView.frame = CGRect(x: x2, y: y1, width: self.layerWidth!, height: self.layerHeight!)
        self.backgroundColor = UIColor.clear
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func drawMyTableView() {
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.showsHorizontalScrollIndicator = true
        tableView.showsVerticalScrollIndicator = false
//        tableView.backgroundColor = UIColor(white: 0, alpha: 0.66)
        if #available(iOS 13.0, *) {
            tableView.backgroundColor = .systemGray4//.tertiarySystemBackground
        } else {
            tableView.backgroundColor = UIColor.darkGray
        }
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = true
        tableView.register(EWMenuTableViewCell.self, forCellReuseIdentifier: EWMenuTableViewCell.identifier)
    }
    /// drawRect方法,画tableView上的小三角形
    open override func draw(_ rect: CGRect) {
//        let y1 = (self.point?.y)! + 10
//        let x1 = (self.point?.x)! - 10
//        let x2 = (self.point?.x)! + 10
//
////        UIColor(white: 0, alpha: 0.66).set()
//        tableView.backgroundColor?.set()
//        let context = UIGraphicsGetCurrentContext()
//        context?.beginPath()
//        context?.move(to: CGPoint(x: (self.point?.x)!, y: (self.point?.y)!))
//        context?.addLine(to: CGPoint(x: x1, y: y1))
//        context?.addLine(to: CGPoint(x: x2, y: y1))
//        context?.closePath()
//        context?.fillPath()
//        context?.drawPath(using: .stroke)
    }
    /// 点击屏幕任意位置menu消失
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchBlock?()
    }

}
extension EWPopMenuView:UITableViewDelegate,UITableViewDataSource {

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemHeight
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleCount!
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:  EWMenuTableViewCell.identifier) as? EWMenuTableViewCell else {
            return EWMenuTableViewCell()
        }
        cell.setContentBy(funTitles: self.titleSource, row: indexPath.row)
        cell.conLabel.text = self.titleSource(indexPath.row).0
        if #available(iOS 13.0, *) {
            cell.conLabel.textColor = .label
        } else {
            // Fallback on earlier versions
        }
        if selectIndex == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexBlock!(indexPath.row)
    }
}
