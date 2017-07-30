//
//  VisualEffect.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/30.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class VisualEffect: UIVisualEffectView {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
    }


}
