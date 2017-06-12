//
//  signUpButtonDesign.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/12.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class signUpButtonDesign: UIButton {

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 0.7
        layer.backgroundColor = UIColor.clear.cgColor
        
        
    }
    
    
    
    
}
