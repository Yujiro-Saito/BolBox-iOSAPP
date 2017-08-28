//
//  PostProductPhotosViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/21.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage
import RSKPlaceholderTextView
import OnOffButton
import SkyFloatingLabelTextField

class PostProductPhotosViewController: UIViewController, UIImagePickerControllerDelegate ,UINavigationControllerDelegate,UITextFieldDelegate {
    
    
    
    @IBOutlet weak var mainImagePhoto: ImageDesign!
    var mainImageBox = UIImage()
    
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var introImage: UIButton!
    @IBOutlet weak var postButton: ZFRippleButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var onButton: OnOffButton!
    @IBOutlet weak var ThanksLabel: UILabel!
    
    
    //データ引き継ぎ用
    
    var productName = String()
    var productUrl: String?
    
    var mainBool = false
    var profileBool = false
    
    
    //プロフィール画像
    var profileImage = UIImageView()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //チェックボタン待機
        self.onButton.isHidden = true
        self.onButton.checked = false
        
        self.ThanksLabel.isHidden = true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                self.mainImageBox = image
                
                self.mainImagePhoto.image = self.mainImageBox
                
                
            }
            
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func ToKeepOn(_ sender: Any) {
        //DBに保存(名前、URL、画像)
        
        
        if mainImagePhoto.image != nil {
            
            showIndicator()
            
            let user = FIRAuth.auth()?.currentUser
            let photoURL = user?.photoURL
            let userName = user!.displayName
            let ref = FIRDatabase.database().reference()
            let uid = FIRAuth.auth()?.currentUser?.uid
            
            //If No Url
            if productUrl == nil || productUrl == "" {
                
                var post: Dictionary<String, AnyObject> = [
                    
                    "name" : productName as AnyObject,
                    "linkURL" : "" as AnyObject,
                    "pvCount" : 0 as AnyObject,
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
                let mainImgData = UIImageJPEGRepresentation(mainImagePhoto.image!, 0.2)
                
                
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
                        let postKey = "\(key)"
                        
                        //postIDを追加
                        post["postID"] = postKey as AnyObject
                        
                        firebasePost.setValue(post)
                        
                        
                        DispatchQueue.main.async {
                            
                            self.indicator.stopAnimating()
                        }
                        
                        
                        print("投稿を完了しました")
                        
                     
                        
                        //チェック以外のUIを隠す
                        self.postButton.isHidden = true
                        self.backButton.isHidden = true
                        self.mainImagePhoto.isHidden = true
                        self.introLabel.isHidden = true
                        self.introImage.isHidden = true
                        
                        //チェックつける
                        self.ThanksLabel.isHidden = false
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
                //URLがある場合
                
                var post: Dictionary<String, AnyObject> = [
                    
                    "name" :  productName as AnyObject,
                    "linkURL" : productUrl as AnyObject,
                    "pvCount" : 0 as AnyObject,
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
                let mainImgData = UIImageJPEGRepresentation(mainImagePhoto.image!, 0.2)
                
                
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
                        self.postButton.isHidden = true
                        self.backButton.isHidden = true
                        self.mainImagePhoto.isHidden = true
                        self.introLabel.isHidden = true
                        self.introImage.isHidden = true
                        
                        //チェックつける
                        self.ThanksLabel.isHidden = false
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
        
    
    @IBAction func mainPhotoDidTap(_ sender: Any) {
        
        
        
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラロール許可をしていない時の処理")
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

    





}
