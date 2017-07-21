
//
//  SecondCollectionViewCell.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/02.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import FirebaseStorage


class SecondCollectionViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellContent: UILabel!
    
    
    
    var post: Post!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 2, height: 2)
        
        self.clipsToBounds = false
    }
    
    
    func configureCell(post: Post, img: UIImage? = nil) {
        
        
        self.post = post
        self.cellTitle.text = "\(post.name)"
        self.cellContent.text = "\(post.whatContent)"
        
        if img != nil {
            
            self.cellImage.image = img
            
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
                            self.cellImage.image = img
                            BaseViewController.imageCache.setObject(img, forKey: post.imageURL as! NSString)
                        }
                    }
                }
                
                
            })
            
            
            
        }
        
        
        
    }
    
    
}
