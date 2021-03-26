//
//  DropBoxTextField.swift
//  SeeneLevel
//
//  Created by 刘兴明 on 2021/1/18.
//  Copyright © 2021 刘兴明. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//@IBDesignable
open class DropBoxTextField: UIView {
    let disposeBag = DisposeBag()

    /********************************************************************************/
    /*                                                                              */
    /*                               必设属性                                        */
    /*                                                                              */
    /* 注意: 请在使用前设置以下属性，确保下拉框显示和行为的正常                               */
    /********************************************************************************/
    
    /// 选项数量
    open var count: Int = 0
    /// 某一项内容的闭包
    ///
    /// - Parameters:
    ///   - 入参: Row Index
    ///   - 出参: 标题 和 图标
    open var itemForRowAt: ((Int) -> (String, UIImage?))!
    /// 选中某一项后的处理闭包
    open var didSelectedAt: ((Int, String, DropBoxTextField) -> Void)?
    
    /********************************************************************************/
    /*                                                                              */
    /*                              可选自定义属性                                    */
    /*                                                                              */
    /********************************************************************************/
    
    /// 最大下拉高度(不包括输入框)，超过此高度需要滑动，默认没有限制
    open var maxHeight: CGFloat = CGFloat(Int.max)
    
    /// 是否下拉
    open var isDrop: Bool {
        get { return _isDrop }
        set {
            if (newValue == _isDrop) { return }
            if (newValue) {
                dropDwon()
            } else {
                drawUp()
            }
            _isDrop = newValue
        }
    }
    
    /// 每一个选项的高度，默认44
//    open var itemHeight: CGFloat = 44 {
//        didSet {
//            _tableView.reloadData()
//        }
//    }
    
    /// 下拉动画时间
    open var duration: TimeInterval = 0.3
    
    /// 获取输入框的文本
    open var text: String? {
        get {
            return _textField.text
        }
    }
    
    open var selectedIndex: Int = 0 {
        didSet{
            _textField.text = itemForRowAt(selectedIndex).0
        }
    }
    /********************************************************************************/
    /*                                                                              */
    /*                                  私有属性                                     */
    /*                                                                              */
    /********************************************************************************/
    
    /// 是否下拉
    private var _isDrop: Bool = false {
        didSet {
            if (_isDrop) {
                UIView.animate(withDuration: duration) { [weak self] () in
                    let transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                    self?._button.transform = transform
                }
            } else {
                UIView.animate(withDuration: duration) { [weak self] () in
                    let transform = CGAffineTransform(rotationAngle: 0)
                    self?._button.transform = transform
                }
            }
        }
    }
    /// 下拉框
//    private var _tableView: UITableView!
    /// 输入框
    private var _textField: UITextField!
    /// 右边下拉按钮
//    private var _button: UIImageView!
    private var _button: UIButton!

