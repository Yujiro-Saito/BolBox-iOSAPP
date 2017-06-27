//
//  BaseTableViewCell.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/27.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import FirebaseStorage

class BaseTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postContent: UILabel!
    @IBOutlet weak var postUserName: UILabel!
    @IBOutlet weak var postUserImage: UIImageView!
    @IBOutlet weak var postFavourNum: UILabel!
    
    var post: Post!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configureCell(post: Post, img: UIImage? = nil) {
        
        
        self.post = post
        self.postTitle.text = "\(post.name)"
        self.postFavourNum.text = "\(post.pvCount)"
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
                            BaseViewController.imageCache.setObject(img, forKey: post.imageURL as NSString)
                        }
                    }
                }
            })
        }
        
    }
    

    
}
