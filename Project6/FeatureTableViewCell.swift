//
//  FeatureTableViewCell.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/20.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

class FeatureTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var featureImage: UIImageView!
    @IBOutlet weak var featureTitle: UILabel!
    @IBOutlet weak var featureContent: UILabel!
    
    
    var linkURL: String!
    var imageURL: String!
    var pvCount = Int()
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var post: Post!
    
    func configureCell(post: Post, img: UIImage? = nil) {
        
        
        self.post = post
        
        self.featureImage.af_setImage(withURL: URL(string: imageURL)!)
        
        self.featureTitle.text = "\(post.name)"
        self.featureContent.text = "\(post.whatContent)"
        
        
        if img != nil {
            
            self.featureImage.image = img
            
        } else {
            
            let imageURLs = post.imageURL
            
            
            
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                
                if error != nil {
                    print("エラーがあります")
                    print(error?.localizedDescription)
                } else {
                    print("No Error")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.featureImage.image = img
                            FeatureViewController.imageCache.setObject(img, forKey: post.imageURL as! NSString)
                        }
                    }
                }
            })
        }
        
    }
    

    

}
