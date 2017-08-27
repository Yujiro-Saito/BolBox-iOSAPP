//
//  SectionHeaderCollectionReusableView.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/30.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class SectionHeaderCollectionReusableView: UICollectionReusableView {

    
    @IBOutlet weak var userProfileImage: ProfileImage!
    @IBOutlet weak var userProfileName: UILabel!
    @IBOutlet weak var addCollectionButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    @IBAction func addCollectionDidTap(_ sender: Any) {
        print("add")
    }
    
    
    @IBAction func settingButtonDidTap(_ sender: Any) {
        print("setting")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userProfileImage.image = UIImage(named: "Sunset")
        userProfileName.text = "ユジロン"
        
        
    }
    
    
    
}
