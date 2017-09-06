//
//  CardDesign.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/02.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class CardDesign: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.7).cgColor
        
        layer.shadowOpacity = 0.9
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    
    }


}
