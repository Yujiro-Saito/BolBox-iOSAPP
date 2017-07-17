//
//  StoryViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/23.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class StoryViewController: UIViewController,UITextViewDelegate {
    
    
    @IBOutlet weak var storyText: UITextView!
    
    
    //データ引き継ぎ用
    
    var detailImages: Array<UIImage?> = [UIImage]()
    var detailOne = UIImage()
    var name = String()
    var url = String()
    var categoryTitle = String()
    var usageText = String()
    var mainBool = false
    var firstBool = false
    var secondBool = false
    var thirdBool = false
    var profileBool = false
    
    
    //プロフィール画像
    var profileImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        storyText.delegate = self
        
        
        storyText.text = ""
        storyText.becomeFirstResponder()
        
      
            }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func PostButtonDidTap(_ sender: Any) {
        
        self.mainBool = false
        self.firstBool = false
        self.secondBool = false
        self.thirdBool = false
        
        let user = FIRAuth.auth()?.currentUser
        
        let photoURL = user?.photoURL
        let userName = user!.displayName
        
        if self.storyText.text == "" {
            
            let alertViewController = UIAlertController(title: "ストーリが空です", message:"思いを伝えよう", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertViewController.addAction(okAction)
            
            self.present(alertViewController, animated:true, completion:nil)
            
        }
        else  if storyText.text != "" {
            print("メディア投稿開始")
            
            
            let ref = FIRDatabase.database().reference()
            let uid = FIRAuth.auth()?.currentUser?.uid
            
                            
                var mediaPost: Dictionary<String, AnyObject> = [
                    
                    "category" : categoryTitle as AnyObject,
                    "name" : self.name as AnyObject,
                    "linkURL" : self.url as AnyObject,
                    "pvCount" : 0 as AnyObject,
                    "whatContent" : storyText.text as AnyObject,
                    "userID" : uid as AnyObject,
                    "userName" : userName! as AnyObject
                ]
            
            
            
            

                
                //詳細画像一枚のとき
                if detailImages.count == 1 {
                    
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
                                    
                                    mediaPost["userProfileImage"] = proDownloadURL as AnyObject
                                    self.profileBool = true
                                }
                            }
                            
                        }
                    }
                    
                    
                    
                    //メイン写真投稿
                    let mainImgData = UIImageJPEGRepresentation(detailOne, 0.2)
                    
                    
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
                                mediaPost["imageURL"] = firstDownloadURL as AnyObject
                                
                            }
                        }
                        
                    }
                    
                    
                    
                
                    
                    
                    
                    
                    
                   
                    
                    //詳細画像一枚追加処理
                    let oneUID = NSUUID().uuidString
                    let oneImgData = UIImageJPEGRepresentation(detailImages[0]!, 0.2)
                    
                    DispatchQueue.global().async {
                        
                        DataService.dataBase.REF_POST_IMAGES.child(oneUID).put(oneImgData!, metadata: metaData) {
                            (metaData, error) in
                            
                            if error != nil {
                                print("画像のアップロードに失敗しました")
                            } else {
                                print("画像のアップロードに成功しました")
                                self.firstBool = true
                                //DBへ画像のURL飛ばす
                                let oneDownloadURL = metaData?.downloadURL()?.absoluteString
                                
                                
                                mediaPost["detailImageOne"] = oneDownloadURL as AnyObject
                                
                                print(mediaPost)
                                
                            }
                        }

                    }
                  
                    
                    //非同期処理の完了を待ってから投稿
                    wait( {self.mainBool == false} ) {
                        
                        self.wait( {self.firstBool == false} ) {
                            
                            
                            self.wait( {self.profileBool == false} ) {
                                
                                print("二段階確認")
                                print(self.mainBool)
                                print(self.firstBool)
                                
                                //DBに投稿
                                let firebasePost = DataService.dataBase.REF_POST.childByAutoId()
                                
                                firebasePost.setValue(mediaPost)
                                print(mediaPost)
                                print("1枚の場合投稿を完了しました")
                                
                            }
                            
                                
                            
                                
                            
                            
                            
                            
                        }
                        
                    }
 
                    
                    
                    
                    
                }
                
              
                
                
                
                //詳細画像二枚のとき
                
                
                if detailImages.count == 2 {
                    
                
                        print("投稿開始")
                    
                    
                        let ref = FIRDatabase.database().reference()
                        let uid = FIRAuth.auth()?.currentUser?.uid
                    
                    
                    //メイン写真投稿処理
                    let mainImgData = UIImageJPEGRepresentation(self.detailOne, 0.2)
                    let metaData = FIRStorageMetadata()
                    metaData.contentType = "image/jpeg"
                    let secondImgUid = NSUUID().uuidString
                    
                    DispatchQueue.global().async {
                        DataService.dataBase.REF_POST_IMAGES.child(secondImgUid).put(mainImgData!, metadata: metaData) {
                            (metaData, error) in
                            
                            if error != nil {
                                print("画像のアップロードに失敗しました")
                            } else {
                                
                                self.mainBool = true
                                
                                print("画像のアップロードに成功しました")
                                //DBへ画像のURL飛ばす
                                let mainDownloadURL = metaData?.downloadURL()?.absoluteString
                                
                                //メイン画像を追加
                                mediaPost["imageURL"] = mainDownloadURL as AnyObject
                                print("メインを追加")
                                print(mediaPost)
                            }
                        }
                    }
                    
                    
                    
                    
                        
                        
                    
                        
                        //一枚目の投稿
                        let onesUID = NSUUID().uuidString
                        let onesImgData = UIImageJPEGRepresentation(self.detailImages[0]!, 0.2)
                    
                    DispatchQueue.global().async {
                        DataService.dataBase.REF_POST_IMAGES.child(onesUID).put(onesImgData!, metadata: metaData) {
                            (metaData, error) in
                            
                            if error != nil {
                                print("画像のアップロードに失敗しました")
                            } else {
                                self.firstBool = true
                                print("画像のアップロードに成功しました")
                                //DBへ画像のURL飛ばす
                                let oneDownloadURL = metaData?.downloadURL()?.absoluteString
                                
                                //一枚目を追加
                                mediaPost["detailImageOne"] = oneDownloadURL as AnyObject
                                print("一枚目を追加")
                                print(mediaPost)
                                
                                
                            }
                        }
                    }
                    
                    
                    
                        
                    
                    //二枚目の投稿
                    let twoUID = NSUUID().uuidString
                    let twoImgData = UIImageJPEGRepresentation(self.detailImages[1]!, 0.2)

                    
                    DispatchQueue.global().async {
                        
                        
                        DataService.dataBase.REF_POST_IMAGES.child(twoUID).put(twoImgData!, metadata: metaData) {
                            (metaData, error) in
                            
                            if error != nil {
                                print("画像のアップロードに失敗しました")
                            } else {
                            
                                self.secondBool = true
                                print("画像のアップロードに成功しました")
                                //DBへ画像のURL飛ばす
                                let twoDownloadURL = metaData?.downloadURL()?.absoluteString
                                
                                //二枚目を追加
                                mediaPost["detailImageTwo"] = twoDownloadURL as AnyObject
                                
                                print("二枚目を追加")
                                print(mediaPost)

                            }
                        }

                    }
                    
                    
                    
                    
                    
                    
                    
                    //非同期処理の完了を待ってから投稿
                    
                    
                    wait( {self.mainBool == false} ) {
                        // 取得しました
                        
                        self.wait( {self.firstBool == false} ) {
                            
                            self.wait( {self.secondBool == false} ) {
                                
                                print("三段階確認")
                                print(self.mainBool)
                                print(self.firstBool)
                                print(self.secondBool)
                                
                                 //DBに投稿
                                 let firebasePost = DataService.dataBase.REF_POST.childByAutoId()
                                
                                 firebasePost.setValue(mediaPost)
                                 print(mediaPost)
                                 print("2枚の場合投稿を完了しました")
                                
                            }
                            
                            
                            
                            
                        }
                        
                    }
                    
                    
                    
                    
                }
                    
                    
                    
                        
                   
                    
                    
                    
                    
                    
                    
                    //詳細画像が三枚の場合
                 else if detailImages.count == 3 {
                    
                    print("投稿開始")
                    
                    
                    let ref = FIRDatabase.database().reference()
                    let uid = FIRAuth.auth()?.currentUser?.uid
                    
                    
                    //メイン写真投稿処理
                    let mainImgData = UIImageJPEGRepresentation(self.detailOne, 0.2)
                    let metaData = FIRStorageMetadata()
                    metaData.contentType = "image/jpeg"
                    let secondImgUid = NSUUID().uuidString
                    
                    DispatchQueue.global().async {
                        DataService.dataBase.REF_POST_IMAGES.child(secondImgUid).put(mainImgData!, metadata: metaData) {
                            (metaData, error) in
                            
                            if error != nil {
                                print("画像のアップロードに失敗しました")
                            } else {
                                
                                self.mainBool = true
                                
                                print("画像のアップロードに成功しました")
                                //DBへ画像のURL飛ばす
                                let mainDownloadURL = metaData?.downloadURL()?.absoluteString
                                
                                //メイン画像を追加
                                mediaPost["imageURL"] = mainDownloadURL as AnyObject
                                print("メインを追加")
                                print(mediaPost)
                            }
                        }
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    //一枚目の投稿
                    let onesUID = NSUUID().uuidString
                    let onesImgData = UIImageJPEGRepresentation(self.detailImages[0]!, 0.2)
                    
                    DispatchQueue.global().async {
                        DataService.dataBase.REF_POST_IMAGES.child(onesUID).put(onesImgData!, metadata: metaData) {
                            (metaData, error) in
                            
                            if error != nil {
                                print("画像のアップロードに失敗しました")
                            } else {
                                self.firstBool = true
                                print("画像のアップロードに成功しました")
                                //DBへ画像のURL飛ばす
                                let oneDownloadURL = metaData?.downloadURL()?.absoluteString
                                
                                //一枚目を追加
                                mediaPost["detailImageOne"] = oneDownloadURL as AnyObject
                                print("一枚目を追加")
                                print(mediaPost)
                                
                                
                            }
                        }
                    }
                    
                    
                    
                    
                    
                    //二枚目の投稿
                    let twoUID = NSUUID().uuidString
                    let twoImgData = UIImageJPEGRepresentation(self.detailImages[1]!, 0.2)
                    
                    
                    DispatchQueue.global().async {
                        
                        
                        DataService.dataBase.REF_POST_IMAGES.child(twoUID).put(twoImgData!, metadata: metaData) {
                            (metaData, error) in
                            
                            if error != nil {
                                print("画像のアップロードに失敗しました")
                            } else {
                                
                                self.secondBool = true
                                print("画像のアップロードに成功しました")
                                //DBへ画像のURL飛ばす
                                let twoDownloadURL = metaData?.downloadURL()?.absoluteString
                                
                                //二枚目を追加
                                mediaPost["detailImageTwo"] = twoDownloadURL as AnyObject
                                
                                print("二枚目を追加")
                                print(mediaPost)
                                
                            }
                        }
                        
                    }
                    
                    
                    
                    //三枚目追加
                    let threeUID = NSUUID().uuidString
                    let threeImgData = UIImageJPEGRepresentation(self.detailImages[2]!, 0.2)
                    
                     DispatchQueue.global().async {
                        
                        DataService.dataBase.REF_POST_IMAGES.child(threeUID).put(threeImgData!, metadata: metaData) {
                            (metaData, error) in
                            
                            if error != nil {
                                
                                print("画像のアップロードに失敗しました")
                            } else {
                                print("画像のアップロードに成功しました")
                                self.thirdBool = true
                                //DBへ画像のURL飛ばす
                                let threeDownloadURL = metaData?.downloadURL()?.absoluteString
                                
                                
                                mediaPost["imageThree"] = threeDownloadURL as AnyObject
                                
                                
                                print(mediaPost)
                                
                                //DBに投稿
                                let firebasePost = DataService.dataBase.REF_POST.childByAutoId()
                                
                                firebasePost.setValue(mediaPost)
                                print("3枚の投稿を完了しました")
                                
                            }
                        }
                    }
                    
                    
                    //非同期処理の完了を待ってから投稿
                    
                    wait( {self.mainBool == false} ) {
                        // 取得しました
                        
                        self.wait( {self.firstBool == false} ) {
                            
                            self.wait( {self.secondBool == false} ) {
                                
                                self.wait( {self.thirdBool == false} ) {
                                
                                    print("4段階確認")
                                    print(self.mainBool)
                                    print(self.firstBool)
                                    print(self.secondBool)
                                    print(self.thirdBool)
                                    
                                    //DBに投稿
                                    let firebasePost = DataService.dataBase.REF_POST.childByAutoId()
                                    
                                    firebasePost.setValue(mediaPost)
                                    print(mediaPost)
                                    print("3枚の場合投稿を完了しました")
                                
                                }
                                
                                
                            }
                            
                            
                            
                            
                        }
                        
                    }
                    
                    
                    
                    
                   
                    
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

