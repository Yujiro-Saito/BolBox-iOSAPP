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
        else  if categoryTitle == "テクノロジー" {
            print("テクノロジー投稿開始")
            
            
            let ref = FIRDatabase.database().reference()
            let uid = FIRAuth.auth()?.currentUser?.uid
            
            do {
                
                
                var techPost: Dictionary<String, AnyObject> = [
                    
                    "categoryName" : categoryTitle as AnyObject,
                    "productName" : self.name as AnyObject,
                    "linkURL" : self.url as AnyObject,
                    "pageViews" : 0 as AnyObject,
                    "story" : storyText.text as AnyObject,
                    "userID" : uid as AnyObject
                ]
                
                
                
                
                
                
                
                //詳細画像一枚のとき
                if detailImages.count == 1 {
                    
                    //メイン写真投稿
                    let imgData = UIImageJPEGRepresentation(detailOne, 0.2)
                    
                    
                    let metaData = FIRStorageMetadata()
                    metaData.contentType = "image/jpeg"
                    let imgUid = NSUUID().uuidString
                    
                    
                    
                    
                    DataService.dataBase.REF_POST_IMAGES.child(imgUid).put(imgData!, metadata: metaData) {
                        (metaData, error) in
                        
                        if error != nil {
                            print("画像のアップロードに失敗しました")
                        } else {
                            print("画像のアップロードに成功しました")
                            //DBへ画像のURL飛ばす
                            let downloadURL = metaData?.downloadURL()?.absoluteString
                            
                            
                            techPost["mainURL"] = downloadURL as AnyObject
                            
                            print(techPost)
                        }
                    }
                    
                    //詳細画像一枚目のとき
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
                            
                            
                            techPost["imageOne"] = oneDownloadURL as AnyObject
                            
                            print(techPost)
                            
                            //詳細画像が一枚の場合
                            if self.detailImages.count == 1 {
                                let firebasePost = DataService.dataBase.REF_ENTERTAINMENT.childByAutoId()
                                
                                firebasePost.setValue(techPost)
                                print("一枚の投稿を完了しました")
                            }
                            
                        }
                    }
                }
                
              
                
                
                //詳細画像二枚のとき
                
                
                if detailImages.count == 2 {
                    
                    //メイン写真投稿
                    let imgData = UIImageJPEGRepresentation(detailOne, 0.2)
                    
                    
                    let metaData = FIRStorageMetadata()
                    metaData.contentType = "image/jpeg"
                    let imgUid = NSUUID().uuidString
                    
                    
                    
                    
                    DataService.dataBase.REF_POST_IMAGES.child(imgUid).put(imgData!, metadata: metaData) {
                        (metaData, error) in
                        
                        if error != nil {
                            print("画像のアップロードに失敗しました")
                        } else {
                            print("画像のアップロードに成功しました")
                            //DBへ画像のURL飛ばす
                            let downloadURL = metaData?.downloadURL()?.absoluteString
                            
                            
                            techPost["mainURL"] = downloadURL as AnyObject
                            
                            print(techPost)
                        }
                    }

                    
                    //一枚目の投稿
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
                            
                            
                            techPost["imageOne"] = oneDownloadURL as AnyObject
                            
                            print(techPost)
                                
                            
                        }
                    }
                    
                    
                    //二枚目の投稿
                    let twoUID = NSUUID().uuidString
                    let twoImgData = UIImageJPEGRepresentation(detailImages[1]!, 0.2)
                    
                    
                    DataService.dataBase.REF_POST_IMAGES.child(twoUID).put(twoImgData!, metadata: metaData) {
                        (metaData, error) in
                        
                        if error != nil {
                            print("画像のアップロードに失敗しました")
                        } else {
                            print("画像のアップロードに成功しました")
                            //DBへ画像のURL飛ばす
                            let twoDownloadURL = metaData?.downloadURL()?.absoluteString
                            
                            
                            techPost["imageTwo"] = twoDownloadURL as AnyObject
                            
                            
                            print(techPost)
                            
                            //DBに投稿
                            let firebasePost = DataService.dataBase.REF_ENTERTAINMENT.childByAutoId()
                            
                            firebasePost.setValue(techPost)
                            print("2枚の投稿を完了しました")

                            
                            
                            
                        }
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    //詳細画像三枚目
                } else if detailImages.count == 3 {
                    
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
                            
                            
                            techPost["imageTwo"] = twoDownloadURL as AnyObject
                            
                            
                            print(techPost)
                            
                            
                            
                            
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
                            
                            
                            techPost["imageThree"] = threeDownloadURL as AnyObject
                            
                            
                            print(techPost)
                            
                            //DBに投稿
                            let firebasePost = DataService.dataBase.REF_ENTERTAINMENT.childByAutoId()
                            
                            firebasePost.setValue(techPost)
                            print("3枚の投稿を完了しました")
                            
                        }
                    }
                    
                    
                    
                    
                    
                    
                }
                
                
                
                
                
            } catch {
                print(error.localizedDescription)
            }
        } else if categoryTitle == "メディア" {
            do {
                
                
                
                
                
            } catch {
                
            }
        } else if categoryTitle == "キャリア・教育" {
            do {
                
                
                
                
                
            } catch {
                
            }
        }else if categoryTitle == "ショッピング" {
            do {
                
                
                
                
                
            } catch {
                
            }
        }else if categoryTitle == "ゲーム・エンターテインメント" {
            do {
                
                
                
                
                
            } catch {
                
            }
        }
        
        
        
        
        
        
    }
    
    
    
    

}
