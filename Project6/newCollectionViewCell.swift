//
//  newCollectionViewCell.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/13.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import FirebaseStorage

class newCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var celImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    
    var post: Post!
    
    func configureCell(post: Post, img: UIImage? = nil) {
        
        
        self.post = post
        self.cellTitle.text = "\(post.name)"
        
        if img != nil {
            
            self.celImage.image = img
            
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
                            self.celImage.image = img
                            HomeViewController.imageCache.setObject(img, forKey: post.imageURL as NSString)
                        }
                    }
                }
                
                
            })
            
            
            
        }
        
        
        
    }
    
    
    
    
    
}
