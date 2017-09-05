//
//  ToysTableViewCell.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/04.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class ToysTableViewCell: UITableViewCell {
    
    @IBOutlet weak var toyCaption: UILabel!
    
    @IBOutlet weak var toyItem: UIImageView!
    
    @IBOutlet weak var toyURL: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let mScreenSize = UIScreen.main.bounds
        let mSeparatorHeight = CGFloat(15.0) 
        let mAddSeparator = UIView.init(frame: CGRect(x: 0, y: self.frame.size.height - mSeparatorHeight, width: mScreenSize.width, height: mSeparatorHeight))
        mAddSeparator.backgroundColor = UIColor.color(53, green: 70, blue: 92, alpha: 1)
        self.addSubview(mAddSeparator)
        
        
    }

  
}
