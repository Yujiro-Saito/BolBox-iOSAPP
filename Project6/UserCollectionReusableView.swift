//
//  UserCollectionReusableView.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/08/31.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase


class UserCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var userImage: ProfileImage!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    
    
        
}
