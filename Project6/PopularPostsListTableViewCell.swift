//
//  PopularPostsListTableViewCell.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/20.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase

class PopularPostsListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var starNum: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var itemWhatContent: UILabel!
    
    
    var post: Post!
    
    func configureCell(post: Post, img: UIImage? = nil) {
        
        self.post = post
        self.itemName.text = "\(post.name)"
        self.starNum.text = "\(post.pvCount)"
        self.itemWhatContent.text = "\(post.whatContent)"
        self.categoryName.text = "\(post.category)"
        
        if img != nil {
            
            self.itemImage.image = img
            
        }else {
            
            
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                
                if error != nil {
                    print("エラーがあります")
                    print(error?.localizedDescription)
                } else {
                    print("SUCCESS")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.itemImage.image = img
                            PopularPostsViewController.imageCache.setObject(img, forKey: post.imageURL as NSString)
                        }
                    }
                }
                
                
            })
            
            
            
            
            
            
            
        }
        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    

}
