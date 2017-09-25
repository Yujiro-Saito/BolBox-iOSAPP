//
//  FeedTableViewCell.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/10.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    //Image
    @IBOutlet weak var oneLoveButton: UIButton!
    
    
    
    @IBOutlet weak var oneCloseButton: UIButton!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var userImage: ProfileImage!
    
    @IBOutlet weak var userName: UILabel!
    
    
    @IBOutlet weak var cardDesi: UIView!
    
    
    
    
    //Link
    @IBOutlet weak var linkImage: ProfileImage!
    
    @IBOutlet weak var linkName: UILabel!
    
    @IBOutlet weak var linkButton: UIButton!
    
    @IBOutlet weak var linkFirstLabel: UILabel!
    
    @IBOutlet weak var linkSecondLabel: UILabel!
    @IBOutlet weak var linkLoveButton: UIButton!
    
    
    
    //Four items
    @IBOutlet weak var fourView: UIView!
    
    @IBOutlet weak var fourLoveButton: UIButton!
    
    @IBOutlet weak var fourCloseButton: UIButton!
    
    @IBOutlet weak var fourImage: UIImageView!
    @IBOutlet weak var fourProfileImage: UIImageView!
    
    @IBOutlet weak var fourItemLabel: UILabel!
    
    @IBOutlet weak var fouruserName: UILabel!
    
    @IBOutlet weak var folderName: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let mScreenSize = UIScreen.main.bounds
        let mSeparatorHeight = CGFloat(15.0)
        let mAddSeparator = UIView.init(frame: CGRect(x: 0, y: self.frame.size.height - mSeparatorHeight, width: mScreenSize.width, height: mSeparatorHeight))
        mAddSeparator.backgroundColor = UIColor.color(53, green: 70, blue: 92, alpha: 1)
        self.addSubview(mAddSeparator)
        
        
    }
}
