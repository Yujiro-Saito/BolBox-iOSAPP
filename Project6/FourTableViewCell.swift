//
//  FourTableViewCell.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/07.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase

class FourTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellContent: UILabel!
    @IBOutlet weak var cellTitle: UILabel!
    
    @IBOutlet weak var cellUserImage: ProfileImage!
    @IBOutlet weak var cellUserName: UILabel!
    
    @IBOutlet weak var cellNumLikes: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    
    var postID = String()
    var category: String!
    var linkURL: String!
    var imageURL: String!
    var pvCount = Int()
    

    
    
    @IBAction func likeButtonDidTap(_ sender: Any) {
        
        self.likeButton.isEnabled = false
        
        self.pvCount += 1
        
        
        print(self.postID)
        print(self.pvCount)
        
        var currentUserName = FIRAuth.auth()?.currentUser?.displayName
        
        
        //DBを更新
        let data = ["pvCount": self.pvCount]
        let peoples = currentUserName
        
        
        DataService.dataBase.REF_BASE.child("posts/-\(self.postID)").updateChildValues(data)
        DataService.dataBase.REF_BASE.child("posts/-\(self.postID)/peopleWhoLike/\(currentUserName!)").setValue(peoples)
        
        
        self.likeButton.isEnabled = true
        
        
        
        
        
        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var post: Post!
    
    func configureCell(post: Post, img: UIImage? = nil) {
        
        
        self.post = post
        
        self.cellTitle.text = "\(post.name)"
        self.cellNumLikes.text = "\(post.pvCount)"
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
                    print("No Error")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.cellImage.image = img
                            FourViewController.imageCache.setObject(img, forKey: post.imageURL as NSString)
                        }
                    }
                }
            })
        }
        
    }
    
    
    
}
