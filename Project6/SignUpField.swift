//
//  SignUpField.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/13.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class SignUpField: UITextField {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
        self.leftViewMode = .always
        self.layer.cornerRadius = 5
        self.clearButtonMode = .always
        self.returnKeyType = .done
        
        
        
    }

    
}
