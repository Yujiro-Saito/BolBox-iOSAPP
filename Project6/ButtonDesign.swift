//
//  ButtonDesign.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/24.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class ButtonDesign: UIButton {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        layer.cornerRadius = 5
        
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 0.5
        
        
    }
}
