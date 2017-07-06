//
//  OneTableViewCell.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/05.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import FirebaseStorage

class OneTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var oneImage: UIImageView!
    @IBOutlet weak var oneTItle: UILabel!
    @IBOutlet weak var userImage: ProfileImage!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var numsOfLikes: UILabel!
    @IBOutlet weak var oneContent: UILabel!
    @IBOutlet weak var onebgCard: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.layer.shadowColor = UIColor(red: 255.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.7).cgColor
        
        
        

        
        onebgCard.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        onebgCard.layer.cornerRadius = 3.0
        onebgCard.layer.masksToBounds = false
        
        
        
        
        

        
        
    }
    
    
    var post: Post!

    func configureCell(post: Post, img: UIImage? = nil) {
        
        
        self.post = post
        
        self.oneTItle.text = "\(post.name)"
        self.numsOfLikes.text = "\(post.pvCount)"
        self.oneContent.text = "\(post.whatContent)"
        
        if img != nil {
            
            self.oneImage.image = img
            
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
                            self.oneImage.image = img
                            OneViewController.imageCache.setObject(img, forKey: post.imageURL as NSString)
                        }
                    }
                }
            })
        }
        
    }
    
    
    
}