    open override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    // 只在 @IBDesignable 标识的类中起作用，且只在 IB 编译时起作用，程序运行时不会调用
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()

    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        _button.frame = CGRect(x: rect.width - rect.height, y: 0, width: rect.height, height: rect.height)
        _textField.frame = CGRect(x: 10, y: 0, width: rect.width - rect.height - 10, height: rect.height)
    }
    
    private func commonInit() {
        
        backgroundColor = .clear;
        
        _textField = UITextField()
        
        let image = UIImage(named: "previous")
        let flipImage =  UIImage(cgImage:image!.cgImage!,
                                 scale:image!.scale,
                                 orientation:.left // 顺时针旋转90°
        ).withRenderingMode(.alwaysTemplate)
        _button = UIButton(type: .system)//frame: CGRect(x: bounds.width - bounds.height, y: 0, width: bounds.height, height: bounds.height))
        _button.setImage(flipImage, for: .normal)
        _button.tintColor = .systemBlue
        _button.rx.tap.subscribe(onNext: {[weak self] in
            self?.isDrop = !self!.isDrop
        })
        .disposed(by: disposeBag)
//
//        _tableView = UITableView(frame: .zero, style: .plain)
//        _tableView.delegate = self
//        _tableView.dataSource = self
//        _tableView.separatorStyle = .none
//        _tableView.backgroundColor = .clear
//        _tableView.register(SimpleDropBoxCell.classForCoder(), forCellReuseIdentifier: "dropBoxCell")
//        _tableView.allowsSelection = true
//        _tableView.layer.shadowColor = UIColor.darkGray.cgColor
//        _tableView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        _tableView.layer.shadowRadius = 3
//        _tableView.layer.shadowOpacity = 0.8
//
//        _tableView.frame = CGRect(x: 0, y: bounds.height, width: bounds.width, height: 0)

        addSubview(_textField)
//        addSubview(_tableView)
        addSubview(_button)
    }
        
    /// MARK: TableView DataSource and Delegate
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "dropBoxCell", for: indexPath) as! SimpleDropBoxCell
//
//        if selectedIndex == indexPath.row {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
//
//        cell.setModel( text: itemForRowAt(indexPath.row).0, img: itemForRowAt(indexPath.row).1)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return self.itemHeight
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        _textField.text = itemForRowAt(indexPath.row).0
//        didSelectedAt?(indexPath.row, itemForRowAt(indexPath.row).0, self)
//
//        let ip = IndexPath(row: selectedIndex, section: 0)
//        let celled = tableView.cellForRow(at: ip)
//        celled?.accessoryType = .none
//        let cell = tableView.cellForRow(at: indexPath)
//        cell?.accessoryType = .checkmark
//    }
    
    /********************************************************************************/
    /*                                                                              */
    /*                                 公共访问行为                                   */
    /*                                                                              */
    /********************************************************************************/
    
    open func dropDwon() {
        if(_isDrop) {
            return
        }
        _isDrop = true
        
        // 计算顶部预留高度
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        var topPadding: CGFloat = 0
        if #available(iOS 11.0, *) {
            topPadding = (window?.safeAreaInsets.top)!
        } else {
            // Fallback on earlier versions
            topPadding = 20
        }
        
        NavigationMenuShared.showPopMenuSelecteWithFrameWidth(width: frame.width, height: 160, point: CGPoint(x: frame.maxX - 20, y: frame.maxY + topPadding - 29), funTitles: itemForRowAt, titleCount: count, selectIndex: selectedIndex, action: {[weak self] index in
            if let result = self?.itemForRowAt(index).0 {
                self?._textField.text = result
                self?.didSelectedAt?(index, result, self!)
                self?.selectedIndex = index
                self?.isDrop = !self!.isDrop
            }
        })
//        UIView.animate(withDuration: duration, animations: { [weak self] in
//            guard let weakSelf = self else {
//                return
//            }
//            var h = CGFloat(weakSelf.count) * weakSelf.itemHeight
//            if( h > weakSelf.maxHeight) {
//                weakSelf._tableView.isScrollEnabled = true
//                h = weakSelf.maxHeight
//            } else {
//                weakSelf._tableView.isScrollEnabled = false
//            }
//            weakSelf._tableView.frame.size.height = h
//            weakSelf.frame.size.height = weakSelf.frame.size.height + h
//        })
        
        /// 始终保持在最前
        superview?.bringSubviewToFront(self)
    }
    
    open func drawUp() {
        if(!_isDrop) {
            return
        }
        _isDrop = false
        
//        UIView.animate(withDuration: duration / 2, animations: { [weak self] in
//            guard let weakSelf = self else {
//                return
//            }
//            let h = weakSelf._tableView.frame.size.height
//            weakSelf.frame.size.height = weakSelf.frame.size.height - h
//            weakSelf._tableView.frame.size.height = 0.0
//        })
    }
    
}

/********************************************************************************/
/*                                                                              */
/*                            简单的下拉文本框单元格                                */
/*                                                                              */
/********************************************************************************/

private class SimpleDropBoxCell: UITableViewCell {
    
    private var imgView: UIImageView!
    private var label: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        
        // 选中后右边显示一个“勾选”符号
//        let selectedView = UIImageView(image: UIImage(named: "check"))
//        selectedView.contentMode = .right
//        selectedBackgroundView = selectedView
        
        // 左边图标
        imgView = UIImageView(frame: .zero)
        imgView.contentMode = .scaleAspectFit
        self.addSubview(imgView)
        
        // 文字标题
        label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(label)
    }
    
    func setModel(text: String, img: UIImage?) {
        imgView.image = img
        label.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgView.frame = CGRect(x: 10, y: 12, width: 20, height: 20)
        if (imgView.image == nil) {
            imgView.frame = .zero
        }
        label.frame = CGRect(x: imgView.frame.maxX + 10, y: 0, width: self.frame.width - 80, height: 44)
        selectedBackgroundView?.frame = CGRect(x: 0, y: 0, width: frame.width - 10, height: 44)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//extension DropBoxTextField: UIGestureRecognizerDelegate {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if NSStringFromClass((touch.view?.classForCoder)!) == "UITableViewCellContentView" {
//            return false
//        }
//        return true
//    }
//}
