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
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var unLikeButton: UIButton!
    @IBOutlet weak var numOfLikes: UILabel!
    
    var cellType = Int()
    let currentUserName = FIRAuth.auth()?.currentUser?.displayName
    
    var linkURL: String!
    var imageURL: String!
    var pvCount = Int()
    var readCount = Int()
    var postID = String()
    var peopleWhoLike = Dictionary<String, AnyObject>()
    var dbCheck = false
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.unLikeButton.isHidden = true
        self.unLikeButton.isEnabled = false
        
        
        
        
        print(postID)
        print(currentUserName!)
        
        
        
    }
    
    
    
    
    
    
    var post: Post!
    
    func configureCell(post: Post, img: UIImage? = nil) {
        
        
        self.post = post
        
        self.featureImage.af_setImage(withURL: URL(string: imageURL)!)
        
        self.featureTitle.text = "\(post.name)"
        self.featureContent.text = "\(post.whatContent)"
        self.numOfLikes.text = "\(post.pvCount)"
        
        
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
    
    
    
    //いいねが押された時
    @IBAction func likeButtonDidTap(_ sender: Any) {
        
        
        
        //read1
        if self.cellType == 1 {
            //もっと読むの1
            
            
            
            let alertView = SCLAlertView()
            //ボタンの追加
            
            
            alertView.addButton("いいね!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "いいね!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("first/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("first/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
            }
            alertView.addButton("かっこいい!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "かっこいい!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("first/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("first/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
            }
            alertView.addButton("おもしろい!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "おもしろい!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("first/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("first/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            alertView.addButton("おしゃれ!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "おしゃれ!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("first/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("first/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            alertView.addButton("ありがとう!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "ありがとう!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("first/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("first/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            
            
            alertView.showEdit("", subTitle: "", closeButtonTitle: "キャンセル", duration: 0, colorStyle: 1605527, colorTextButton: 16777215,  animationStyle: .bottomToTop)
            
            
            
            
        }
        
        //read2
        
        else if self.cellType == 2 {
            
            
            
            
            let alertView = SCLAlertView()
            //ボタンの追加
            
            
            alertView.addButton("いいね!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "いいね!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("second/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("second/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
            }
            alertView.addButton("かっこいい!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "かっこいい!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("second/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("second/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
            }
            alertView.addButton("おもしろい!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "おもしろい!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("second/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("second/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            alertView.addButton("おしゃれ!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "おしゃれ!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("second/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("second/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            alertView.addButton("ありがとう!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "ありがとう!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("second/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("second/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            
            
            alertView.showEdit("", subTitle: "", closeButtonTitle: "キャンセル", duration: 0, colorStyle: 1605527, colorTextButton: 16777215,  animationStyle: .bottomToTop)
            
            
            
            
            
            
            
            
            
        } else if self.cellType == 3 {
            
            
            let alertView = SCLAlertView()
            //ボタンの追加
            
            
            alertView.addButton("いいね!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "いいね!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("third/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("third/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
            }
            alertView.addButton("かっこいい!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "かっこいい!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("third/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("third/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
            }
            alertView.addButton("おもしろい!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "おもしろい!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("third/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("third/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            alertView.addButton("おしゃれ!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "おしゃれ!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("third/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("third/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            alertView.addButton("ありがとう!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "ありがとう!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("third/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("third/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            
            
            alertView.showEdit("", subTitle: "", closeButtonTitle: "キャンセル", duration: 0, colorStyle: 1605527, colorTextButton: 16777215,  animationStyle: .bottomToTop)
            
            
            

            
                   }
        
        
        else if self.cellType == 4 {
            
            
            
            
            
            let alertView = SCLAlertView()
            //ボタンの追加
            
            
            alertView.addButton("いいね!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "いいね!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("fourth/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("fourth/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
            }
            alertView.addButton("かっこいい!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "かっこいい!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("fourth/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("fourth/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
            }
            alertView.addButton("おもしろい!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "おもしろい!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("fourth/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("fourth/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            alertView.addButton("おしゃれ!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "おしゃれ!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("fourth/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("fourth/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            alertView.addButton("ありがとう!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "ありがとう!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("fourth/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("fourth/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            
            
            alertView.showEdit("", subTitle: "", closeButtonTitle: "キャンセル", duration: 0, colorStyle: 1605527, colorTextButton: 16777215,  animationStyle: .bottomToTop)
            
            
            
            
        }
        
        else if self.cellType == 5 {
            
            
            
            let alertView = SCLAlertView()
            //ボタンの追加
            
            
            alertView.addButton("いいね!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "いいね!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("fifth/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("fifth/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
            }
            alertView.addButton("かっこいい!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "かっこいい!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("fifth/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("fifth/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
            }
            alertView.addButton("おもしろい!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "おもしろい!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("fifth/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("fifth/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            alertView.addButton("おしゃれ!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "おしゃれ!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("fifth/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("fifth/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            alertView.addButton("ありがとう!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "ありがとう!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("fifth/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("fifth/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            
            
            alertView.showEdit("", subTitle: "", closeButtonTitle: "キャンセル", duration: 0, colorStyle: 1605527, colorTextButton: 16777215,  animationStyle: .bottomToTop)
            
            

            
            
            
            
            
                 }
        
        else if self.cellType == 6 {
            
            
            
            let alertView = SCLAlertView()
            //ボタンの追加
            
            
            alertView.addButton("いいね!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "いいね!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("featureOne/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("featureOne/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
            }
            alertView.addButton("かっこいい!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "かっこいい!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("featureOne/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("featureOne/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
            }
            alertView.addButton("おもしろい!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "おもしろい!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("featureOne/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("featureOne/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            alertView.addButton("おしゃれ!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "おしゃれ!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("featureOne/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("featureOne/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            alertView.addButton("ありがとう!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "ありがとう!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("featureOne/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("featureOne/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            
            
            alertView.showEdit("", subTitle: "", closeButtonTitle: "キャンセル", duration: 0, colorStyle: 1605527, colorTextButton: 16777215,  animationStyle: .bottomToTop)
            
            
            

            
            
            
        }
        
        else if self.cellType == 7 {
            
            let alertView = SCLAlertView()
            //ボタンの追加
            
            
            alertView.addButton("いいね!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "いいね!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("featureTwo/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("featureTwo/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
            }
            alertView.addButton("かっこいい!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "かっこいい!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("featureTwo/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("featureTwo/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
            }
            alertView.addButton("おもしろい!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "おもしろい!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("featureTwo/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("featureTwo/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            alertView.addButton("おしゃれ!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "おしゃれ!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("featureTwo/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("featureTwo/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            alertView.addButton("ありがとう!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "ありがとう!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("featureTwo/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("featureTwo/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            
            
            alertView.showEdit("", subTitle: "", closeButtonTitle: "キャンセル", duration: 0, colorStyle: 1605527, colorTextButton: 16777215,  animationStyle: .bottomToTop)
            
            
            
            
        }
        
        
        else if self.cellType == 8 {
            
            let alertView = SCLAlertView()
            //ボタンの追加
            
            
            alertView.addButton("いいね!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "いいね!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("featureThree/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("featureThree/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
            }
            alertView.addButton("かっこいい!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "かっこいい!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("featureThree/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("featureThree/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
            }
            alertView.addButton("おもしろい!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "おもしろい!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("featureThree/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("featureThree/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            alertView.addButton("おしゃれ!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "おしゃれ!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("featureThree/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("featureThree/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            alertView.addButton("ありがとう!") {
                //タップ時の処理
                self.pvCount += 1
                
                
                //DB いいね数
                let likesCount = ["pvCount": self.pvCount]
                
                let userData = [ "userName" : self.currentUserName, "userReact" : "ありがとう!"]
                
                
                
                //いいね数を更新
                DataService.dataBase.REF_BASE.child("featureThree/\(self.postID)").updateChildValues(likesCount)
                
                //いいねつけた人登録
                DataService.dataBase.REF_BASE.child("featureThree/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").setValue(userData)
                
                
                
                self.likesButton.isHidden = true
                self.likesButton.isEnabled = false
                
                self.unLikeButton.isHidden = false
                self.unLikeButton.isEnabled = true
                
                
                
            }
            
            
            alertView.showEdit("", subTitle: "", closeButtonTitle: "キャンセル", duration: 0, colorStyle: 1605527, colorTextButton: 16777215,  animationStyle: .bottomToTop)
            
            
            
            
        }

        
        
        
        
    }
    
    
    
    //いいねが取り消されたとき
    
    @IBAction func dislikeButtonDidTap(_ sender: Any) {
        
        
        
        if self.cellType == 1 {
            //もっと読むの1
            self.pvCount -= 1
            
            //DBを更新
            let likesCount = ["pvCount": self.pvCount]
            let userData = [ "userName" : currentUserName]
            
            
            DispatchQueue.global().async {
                
                //いいねのデータを削除
                DataService.dataBase.REF_BASE.child("first/\(self.postID)").updateChildValues(likesCount)
                
                DataService.dataBase.REF_BASE.child("first/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").removeValue()
                
                
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
            
            
        } else if self.cellType == 2 {
            
            self.pvCount -= 1
            
            //DBを更新
            let likesCount = ["pvCount": self.pvCount]
            let userData = [ "userName" : currentUserName]
            
            
            DispatchQueue.global().async {
                
                //いいねのデータを削除
                DataService.dataBase.REF_BASE.child("second/\(self.postID)").updateChildValues(likesCount)
                
                DataService.dataBase.REF_BASE.child("second/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").removeValue()
                
                
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
        
        
        else if self.cellType == 3 {
            
            self.pvCount -= 1
            
            //DBを更新
            let likesCount = ["pvCount": self.pvCount]
            let userData = [ "userName" : currentUserName]
            
            
            DispatchQueue.global().async {
                
                //いいねのデータを削除
                DataService.dataBase.REF_BASE.child("third/\(self.postID)").updateChildValues(likesCount)
                
                DataService.dataBase.REF_BASE.child("third/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").removeValue()
                
                
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
        
        
        else if self.cellType == 4 {
            
            self.pvCount -= 1
            
            //DBを更新
            let likesCount = ["pvCount": self.pvCount]
            let userData = [ "userName" : currentUserName]
            
            
            DispatchQueue.global().async {
                
                //いいねのデータを削除
                DataService.dataBase.REF_BASE.child("fourth/\(self.postID)").updateChildValues(likesCount)
                
                DataService.dataBase.REF_BASE.child("fourth/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").removeValue()
                
                
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
        
        
        
        else if self.cellType == 5 {
            
            self.pvCount -= 1
            
            //DBを更新
            let likesCount = ["pvCount": self.pvCount]
            let userData = [ "userName" : currentUserName]
            
            
            DispatchQueue.global().async {
                
                //いいねのデータを削除
                DataService.dataBase.REF_BASE.child("fifth/\(self.postID)").updateChildValues(likesCount)
                
                DataService.dataBase.REF_BASE.child("fifth/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").removeValue()
                
                
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
        
        
        
        else if self.cellType == 6 {
            
            self.pvCount -= 1
            
            //DBを更新
            let likesCount = ["pvCount": self.pvCount]
            let userData = [ "userName" : currentUserName]
            
            
            DispatchQueue.global().async {
                
                //いいねのデータを削除
                DataService.dataBase.REF_BASE.child("featureOne/\(self.postID)").updateChildValues(likesCount)
                
                DataService.dataBase.REF_BASE.child("featureOne/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").removeValue()
                
                
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

        
        
        else if self.cellType == 7 {
            
            self.pvCount -= 1
            
            //DBを更新
            let likesCount = ["pvCount": self.pvCount]
            let userData = [ "userName" : currentUserName]
            
            
            DispatchQueue.global().async {
                
                //いいねのデータを削除
                DataService.dataBase.REF_BASE.child("featureTwo/\(self.postID)").updateChildValues(likesCount)
                
                DataService.dataBase.REF_BASE.child("featureTwo/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").removeValue()
                
                
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
        
        
        
        
        
        
        
        
        
        else if self.cellType == 8 {
            
            self.pvCount -= 1
            
            //DBを更新
            let likesCount = ["pvCount": self.pvCount]
            let userData = [ "userName" : currentUserName]
            
            
            DispatchQueue.global().async {
                
                //いいねのデータを削除
                DataService.dataBase.REF_BASE.child("featureThree/\(self.postID)").updateChildValues(likesCount)
                
                DataService.dataBase.REF_BASE.child("featureThree/\(self.postID)/peopleWhoLike/\(self.currentUserName!)").removeValue()
                
                
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
