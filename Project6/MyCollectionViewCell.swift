//
//  MyCollectionViewCell.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/08/27.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 3.0
        self.layer.masksToBounds = true
    }
    
    
    
    
    
}
