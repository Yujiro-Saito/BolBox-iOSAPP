//
//  SectionHeaderCollectionReusableView.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/30.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class SectionHeaderCollectionReusableView: UICollectionReusableView {

    
    @IBOutlet weak var userProfileName: UILabel!
    
    @IBOutlet weak var profImage: ProfileImage!
    
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var separator: UISegmentedControl!
    
    
}
