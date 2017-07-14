//
//  ThreeTableViewCell.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/07.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import AlamofireImage


class ThreeTableViewCell: UITableViewCell {
    
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
    var userID = String()
    var userImageURL = String()
    var userProfileName = String()


    
    
    
    @IBAction func likeButtonDiTap(_ sender: Any) {
        
        self.likeButton.isEnabled = false
        
        self.pvCount += 1
        
        
        print(self.postID)
        print(self.pvCount)
        
        var currentUserName = FIRAuth.auth()?.currentUser?.displayName
        
        
        //DBを更新
        let likesCount = ["pvCount": self.pvCount]
        let userImageURL = ["imageURL" : self.imageURL]
        let userName = [postID : currentUserName]
        let peoples = currentUserName
        let userData = ["imageURL" : self.imageURL, postID : currentUserName, "userID" : self.userID, "postName" : cellTitle.text]
        
        //いいね数を更新
        DataService.dataBase.REF_BASE.child("posts/-\(self.postID)").updateChildValues(likesCount)
        //いいねを押した人の一覧に追加
        //DataService.dataBase.REF_BASE.child("posts/-\(self.postID)/peopleWhoLike/\(currentUserName!)").setValue(peoples)
        //いいねを押した人　そのImageURLを投稿
        //DataService.dataBase.REF_BASE.child("posts/-\(self.postID)/peopleWhoLike/\(currentUserName!)").setValue(userImageURL)
        
        DataService.dataBase.REF_BASE.child("posts/-\(self.postID)/peopleWhoLike/\(currentUserName!)").setValue(userData)
        
        
        self.likeButton.isEnabled = true
        

    }
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var post: Post!
    
    func configureCell(post: Post, img: UIImage? = nil) {
        
        
        self.post = post
        
        self.cellUserImage.af_setImage(withURL: URL(string: userImageURL)!)
        self.cellUserName.text = self.userProfileName
        
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
                            ThreeViewController.imageCache.setObject(img, forKey: post.imageURL as NSString)
                        }
                    }
                }
            })
        }
        
    }
    
    
    
}
