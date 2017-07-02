//
//  PopularMoreReadCollectionViewCell.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/31.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//
/*
import UIKit
import FirebaseStorage

class PopularMoreReadCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var starNum: UILabel!
    @IBOutlet weak var itemTitle: UILabel!
    
    
    var post: Post!
    
    func configureCell(post: Post, img: UIImage? = nil) {
        
        self.post = post
        
        self.starNum.text = "\(post.pvCount)"
        self.itemTitle.text = "\(post.name)"
        
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
                            PopularMoreReadCollectionViewController.imageCache.setObject(img, forKey: post.imageURL as NSString)
                        }
                    }
                }
                
                
            })
            
            
        }
        
        
    }
    
    
}*/
