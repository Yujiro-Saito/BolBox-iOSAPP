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
import SCLAlertView

class ThreeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var cellContent: UILabel!
    
    @IBOutlet weak var cellTitle: UILabel!
    
    @IBOutlet weak var cellUserImage: ProfileImage!
    
    @IBOutlet weak var cellUserName: UILabel!
    @IBOutlet weak var cellNumLikes: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    
    
    
    
    var postID = String()
    var category: String!
    var linkURL: String!
    var imageURL: String!
    var pvCount = Int()
    var userID = String()
    var userImageURL = String()
    var userProfileName = String()
    var peopleWhoLike = Dictionary<String, AnyObject>()
    var dbCheck = false


    
    
    
    @IBAction func likeButtonDiTap(_ sender: Any) {
        
        
        
        //データを削除
        var currentUserName = FIRAuth.auth()?.currentUser?.displayName
        
        self.pvCount -= 1
        
        
        //DBを更新
        let likesCount = ["pvCount": self.pvCount]
        let userImageURL = ["imageURL" : self.imageURL]
        let userName = [postID : currentUserName]
        let peoples = currentUserName
        let userData = ["imageURL" : self.imageURL, postID : currentUserName, "userID" : self.userID, "postName" : cellTitle.text]
        
        
        DispatchQueue.global().async {
            
            //いいねのデータを削除
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)").updateChildValues(likesCount)
            
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)/peopleWhoLike/\(currentUserName!)").removeValue()
            
            self.dbCheck = true
            
            
            
            
            
        }
        
        //DB削除を確認後の処理
        
        self.wait( {self.dbCheck == false} ) {
            
            self.dislikeButton.isHidden = false
            self.dislikeButton.isEnabled = true
            
            
            self.likeButton.isHidden = true
            self.likeButton.isEnabled = false
            
            self.dbCheck = false
            
        }
        
        

    }
    
    
    @IBAction func dislikeButtonDidTap(_ sender: Any) {
        
        
        let alertView = SCLAlertView()
        //ボタンの追加
        
        
        alertView.addButton("いいね!") {
            //タップ時の処理
            self.pvCount += 1
            
            
            print(self.postID)
            print(self.pvCount)
            
            var currentUserName = FIRAuth.auth()?.currentUser?.displayName
            
            
            //DBを更新
            let likesCount = ["pvCount": self.pvCount]
            let userImageURL = ["imageURL" : self.imageURL]
            let userName = [self.postID : currentUserName]
            let peoples = currentUserName
            let userData = ["imageURL" : self.imageURL, self.postID : currentUserName, "userID" : self.userID, "postName" : self.cellTitle.text, "userReact" : "いいね!"]
            
            //いいね数を更新
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)").updateChildValues(likesCount)
            
            
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)/peopleWhoLike/\(currentUserName!)").setValue(userData)
            
            
            self.likeButton.isEnabled = true
            self.likeButton.isHidden = false
            
            self.dislikeButton.isHidden = true
            self.dislikeButton.isEnabled = false
            
        }
        alertView.addButton("かっこいい!") {
            //タップ時の処理
            self.pvCount += 1
            
            
            print(self.postID)
            print(self.pvCount)
            
            var currentUserName = FIRAuth.auth()?.currentUser?.displayName
            
            
            //DBを更新
            let likesCount = ["pvCount": self.pvCount]
            let userImageURL = ["imageURL" : self.imageURL]
            let userName = [self.postID : currentUserName]
            let peoples = currentUserName
            let userData = ["imageURL" : self.imageURL, self.postID : currentUserName, "userID" : self.userID, "postName" : self.cellTitle.text, "userReact" : "かっこいい!"]
            
            //いいね数を更新
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)").updateChildValues(likesCount)
            
            
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)/peopleWhoLike/\(currentUserName!)").setValue(userData)
            
            
            self.likeButton.isEnabled = true
            self.likeButton.isHidden = false
            
            self.dislikeButton.isHidden = true
            self.dislikeButton.isEnabled = false
            
        }
        alertView.addButton("おもしろい!") {
            //タップ時の処理
            self.pvCount += 1
            
            
            print(self.postID)
            print(self.pvCount)
            
            var currentUserName = FIRAuth.auth()?.currentUser?.displayName
            
            
            //DBを更新
            let likesCount = ["pvCount": self.pvCount]
            let userImageURL = ["imageURL" : self.imageURL]
            let userName = [self.postID : currentUserName]
            let peoples = currentUserName
            let userData = ["imageURL" : self.imageURL, self.postID : currentUserName, "userID" : self.userID, "postName" : self.cellTitle.text, "userReact" : "おもしろい!"]
            
            //いいね数を更新
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)").updateChildValues(likesCount)
            
            
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)/peopleWhoLike/\(currentUserName!)").setValue(userData)
            
            
            self.likeButton.isEnabled = true
            self.likeButton.isHidden = false
            
            self.dislikeButton.isHidden = true
            self.dislikeButton.isEnabled = false
        }
        alertView.addButton("おしゃれ!") {
            //タップ時の処理
            self.pvCount += 1
            
            
            print(self.postID)
            print(self.pvCount)
            
            var currentUserName = FIRAuth.auth()?.currentUser?.displayName
            
            
            //DBを更新
            let likesCount = ["pvCount": self.pvCount]
            let userImageURL = ["imageURL" : self.imageURL]
            let userName = [self.postID : currentUserName]
            let peoples = currentUserName
            let userData = ["imageURL" : self.imageURL, self.postID : currentUserName, "userID" : self.userID, "postName" : self.cellTitle.text, "userReact" : "おしゃれ!"]
            
            //いいね数を更新
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)").updateChildValues(likesCount)
            
            
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)/peopleWhoLike/\(currentUserName!)").setValue(userData)
            
            
            self.likeButton.isEnabled = true
            self.likeButton.isHidden = false
            
            self.dislikeButton.isHidden = true
            self.dislikeButton.isEnabled = false
        }
        alertView.addButton("ありがとう!") {
            //タップ時の処理
            self.pvCount += 1
            
            
            print(self.postID)
            print(self.pvCount)
            
            var currentUserName = FIRAuth.auth()?.currentUser?.displayName
            
            
            //DBを更新
            let likesCount = ["pvCount": self.pvCount]
            let userImageURL = ["imageURL" : self.imageURL]
            let userName = [self.postID : currentUserName]
            let peoples = currentUserName
            let userData = ["imageURL" : self.imageURL, self.postID : currentUserName, "userID" : self.userID, "postName" : self.cellTitle.text, "userReact" : "ありがとう!"]
            
            //いいね数を更新
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)").updateChildValues(likesCount)
            
            
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)/peopleWhoLike/\(currentUserName!)").setValue(userData)
            
            
            self.likeButton.isEnabled = true
            self.likeButton.isHidden = false
            
            self.dislikeButton.isHidden = true
            self.dislikeButton.isEnabled = false
        }
        
        
        alertView.showEdit("", subTitle: "", closeButtonTitle: "キャンセル", duration: 0, colorStyle: 1605527, colorTextButton: 16777215,  animationStyle: .bottomToTop)
        
        
        
        
        
    }
    
    
    
    func wait(_ waitContinuation: @escaping (()->Bool), compleation: @escaping (()->Void)) {
        var wait = waitContinuation()
        // 0.01秒周期で待機条件をクリアするまで待ちます。
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            while wait {
                DispatchQueue.main.async {
                    wait = waitContinuation()
                    semaphore.signal()
                }
                semaphore.wait()
                Thread.sleep(forTimeInterval: 0.01)
            }
            // 待機条件をクリアしたので通過後の処理を行います。
            DispatchQueue.main.async {
                compleation()
                
                
                
            }
        }
    }
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.likeButton.isHidden = true
        self.likeButton.isEnabled = false
    
    
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
                            ThreeViewController.imageCache.setObject(img, forKey: post.imageURL as! NSString)
                        }
                    }
                }
            })
        }
        
    }
    
    
    
}
