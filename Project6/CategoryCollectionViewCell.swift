//
//  CategoryCollectionViewCell.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/03.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import FirebaseStorage

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var starNum: UILabel!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    var post: Post!
    
    
    func configureCell(post: Post, img: UIImage? = nil) {
        
        self.post = post
        
        self.starNum.text = "\(post.pvCount)"
        self.itemTitle.text = "\(post.name)"
        
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
                            CategoryCollectionViewController.imageCache.setObject(img, forKey: post.imageURL as NSString)
                        }
                    }
                }
                
                
            })
            
        }
        
    }
    
    
}
