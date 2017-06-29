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
    var mainBool = false
    var firstBool = false
    var secondBool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        storyText.delegate = self
        
        
        storyText.text = ""
        storyText.becomeFirstResponder()
        
      
        
        print("投稿データの詳細データ")
        print(name)
        print(categoryTitle)
        print(detailImages)
        
        
        
        

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func PostButtonDidTap(_ sender: Any) {
        
        if self.storyText.text == "" {
            
            let alertViewController = UIAlertController(title: "ストーリが空です", message:"思いを伝えよう", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertViewController.addAction(okAction)
            
            self.present(alertViewController, animated:true, completion:nil)
            
        }
        
        /*
        else {
            
            print("投稿開始")
            
            
            let ref = FIRDatabase.database().reference()
            
            //プロフィールへの登録
            
            do {
                
                let uid = FIRAuth.auth()?.currentUser?.uid
                
                
               ref.child((FIRAuth.auth()?.currentUser?.uid)!).childByAutoId().setValue(["categoryName": categoryTitle as AnyObject,"productName": self.name,  "linkURL" : self.url, "categoryName" : self.categoryTitle ,  "storyContent" : storyText.text,  "pageViews" : 0,  "userID" : uid!])
                
                
                
            } catch {
                
                print(error.localizedDescription)
                
                return
            }
            
            
 
            
            
        }
        */
        
     //カテゴリー別の投稿
        //テクノロジー
        else  if categoryTitle == "メディア" {
            print("メディア投稿開始")
            
            
            let ref = FIRDatabase.database().reference()
            let uid = FIRAuth.auth()?.currentUser?.uid
            
            
                
                var mediaPost: Dictionary<String, AnyObject> = [
                    
                    "category" : categoryTitle as AnyObject,
                    "name" : self.name as AnyObject,
                    "linkURL" : self.url as AnyObject,
                    "pvCount" : 0 as AnyObject,
                    "whatContent" : storyText.text as AnyObject,
                    "userID" : uid as AnyObject
                ]

                
                //詳細画像一枚のとき
                if detailImages.count == 1 {
                    
                    
                    //メイン写真投稿
                    let mainImgData = UIImageJPEGRepresentation(detailOne, 0.2)
                    
                    
                    let metaData = FIRStorageMetadata()
                    metaData.contentType = "image/jpeg"
                    let mainImgUid = NSUUID().uuidString
                    
                    
                    
                    
                    DataService.dataBase.REF_POST_IMAGES.child(mainImgUid).put(mainImgData!, metadata: metaData) {
                        (metaData, error) in
                        
                        if error != nil {
                            print("画像のアップロードに失敗しました")
                        } else {
                            print("画像のアップロードに成功しました")
                            //DBへ画像のURL飛ばす
                            let firstDownloadURL = metaData?.downloadURL()?.absoluteString
                            
                            //メイン画像を追加
                            mediaPost["imageURL"] = firstDownloadURL as AnyObject
                            
                        }
                    }
                    
                    //詳細画像一枚追加処理
                    let oneUID = NSUUID().uuidString
                    let oneImgData = UIImageJPEGRepresentation(detailImages[0]!, 0.2)
                    
                    
                    
                    DataService.dataBase.REF_POST_IMAGES.child(oneUID).put(oneImgData!, metadata: metaData) {
                        (metaData, error) in
                        
                        if error != nil {
                            print("画像のアップロードに失敗しました")
                        } else {
                            print("画像のアップロードに成功しました")
                            //DBへ画像のURL飛ばす
                            let oneDownloadURL = metaData?.downloadURL()?.absoluteString
                            
                            
                            mediaPost["detailImageOne"] = oneDownloadURL as AnyObject
                            
                            print(mediaPost)
                            
                            //詳細画像が一枚の場合
                            if self.detailImages.count == 1 {
                                let firebasePost = DataService.dataBase.REF_POST.childByAutoId()
                                
                                firebasePost.setValue(mediaPost)
                                print("一枚の場合の投稿を完了しました")
                            }
                            
                        }
                    }
                }
                
              
                
                
                
                //詳細画像二枚のとき
                
                
                if detailImages.count == 2 {
                    
                
                        print("投稿開始")
                    
                   //let queue = DispatchQueue.main
                    
                    
                        print("直列処理")
                        
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
                    
                    wait( { return self.mainBool == true } ) {
                        // 取得しました
                        print("メイン")
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
                        
                    // dataを取得するまで待ちます
                    wait( { return self.firstBool == true } ) {
                        // 取得しました
                        print("finish1")
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
                                
                                //DBに投稿
                                let firebasePost = DataService.dataBase.REF_POST.childByAutoId()
                                
                                firebasePost.setValue(mediaPost)
                                print(mediaPost)
                                print("2枚の場合投稿を完了しました")
                                
                                
                            }
                            
                            
                            
                        }

                    }
                    
                    wait( { return self.secondBool == true } ) {
                        // 取得しました
                        print("finish")
                    }
                        
                    
                    
                        
                }
                    
                    
                    
                        
                   
                    
                    
                    
                    
                    
                    
                    //詳細画像が三枚の場合
                 else if detailImages.count == 3 {
                    
                    //二枚目追加
                    let twoUID = NSUUID().uuidString
                    let twoImgData = UIImageJPEGRepresentation(detailImages[1]!, 0.2)
                    let metaData = FIRStorageMetadata()
                    metaData.contentType = "image/jpeg"
                    
                    
                    DataService.dataBase.REF_POST_IMAGES.child(twoUID).put(twoImgData!, metadata: metaData) {
                        (metaData, error) in
                        
                        if error != nil {
                            print("画像のアップロードに失敗しました")
                        } else {
                            print("画像のアップロードに成功しました")
                            //DBへ画像のURL飛ばす
                            let twoDownloadURL = metaData?.downloadURL()?.absoluteString
                            
                            
                            mediaPost["imageTwo"] = twoDownloadURL as AnyObject
                            
                            
                            print(mediaPost)
                            
                            
                        
                            
                        }
                    }
                    
                    
                    //三枚目追加
                    let threeUID = NSUUID().uuidString
                    let threeImgData = UIImageJPEGRepresentation(self.detailImages[2]!, 0.2)
                    
                    
                    DataService.dataBase.REF_POST_IMAGES.child(threeUID).put(threeImgData!, metadata: metaData) {
                        (metaData, error) in
                        
                        if error != nil {
                            print("画像のアップロードに失敗しました")
                        } else {
                            print("画像のアップロードに成功しました")
                            //DBへ画像のURL飛ばす
                            let threeDownloadURL = metaData?.downloadURL()?.absoluteString
                            
                            
                            mediaPost["imageThree"] = threeDownloadURL as AnyObject
                            
                            
                            print(mediaPost)
                            
                            //DBに投稿
                            let firebasePost = DataService.dataBase.REF_ENTERTAINMENT.childByAutoId()
                            
                            firebasePost.setValue(mediaPost)
                            print("3枚の投稿を完了しました")
                            
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

