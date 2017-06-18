//
//  ProfileImage.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/17.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class ProfileImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
    }
    
    


}
