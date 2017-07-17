//
//  UserProfileTableViewCell.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/16.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase

class UserProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postName: UILabel!
    @IBOutlet weak var numOfLikes: UILabel!
    @IBOutlet weak var postContent: UILabel!
    
    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    func configureCell(post: Post, img: UIImage? = nil) {
        
        
        
            
            self.post = post
            self.postName.text = "\(post.name)"
            self.numOfLikes.text = "\(post.pvCount)"
            self.postContent.text = "\(post.whatContent)"
            
            
            
            if img != nil {
                
                self.postImage.image = img
                
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
                                self.postImage.image = img
                                UserProfileViewController.imageCache.setObject(img, forKey: post.imageURL as NSString)
                            }
                        }
                    }
                })
                
                
                
            }
            
            
        
        
        
        
        
    }
    

    
    
    
    
    
    

    
}
