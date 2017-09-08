//
//  PhotoPostViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/06.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage
import Eureka

//import SkyFloatingLabelTextField

class PhotoPostViewController: FormViewController, UIImagePickerControllerDelegate ,UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var postPhoto: UIImageView!
    var mainImageBox = UIImage()
    
    //データ
    var folderName = String()
    let uid = FIRAuth.auth()?.currentUser?.uid
    let userName = FIRAuth.auth()?.currentUser?.displayName
    var mainBool = false
    var folderNameDictionary = Dictionary<String, Dictionary<String, String?>>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.hidesBarsOnSwipe = true

        tableView.backgroundColor = UIColor.rgb(r: 69, g: 113, b: 144, alpha: 1.0)
        tableView.frame = CGRect(x: 0, y: 135, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        form +++ Section("登録")
            <<< TextRow("link"){ row in
                row.title = "リンク"
                row.placeholder = "コピーしたリンク(任意)"
            }
            <<< TextRow("memo"){ row in
                row.title = "メモ"
                row.placeholder = "メモ(任意)"
        }
        
        
    }
    
    @IBAction func photoTapped(_ sender: Any) {
        
        
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePickerController.allowsEditing = true
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("カメラロール許可をしていない時の処理")
                //UIViewで許可のお願いを出す
            }
            
        
        
    }
    
    
    
    func postButtonDidTap() {
        
        let linkRow: TextRow? = form.rowBy(tag: "link")
        var linkValue = linkRow?.value
        
        let captionRow: TextRow? = form.rowBy(tag: "memo")
        var captionValue = captionRow?.value
        
        if linkValue == nil {
            
            print("1111111")
            
            linkValue = ""
            
            let firebasePost = DataService.dataBase.REF_USER.child(uid!).child("posts").childByAutoId()
            let key = firebasePost.key
            let keyvalue = ("\(key)")
            
            var post: Dictionary<String, AnyObject> = [
                
                "folderName" :  folderName as AnyObject,
                "linkURL" : linkValue! as AnyObject,
                "pvCount" : 0 as AnyObject,
                "userID" : uid as AnyObject,
                "userName" : userName as AnyObject,
                "name" : captionValue! as AnyObject,
                "postID" : keyvalue as AnyObject
            ]
            
            
            
            //画像処理
            
            let mainImgData = UIImageJPEGRepresentation(postPhoto.image!, 0.2)
            
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            let mainImgUid = NSUUID().uuidString
            
            DispatchQueue.global().async {
                
                DataService.dataBase.REF_POST_IMAGES.child(mainImgUid).put(mainImgData!, metadata: metaData) {
                    (metaData, error) in
                    
                    if error != nil {
                        print("画像のアップロードに失敗しました")
                    } else {
                        
                        print("画像のアップロードに成功しました")
                        //DBへ画像のURL飛ばす
                        let firstDownloadURL = metaData?.downloadURL()?.absoluteString
                        
                        //メイン画像を追加
                        post["imageURL"] = firstDownloadURL as AnyObject
                        
                        
                        //folder name 
                        let folderInfo: Dictionary<String,String> = ["imageURL" : firstDownloadURL!, "name" : self.folderName]
                        
                         self.folderNameDictionary = [self.folderName : folderInfo]
                        
                        self.mainBool = true
                        
                    }
                }
                
            }

            
            
            
            
            
            
            
            self.wait( {self.mainBool == false} ) {
                print(post)
                firebasePost.setValue(post)
                DataService.dataBase.REF_BASE.child("users/\(self.uid!)/folderName").updateChildValues(self.folderNameDictionary)
                
                self.mainBool = false
            }
            
            
            
            
            
            
            
        } else if captionValue == nil {
            
            print("22222222222")
            captionValue = ""
            
            let firebasePost = DataService.dataBase.REF_USER.child(uid!).child("posts").childByAutoId()
            let key = firebasePost.key
            let keyvalue = ("\(key)")
            
            var post: Dictionary<String, AnyObject> = [
                
                "folderName" :  folderName as AnyObject,
                "linkURL" : linkValue! as AnyObject,
                "pvCount" : 0 as AnyObject,
                "userID" : uid as AnyObject,
                "userName" : userName as AnyObject,
                "name" : captionValue! as AnyObject,
                "postID" : keyvalue as AnyObject
            ]
            
            
            
            //画像処理
            
            let mainImgData = UIImageJPEGRepresentation(postPhoto.image!, 0.2)
            
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            let mainImgUid = NSUUID().uuidString
            
            DispatchQueue.global().async {
                
                DataService.dataBase.REF_POST_IMAGES.child(mainImgUid).put(mainImgData!, metadata: metaData) {
                    (metaData, error) in
                    
                    if error != nil {
                        print("画像のアップロードに失敗しました")
                    } else {
                        
                        print("画像のアップロードに成功しました")
                        //DBへ画像のURL飛ばす
                        let firstDownloadURL = metaData?.downloadURL()?.absoluteString
                        
                        //メイン画像を追加
                        post["imageURL"] = firstDownloadURL as AnyObject
                        
                        //folder name
                        let folderInfo: Dictionary<String,String> = ["imageURL" : firstDownloadURL!, "name" : self.folderName]
                        
                        self.folderNameDictionary = [self.folderName : folderInfo]
                        
                        self.mainBool = true
                        
                    }
                }
                
            }
            
            
            
            self.wait( {self.mainBool == false} ) {
                print(post)
                firebasePost.setValue(post)
                DataService.dataBase.REF_BASE.child("users/\(self.uid!)/folderName").updateChildValues(self.folderNameDictionary)
                self.mainBool = false
            }

        } else if linkValue == nil && captionValue == nil {
            
            print("33333333333")
            
            linkValue = ""
            captionValue = ""
            
            
            let firebasePost = DataService.dataBase.REF_USER.child(uid!).child("posts").childByAutoId()
            let key = firebasePost.key
            let keyvalue = ("\(key)")
            
            var post: Dictionary<String, AnyObject> = [
                
                "folderName" :  folderName as AnyObject,
                "linkURL" : linkValue! as AnyObject,
                "pvCount" : 0 as AnyObject,
                "userID" : uid as AnyObject,
                "userName" : userName as AnyObject,
                "name" : captionValue! as AnyObject,
                "postID" : keyvalue as AnyObject
            ]
            
            
            
            //画像処理
            
            let mainImgData = UIImageJPEGRepresentation(postPhoto.image!, 0.2)
            
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            let mainImgUid = NSUUID().uuidString
            
            DispatchQueue.global().async {
                
                DataService.dataBase.REF_POST_IMAGES.child(mainImgUid).put(mainImgData!, metadata: metaData) {
                    (metaData, error) in
                    
                    if error != nil {
                        print("画像のアップロードに失敗しました")
                    } else {
                        print("画像のアップロードに成功しました")
                        //DBへ画像のURL飛ばす
                        let firstDownloadURL = metaData?.downloadURL()?.absoluteString
                        
                        //メイン画像を追加
                        post["imageURL"] = firstDownloadURL as AnyObject
                        //folder name
                        let folderInfo: Dictionary<String,String> = ["imageURL" : firstDownloadURL!, "name" : self.folderName]
                        
                        self.folderNameDictionary = [self.folderName : folderInfo]
                        
                        self.mainBool = true
                        
                    }
                }
                
            }
            
            
            
            self.wait( {self.mainBool == false} ) {
                print(post)
                firebasePost.setValue(post)
                DataService.dataBase.REF_BASE.child("users/\(self.uid!)/folderName").updateChildValues(self.folderNameDictionary)
                self.mainBool = false
            }
            
            
        } else {
            
            print("444444444444")
            
            
            let firebasePost = DataService.dataBase.REF_USER.child(uid!).child("posts").childByAutoId()
            let key = firebasePost.key
            let keyvalue = ("\(key)")
            
            var post: Dictionary<String, AnyObject> = [
                
                "folderName" :  folderName as AnyObject,
                "linkURL" : linkValue! as AnyObject,
                "pvCount" : 0 as AnyObject,
                "userID" : uid as AnyObject,
                "userName" : userName as AnyObject,
                "name" : captionValue! as AnyObject,
                "postID" : keyvalue as AnyObject
            ]
            
            
            
            //画像処理
            
            let mainImgData = UIImageJPEGRepresentation(postPhoto.image!, 0.2)
            
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            let mainImgUid = NSUUID().uuidString
            
            DispatchQueue.global().async {
                
                DataService.dataBase.REF_POST_IMAGES.child(mainImgUid).put(mainImgData!, metadata: metaData) {
                    (metaData, error) in
                    
                    if error != nil {
                        print("画像のアップロードに失敗しました")
                    } else {
                        print("画像のアップロードに成功しました")
                        //DBへ画像のURL飛ばす
                        let firstDownloadURL = metaData?.downloadURL()?.absoluteString
                        
                        //メイン画像を追加
                        post["imageURL"] = firstDownloadURL as AnyObject
                        
                        //folder name
                        let folderInfo: Dictionary<String,String> = ["imageURL" : firstDownloadURL!, "name" : self.folderName]
                        
                        self.folderNameDictionary = [self.folderName : folderInfo]
                        
                        self.mainBool = true
                        
                    }
                }
                
            }
            
            
            
            self.wait( {self.mainBool == false} ) {
                print(post)
                firebasePost.setValue(post)
                DataService.dataBase.REF_BASE.child("users/\(self.uid!)/folderName").updateChildValues(self.folderNameDictionary)
                
                self.mainBool = false
            }
            
            
        }
        
        
        
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(PhotoPostViewController.postButtonDidTap))
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        
        if postPhoto.image == nil {
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePickerController.allowsEditing = true
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("カメラロール許可をしていない時の処理")
                //UIViewで許可のお願いを出す
                
                
                
            }
            
        } else {
            
            
            
            
        }

        
        
        
        
        
    }
    
    
   
   
   
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                self.mainImageBox = image
                
                self.postPhoto.image = self.mainImageBox
                
                
            }
            
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    let indicator = UIActivityIndicatorView()
    
    func showIndicator() {
        
        indicator.activityIndicatorViewStyle = .white
        
        indicator.center = self.view.center
        
        indicator.color = UIColor.red
        
        indicator.hidesWhenStopped = true
        
        self.view.addSubview(indicator)
        
        self.view.bringSubview(toFront: indicator)
        
        indicator.startAnimating()
        
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
