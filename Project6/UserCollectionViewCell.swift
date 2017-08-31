//
//  UserCollectionViewCell.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/08/30.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 3.0
        self.layer.masksToBounds = true
    }
    
    
}
