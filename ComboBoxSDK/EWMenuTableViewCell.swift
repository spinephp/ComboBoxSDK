//
//  EWMenuTableViewCell.swift
//  SeeneLevel
//
//  Created by 刘兴明 on 2021/1/21.
//  Copyright © 2021 刘兴明. All rights reserved.
//

import Foundation
import UIKit

/// imageView左侧留白
let kLineXY: CGFloat = 13.0
/// imageView宽度
let kImageWidth: CGFloat = 18.0
/// imageView与label之间留白
let kImgLabelWidth: CGFloat = 10.0

public class EWMenuTableViewCell: UITableViewCell {
    static let identifier = "EWMenuTableViewCell"

    private lazy var iconImg: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: kLineXY, y: (itemHeight - kImageWidth)/2, width: kImageWidth, height: kImageWidth))
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    public lazy var conLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 42, y: 0, width: itemWidth - 57, height: itemHeight))
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        drawMyView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func drawMyView() {
        self.addSubview(iconImg)
        self.addSubview(conLabel)
    }
    public func setContentBy(funTitles: ((Int) -> (String, UIImage?))!, row: Int) {
        if funTitles(row).1 == nil {
            self.iconImg.isHidden = true
            self.conLabel.frame = CGRect(x: kLineXY, y: 0, width: itemWidth - kLineXY * 2, height: itemHeight)
        } else {
            self.iconImg.isHidden = false
            self.conLabel.frame = CGRect(x: self.iconImg.frame.maxX + kImgLabelWidth, y: 0, width: itemWidth - kImgLabelWidth - kLineXY - kImageWidth - 15 , height: itemHeight)
            self.iconImg.image =  funTitles(row).1
        }
    }
}
