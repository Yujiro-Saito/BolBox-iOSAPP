//
//  FriendsTableViewCell.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/02.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userImage: ProfileImage!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var profileLabel: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
}
