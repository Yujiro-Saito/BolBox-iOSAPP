//
//  CategorysTableViewCell.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/03.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import FirebaseStorage


class CategorysTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemStarNum: UILabel!
    @IBOutlet weak var itemWhatContent: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    
    var post: Post!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        
        
        self.post = post
        self.itemName.text = "\(post.name)"
        self.itemStarNum.text = "\(post.pvCount)"
        self.itemWhatContent.text = "\(post.whatContent)"
        
        if img != nil {
            
            self.itemImage.image = img
            
        } else {
            
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
                            CategoryTableViewController.imageCache.setObject(img, forKey: post.imageURL as NSString)
                        }
                    }
                }
            })
        }
    }

}
