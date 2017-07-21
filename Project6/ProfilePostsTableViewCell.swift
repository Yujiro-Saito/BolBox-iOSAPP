//
//  ProfilePostsTableViewCell.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/30.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase

class ProfilePostsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileStory: UILabel!
    @IBOutlet weak var profileNum: UILabel!
    
    
    var post: Post!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        
        
        if FIRAuth.auth()?.currentUser != nil {
            
            
            self.post = post
            self.profileName.text = "\(post.name)"
            self.profileNum.text = "\(post.pvCount)"
            self.profileStory.text = "\(post.whatContent)"
            
            
            
            if img != nil {
                
                self.profileImage.image = img
                
            } else {
                
                let ref = FIRStorage.storage().reference(forURL: post.imageURL)
                
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    
                    if error != nil {
                        print("エラーがあります")
                        print(error?.localizedDescription)
                    } else {
                        print("No Error")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.profileImage.image = img
                                AccountViewController.imageCache.setObject(img, forKey: post.imageURL as! NSString)
                            }
                        }
                    }
                })
                
                
                
            }
            
            
        }
        
        
        
        
    }

   

}
