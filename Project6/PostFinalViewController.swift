//
//  PostFinalViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/08/04.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage
import RSKPlaceholderTextView
import OnOffButton

class PostFinalViewController: UIViewController,UINavigationControllerDelegate,UITextViewDelegate {
    
    
    //データ引き継ぎ
    var postItemName = String()
    var postItemCategory = String()
    var itemImage = UIImageView()
    var itemUrl: String?
    
    
    //
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var postButton: ZFRippleButton!
    @IBOutlet weak var usageTextBox: RSKPlaceholderTextView!
    @IBOutlet weak var onButton: OnOffButton!
    @IBOutlet weak var ThanksLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    var mainBool = false
    var profileBool = false
    
    
    //プロフィール画像
    var profileImage = UIImageView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usageTextBox.delegate = self
        
        usageTextBox.returnKeyType = UIReturnKeyType.done

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //チェックボタン待機
        self.onButton.isHidden = true
        self.onButton.checked = false
        
        self.ThanksLabel.isHidden = true
        
        
    }
    
    @IBAction func postButtonDidTap(_ sender: Any) {
        
        if usageTextBox.text != "" && usageTextBox.text != nil {
            
            
           /////////////////////////////////
            
            showIndicator()
            
            //投稿開始
            
            let user = FIRAuth.auth()?.currentUser
            let photoURL = user?.photoURL
            let userName = user!.displayName
            
            
            let ref = FIRDatabase.database().reference()
            let uid = FIRAuth.auth()?.currentUser?.uid
            
            if itemUrl == nil || itemUrl == "" {
                
                var post: Dictionary<String, AnyObject> = [
                    
                    "category" : postItemCategory as AnyObject,
                    "name" : postItemName as AnyObject,
                    "linkURL" : "" as AnyObject,
                    "pvCount" : 0 as AnyObject,
                    "whatContent" : usageTextBox.text as AnyObject,
                    "userID" : uid as AnyObject,
                    "userName" : userName as AnyObject
                ]
                
                //ユーザープロフィール画像
                if photoURL == nil {
                    itemImage.image = UIImage(named: "drop")
                    self.profileBool = true
                } else {
                    
                    profileImage.af_setImage(withURL: photoURL!)
                    
                    let profileImgData = UIImageJPEGRepresentation(profileImage.image!, 0.2)
                    let metaData = FIRStorageMetadata()
                    metaData.contentType = "image/jpeg"
                    let proImgUid = NSUUID().uuidString
                    
                    
                    DispatchQueue.global().async {
                        
                        DataService.dataBase.REF_POST_IMAGES.child(proImgUid).put(profileImgData!, metadata: metaData) {
                            (metaData, error) in
                            
                            if error != nil {
                                print("画像のアップロードに失敗しました")
                            } else {
                                
                                print("画像のアップロードに成功しました")
                                //DBへ画像のURL飛ばす
                                let proDownloadURL = metaData?.downloadURL()?.absoluteString
                                
                                post["userProfileImage"] = proDownloadURL as AnyObject
                                self.profileBool = true
                            }
                        }
                        
                    }
                }
                
                
                //メイン写真投稿
                let mainImgData = UIImageJPEGRepresentation(itemImage.image!, 0.2)
                
                
                let metaData = FIRStorageMetadata()
                metaData.contentType = "image/jpeg"
                let mainImgUid = NSUUID().uuidString
                
                DispatchQueue.global().async {
                    
                    DataService.dataBase.REF_POST_IMAGES.child(mainImgUid).put(mainImgData!, metadata: metaData) {
                        (metaData, error) in
                        
                        if error != nil {
                            print("画像のアップロードに失敗しました")
                        } else {
                            self.mainBool = true
                            print("画像のアップロードに成功しました")
                            //DBへ画像のURL飛ばす
                            let firstDownloadURL = metaData?.downloadURL()?.absoluteString
                            
                            //メイン画像を追加
                            post["imageURL"] = firstDownloadURL as AnyObject
                            
                        }
                    }
                    
                }
                
                
                //非同期処理の完了を待ってから投稿
                wait( {self.profileBool == false} ) {
                    
                    self.wait( {self.mainBool == false} ) {
                        
                        print(self.mainBool)
                        print(self.profileBool)
                        
                        //DBに投稿
                        let firebasePost = DataService.dataBase.REF_POST.childByAutoId()
                        let key = firebasePost.key
                        print(key)
                        //let postKey = "\(key.substring(from: key.index(after: key.startIndex)))"
                        let postKey = "\(key)"
                        print(postKey)
                        
                        //postIDを追加
                        post["postID"] = postKey as AnyObject
                        
                        print(post)
                        firebasePost.setValue(post)
                        
                        
                        DispatchQueue.main.async {
                            
                            self.indicator.stopAnimating()
                        }
                        
                        
                        print("投稿を完了しました")
                        
                        //チェック以外のUIを隠す
                        self.usageTextBox.isHidden = true
                        self.postButton.isHidden = true
                        self.backButton.isHidden = true
                        
                        
                        //チェックつける
                        self.ThanksLabel.isHidden = false
                        self.infoLabel.isHidden = true
                        
                        self.onButton.isHidden = false
                        self.onButton.checked = true
                        
                        
                        
                        
                        
                        //チェックを確認してから遷移
                        self.wait( {self.onButton.checked == false} ) {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                self.performSegue(withIdentifier: "Done", sender: nil)
                            }
                            
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                
                
                
                
                
            } else {
                
                var post: Dictionary<String, AnyObject> = [
                    
                    "category" : postItemCategory as AnyObject,
                    "name" :  postItemName as AnyObject,
                    "linkURL" : itemUrl as AnyObject,
                    "pvCount" : 0 as AnyObject,
                    "whatContent" : usageTextBox.text as AnyObject,
                    "userID" : uid as AnyObject,
                    "userName" : userName as AnyObject
                ]
                
                //ユーザープロフィール画像
                if photoURL == nil {
                    profileImage.image = UIImage(named: "drop")
                    self.profileBool = true
                } else {
                    
                    profileImage.af_setImage(withURL: photoURL!)
                    
                    let profileImgData = UIImageJPEGRepresentation(profileImage.image!, 0.2)
                    let metaData = FIRStorageMetadata()
                    metaData.contentType = "image/jpeg"
                    let proImgUid = NSUUID().uuidString
                    
                    
                    DispatchQueue.global().async {
                        
                        DataService.dataBase.REF_POST_IMAGES.child(proImgUid).put(profileImgData!, metadata: metaData) {
                            (metaData, error) in
                            
                            if error != nil {
                                print("画像のアップロードに失敗しました")
                            } else {
                                
                                print("画像のアップロードに成功しました")
                                //DBへ画像のURL飛ばす
                                let proDownloadURL = metaData?.downloadURL()?.absoluteString
                                
                                post["userProfileImage"] = proDownloadURL as AnyObject
                                self.profileBool = true
                            }
                        }
                        
                    }
                }
                
                
                //メイン写真投稿
                let mainImgData = UIImageJPEGRepresentation(itemImage.image!, 0.2)
                
                
                let metaData = FIRStorageMetadata()
                metaData.contentType = "image/jpeg"
                let mainImgUid = NSUUID().uuidString
                
                DispatchQueue.global().async {
                    
                    DataService.dataBase.REF_POST_IMAGES.child(mainImgUid).put(mainImgData!, metadata: metaData) {
                        (metaData, error) in
                        
                        if error != nil {
                            print("画像のアップロードに失敗しました")
                        } else {
                            self.mainBool = true
                            print("画像のアップロードに成功しました")
                            //DBへ画像のURL飛ばす
                            let firstDownloadURL = metaData?.downloadURL()?.absoluteString
                            
                            //メイン画像を追加
                            post["imageURL"] = firstDownloadURL as AnyObject
                            
                        }
                    }
                    
                }
                
                
                //非同期処理の完了を待ってから投稿
                wait( {self.profileBool == false} ) {
                    
                    self.wait( {self.mainBool == false} ) {
                        
                        print(self.mainBool)
                        print(self.profileBool)
                        
                        //DBに投稿
                        let firebasePost = DataService.dataBase.REF_POST.childByAutoId()
                        let key = firebasePost.key
                        let keyvalue = ("\(key)")
                        
                        //postIDを追加
                        post["postID"] = keyvalue as AnyObject
                        
                        print(post)
                        
                        firebasePost.setValue(post)
                        
                        DispatchQueue.main.async {
                            
                            self.indicator.stopAnimating()
                        }
                        
                        
                        
                        //チェック以外のUIを隠す
                        self.usageTextBox.isHidden = true
                        self.postButton.isHidden = true
                        self.backButton.isHidden = true
                        
                        
                        
                        //チェックつける
                        self.ThanksLabel.isHidden = false
                        self.infoLabel.isHidden = true
                        self.onButton.isHidden = false
                        self.onButton.checked = true
                        
                        
                        //チェックを確認してから遷移
                        self.wait( {self.onButton.checked == false} ) {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                self.performSegue(withIdentifier: "Done", sender: nil)
                            }
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                }
            }
            
            
            
            
            
            
            
            
            
        } else {
            
            let alertViewControler = UIAlertController(title: "エラーがあります", message: "必要なフィールドを埋めてください", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertViewControler.addAction(okAction)
            self.present(alertViewControler, animated: true, completion: nil)
            
        }
        
    }
    
        
        
        ///////////////////////////////////////
                
   
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        return true
    }
            
            
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
            
            
            
        
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    let indicator = UIActivityIndicatorView()
    
    func showIndicator() {
        
        indicator.activityIndicatorViewStyle = .whiteLarge
        
        indicator.center = self.view.center
        
        indicator.color = UIColor.rgb(r: 31, g: 158, b: 187, alpha: 1)
        
        indicator.hidesWhenStopped = true
        
        self.view.addSubview(indicator)
        
        self.view.bringSubview(toFront: indicator)
        
        indicator.startAnimating()
        
        
        
        
    }
    
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
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
