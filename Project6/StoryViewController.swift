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
    
    var detailImages = [UIImage]()
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
                
                
                
                    
                    
                
                
                
                
                
                
                let firebasePost = DataService.dataBase.REF_ENTERTAINMENT.childByAutoId()
                
                firebasePost.setValue(techPost)
                
                
                
                
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
