//
//  OCHomeTitleCell.swift
//  OpenClasses
//
//  Created by mike on 15/6/5.
//  Copyright (c) 2015年 mike. All rights reserved.
//

import UIKit

class OCHomeTitleCell: UITableViewCell {

    @IBOutlet weak var myImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        myImageView.setImageWithURL("http://a.hiphotos.baidu.com/image/pic/item/8cb1cb13495409234dc259769058d109b3de490a.jpg")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
