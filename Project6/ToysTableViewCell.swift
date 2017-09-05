//
//  ToysTableViewCell.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/04.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class ToysTableViewCell: UITableViewCell {
    
    @IBOutlet weak var toyCaption: UILabel!
    
    @IBOutlet weak var toyItem: UIImageView!
    
    @IBOutlet weak var toyURL: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

  
}
