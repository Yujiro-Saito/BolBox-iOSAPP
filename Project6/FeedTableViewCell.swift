//
//  FeedTableViewCell.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/10.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class FeedTableViewCell: UITableViewCell {
    
    
    
    //Common
    //@IBOutlet weak var favButton: FaveButton!
    @IBOutlet weak var folderImage: ProfileImage!
    
    @IBOutlet weak var videoPlayer: YTPlayerView!
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var folderName: UILabel!
    
    @IBOutlet weak var linkWeb: UIWebView!
    
   // @IBOutlet weak var userImage: ProfileImage!
    
    
    @IBOutlet weak var webViewView: UIView!
    
    
 
   // @IBOutlet weak var favNumLabel: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    
    @IBOutlet weak var userPrfileImage: ProfileImage!
    
    
    @IBOutlet weak var bigImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    @IBOutlet weak var textBox: UITextView!
   

    override func awakeFromNib() {
        super.awakeFromNib()
        //self.favButton.delegate = self
        
        /*
        let mScreenSize = UIScreen.main.bounds
        let mSeparatorHeight = CGFloat(15.0)
        let mAddSeparator = UIView.init(frame: CGRect(x: 0, y: self.frame.size.height - mSeparatorHeight, width: mScreenSize.width, height: mSeparatorHeight))
        mAddSeparator.backgroundColor = UIColor.color(53, green: 70, blue: 92, alpha: 1)
        self.addSubview(mAddSeparator)
 
 */
        
        
    }
}
