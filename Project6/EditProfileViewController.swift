//
//  EditProfileViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/10/01.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import AlamofireImage
import Firebase

class EditProfileViewController: UIViewController,UITextFieldDelegate ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{

    
    
    
    @IBAction func SignOutButton(_ sender: Any) {
        
         let alert: UIAlertController = UIAlertController(title: "ログアウトしますか", message: nil, preferredStyle:  UIAlertControllerStyle.alert)
        
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("OK")
            
            
            let firebaseAuth = FIRAuth.auth()
            do {
                try firebaseAuth?.signOut()
                self.performSegue(withIdentifier: "TesterLogout", sender: nil)
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        self.present(alert, animated: true, completion: nil)
        
        
        
        
        
        
        
       

    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        nameField.delegate = self
        //メールアドレス
        nameField.placeholder = "ユーザー名"
        nameField.title = "ユーザー名"
        nameField.text = self.userName!
        nameField.tintColor = barColor
        nameField.textColor = UIColor.darkGray
        nameField.lineColor = UIColor.lightGray
        nameField.selectedTitleColor = barColor
        nameField.selectedLineColor = barColor
        nameField.lineHeight = 1.0 // bottom line height in points
        nameField.selectedLineHeight = 2.0
        
        self.itemImage.af_setImage(withURL: self.imageURL!)
        
        
        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(EditProfileViewController.postButtonDidTap))
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.darkGray]
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray

    }
    
    
    let userName = FIRAuth.auth()?.currentUser?.displayName
    let userID = FIRAuth.auth()?.currentUser?.uid
    let imageURL = FIRAuth.auth()?.currentUser?.photoURL
    var mainImageBox = UIImage()
    

    @IBOutlet weak var editButton: UIButton!
        
    @IBOutlet weak var itemImage: UIImageView!

    @IBOutlet weak var nameField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var coverView: UIView!
    
    
    
    @IBAction func edit(_ sender: Any) {
        
        
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
    
    var checkBool = false
    
    func postButtonDidTap () {
        
    
     
        if nameField.text != nil {
            showIndicator()
            
            //DBの更新
            var nameData = ["userName" : self.nameField.text!]
            var imageData = ["userImageURL" :  ""]
            var imageURLing = String()
            
            //FIRUSERデータの更新
            
            
            //////////////////////
            //メイン写真投稿
            let mainImgData = UIImageJPEGRepresentation(self.itemImage.image!, 0.2)
            
            
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            let mainImgUid = NSUUID().uuidString
            
            DispatchQueue.global().async {
                
                DataService.dataBase.REF_POST_IMAGES.child(mainImgUid).put(mainImgData!, metadata: metaData) {
                    (metaData, error) in
                    
                    if error != nil {
                        print("画像のアップロードに失敗しました")
                    } else {
                        self.checkBool = true
                        print("画像のアップロードに成功しました")
                        //DBへ画像のURL飛ばす
                        let firstDownloadURL = metaData?.downloadURL()?.absoluteString
                        imageURLing = firstDownloadURL!
                        
                        //メイン画像を追加
                        imageData = ["userImageURL" : firstDownloadURL!]
                        
                        
                        
                    }
                }
                
            }
            
            
            
            wait( {self.checkBool == false} ) {
                
                
                //DBの更新
                //name
                DataService.dataBase.REF_BASE.child("users/\(self.userID!)").updateChildValues(nameData)
                
                //imageURL
                DataService.dataBase.REF_BASE.child("users/\(self.userID!)").updateChildValues(imageData)
                
                
                
                
                
                
                
                //PhotoURL
                //FIA DB
                //DIS Name
                let user = FIRAuth.auth()?.currentUser
                
                let changeRequest = user?.profileChangeRequest()
                
                changeRequest?.displayName = self.nameField.text!
                changeRequest?.photoURL = URL(string: imageURLing)
                
                changeRequest?.commitChanges { error in
                    if let error = error {
                        // An error happened.
                        print(error.localizedDescription)
                    } else {
                       
                        print("FIRDATA")
                        print(self.userName!)
                        print(self.imageURL!)
                        
                    }
                    
                }
                

                
                
                
                
                
                
                
                
                
                
                DispatchQueue.main.async {
                    
                    self.indicator.stopAnimating()
                    self.checkBool = false
                    
                    
                    let alertViewControler = UIAlertController(title: "プロフィールを変更しました", message: nil, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alertViewControler.addAction(okAction)
                    self.present(alertViewControler, animated: true, completion: nil)
                    //self.performSegue(withIdentifier: "GOINGBACK", sender: nil)
                    
                }
                
                
            }
            
            
            
            
            
            
        }
        
        
        
        
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                self.mainImageBox = image
                
                self.itemImage.image = self.mainImageBox
                
                
            }
            
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        
        return true
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    let indicator = UIActivityIndicatorView()
    
    func showIndicator() {
        
        indicator.activityIndicatorViewStyle = .whiteLarge
        
        indicator.center = self.view.center
        
        indicator.color = UIColor.darkGray
        
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
