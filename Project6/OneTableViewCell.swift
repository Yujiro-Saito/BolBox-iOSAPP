//
//  OneTableViewCell.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/05.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import AlamofireImage

class OneTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var oneImage: UIImageView!
    @IBOutlet weak var oneTItle: UILabel!
    @IBOutlet weak var userImage: ProfileImage!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var numsOfLikes: UILabel!
    @IBOutlet weak var oneContent: UILabel!
    @IBOutlet weak var onebgCard: UIView!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var unLikeButton: UIButton!
    @IBOutlet weak var cardView: UIViewDesign!
    
    
    
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.unLikeButton.isHidden = true
        self.unLikeButton.isEnabled = false
        
        self.layer.shadowColor = UIColor(red: 255.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.7).cgColor
        

      
        
        onebgCard.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        onebgCard.layer.cornerRadius = 3.0
        onebgCard.layer.masksToBounds = false
        
        
    }
    
    
    var post: Post!

    func configureCell(post: Post, img: UIImage? = nil) {
        
        
        
        self.post = post
        
        self.userImage.af_setImage(withURL: URL(string: userImageURL)!)
        self.userName.text = self.userProfileName
        
        self.oneTItle.text = "\(post.name)"
        self.numsOfLikes.text = "\(post.pvCount)"
        self.oneContent.text = "\(post.whatContent)"
        
        
        if img != nil {
            
            self.oneImage.image = img
            
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
                            self.oneImage.image = img
                            OneViewController.imageCache.setObject(img, forKey: post.imageURL as! NSString)
                        }
                    }
                }
            })
        }
 
    }
    
    
    //いいねが押された時
    @IBAction func likeButtonDidTap(_ sender: Any) {
        
        let photoLink = FIRAuth.auth()?.currentUser?.photoURL
        let userPhotoURL = String(describing: photoLink!)
        
        
        let alertView = SCLAlertView()
        //ボタンの追加
        
        
        alertView.addButton("いいね!") {
            //タップ時の処理
            self.pvCount += 1
            
            let currentUserName = FIRAuth.auth()?.currentUser?.displayName
            
            //DBを更新
            let likesCount = ["pvCount": self.pvCount]
            
            let userImageURL = ["imageURL" : self.imageURL]
            let userName = [self.postID : currentUserName]
            let peoples = currentUserName
            let userData = ["imageURL" : self.imageURL, self.postID : currentUserName, "userID" : self.userID, "postName" : self.oneTItle.text, "userReact" : "いいね!", "currentUserID" : FIRAuth.auth()?.currentUser?.uid, "userProfileURL" : userPhotoURL]
            
            //いいね数を更新
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)").updateChildValues(likesCount)
            
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)/peopleWhoLike/\(currentUserName!)").setValue(userData)
            
            self.likesButton.isHidden = true
            self.likesButton.isEnabled = false
            
            self.unLikeButton.isHidden = false
            self.unLikeButton.isEnabled = true
            
        }
        alertView.addButton("かっこいい!") {
            //タップ時の処理
            self.pvCount += 1
            
            let currentUserName = FIRAuth.auth()?.currentUser?.displayName
            
            //DBを更新
            let likesCount = ["pvCount": self.pvCount]
            
            let userImageURL = ["imageURL" : self.imageURL]
            let userName = [self.postID : currentUserName]
            let peoples = currentUserName
            let userData = ["imageURL" : self.imageURL, self.postID : currentUserName, "userID" : self.userID, "postName" : self.oneTItle.text, "userReact" : "かっこいい!", "currentUserID" : FIRAuth.auth()?.currentUser?.uid, "userProfileURL" : userPhotoURL]
            
            //いいね数を更新
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)").updateChildValues(likesCount)
            
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)/peopleWhoLike/\(currentUserName!)").setValue(userData)
            
            self.likesButton.isHidden = true
            self.likesButton.isEnabled = false
            
            self.unLikeButton.isHidden = false
            self.unLikeButton.isEnabled = true
        }
        alertView.addButton("おもしろい!") {
            //タップ時の処理
            self.pvCount += 1
            
            let currentUserName = FIRAuth.auth()?.currentUser?.displayName
            
            //DBを更新
            let likesCount = ["pvCount": self.pvCount]
            
            let userImageURL = ["imageURL" : self.imageURL]
            let userName = [self.postID : currentUserName]
            let peoples = currentUserName
            let userData = ["imageURL" : self.imageURL, self.postID : currentUserName, "userID" : self.userID, "postName" : self.oneTItle.text, "userReact" : "おもしろい!", "currentUserID" : FIRAuth.auth()?.currentUser?.uid, "userProfileURL" : userPhotoURL]
            
            //いいね数を更新
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)").updateChildValues(likesCount)
            
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)/peopleWhoLike/\(currentUserName!)").setValue(userData)
            
            self.likesButton.isHidden = true
            self.likesButton.isEnabled = false
            
            self.unLikeButton.isHidden = false
            self.unLikeButton.isEnabled = true
        }
        alertView.addButton("おしゃれ!") {
            //タップ時の処理
            self.pvCount += 1
            
            let currentUserName = FIRAuth.auth()?.currentUser?.displayName
            
            
            //DBを更新
            let likesCount = ["pvCount": self.pvCount]
            
            let userImageURL = ["imageURL" : self.imageURL]
            let userName = [self.postID : currentUserName]
            let peoples = currentUserName
            let userData = ["imageURL" : self.imageURL, self.postID : currentUserName, "userID" : self.userID, "postName" : self.oneTItle.text, "userReact" : "おしゃれ!", "currentUserID" : FIRAuth.auth()?.currentUser?.uid, "userProfileURL" : userPhotoURL]
            
            //いいね数を更新
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)").updateChildValues(likesCount)
            
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)/peopleWhoLike/\(currentUserName!)").setValue(userData)
            
            self.likesButton.isHidden = true
            self.likesButton.isEnabled = false
            
            self.unLikeButton.isHidden = false
            self.unLikeButton.isEnabled = true
        }
        alertView.addButton("ありがとう!") {
            //タップ時の処理
            self.pvCount += 1
            
            let currentUserName = FIRAuth.auth()?.currentUser?.displayName
            let photoLink = FIRAuth.auth()?.currentUser?.photoURL
            let userPhotoURL = String(describing: photoLink)
            
            //DBを更新
            let likesCount = ["pvCount": self.pvCount]
            
            let userImageURL = ["imageURL" : self.imageURL]
            let userName = [self.postID : currentUserName]
            let peoples = currentUserName
            let userData = ["imageURL" : self.imageURL, self.postID : currentUserName, "userID" : self.userID, "postName" : self.oneTItle.text, "userReact" : "ありがとう!", "currentUserID" : FIRAuth.auth()?.currentUser?.uid, "userProfileURL" : userPhotoURL]
            
            //いいね数を更新
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)").updateChildValues(likesCount)
            
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)/peopleWhoLike/\(currentUserName!)").setValue(userData)
            
            self.likesButton.isHidden = true
            self.likesButton.isEnabled = false
            
            self.unLikeButton.isHidden = false
            self.unLikeButton.isEnabled = true
        }
        
        
        alertView.showEdit("", subTitle: "", closeButtonTitle: "キャンセル", duration: 0, colorStyle: 1605527, colorTextButton: 16777215,  animationStyle: .bottomToTop)
        
        
        
        

        
        
        
        
        
}
    
    
    //いいねが取り消されたとき
    @IBAction func dislikeDidTap(_ sender: Any) {
        
        var currentUserName = FIRAuth.auth()?.currentUser?.displayName
        
        self.pvCount -= 1
        
        //DBを更新
        let likesCount = ["pvCount": self.pvCount]
        let userImageURL = ["imageURL" : self.imageURL]
        let userName = [postID : currentUserName]
        let peoples = currentUserName
        let userData = ["imageURL" : self.imageURL, postID : currentUserName, "userID" : self.userID, "postName" : oneTItle.text]
        
        
        DispatchQueue.global().async {

        
            //いいねのデータを削除
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)").updateChildValues(likesCount)
            
            DataService.dataBase.REF_BASE.child("posts/\(self.postID)/peopleWhoLike/\(currentUserName!)").removeValue()
            
            self.dbCheck = true
            
        
        }
        
        
        
        
        
        
        //DB削除を確認後の処理
        
        self.wait( {self.dbCheck == false} ) {
            
            self.likesButton.isHidden = false
            self.likesButton.isEnabled = true
            
            
            self.unLikeButton.isHidden = true
            self.unLikeButton.isEnabled = false
            
            self.dbCheck = false
            
        }
        
        
        
        
        
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

    
 

}





