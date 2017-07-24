//
//  ImageDesign.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/24.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class ImageDesign: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 5
    }
}
