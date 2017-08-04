//
//  SignUpViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/13.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import SkyFloatingLabelTextField

class SignUpViewController: UIViewController , UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    
    @IBOutlet weak var userImage: ProfileImage!
    @IBOutlet weak var userNameField: SkyFloatingLabelTextField!
   
    //データ引き継ぎ
    var email = String()
    var password = String()
    
    
    
    var mainImageBox = UIImage()
    var initialURL = URL(string: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameField.delegate = self
        
        
        
        
       
        
        
        //ユーザー名
        userNameField.placeholder = "ユーザー名"
        userNameField.title = "ユーザー名"
        userNameField.tintColor = barColor
        userNameField.textColor = UIColor.darkGray
        userNameField.lineColor = UIColor.lightGray
        userNameField.selectedTitleColor = barColor
        userNameField.selectedLineColor = barColor
        userNameField.lineHeight = 1.0 // bottom line height in points
        userNameField.selectedLineHeight = 2.0
        
        

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        userNameField.resignFirstResponder()
        
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
    
   
    @IBAction func backButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    @IBAction func registerDidTap(_ sender: Any) {
        
        showIndicator()
        
        if self.email == nil || self.password == nil || userNameField.text == nil {
            
            DispatchQueue.main.async {
                
                self.indicator.stopAnimating()
            }
            
            let alertViewControler = UIAlertController(title: "エラー", message: "もう一度入力してください", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertViewControler.addAction(okAction)
            present(alertViewControler, animated: true, completion: nil)
            
            
            
        } else {
            
            //新規ユーザー登録
            FIRAuth.auth()?.createUser(withEmail: self.email, password: self.password , completion: { (user, error) in
                
                
                if error == nil{
                    
                    //GuestUserの削除
                    if UserDefaults.standard.object(forKey: "GuestUser") != nil {
                        let userDefaults = UserDefaults.standard
                        userDefaults.removeObject(forKey: "GuestUser")
                    }
                    
                    
                    
                    UserDefaults.standard.set("EmailRegister", forKey: "EmailRegister")
                    UserDefaults.standard.set("AutoLogin", forKey: "AutoLogin")
                    
                    if let user = user {
                        
                        
                        
                        
                        //プロフィール画像と名前の投稿
                        let metaData = FIRStorageMetadata()
                        metaData.contentType = "image/jpeg"
                        let userUID = NSUUID().uuidString
                        let userImgData = UIImageJPEGRepresentation(self.userImage.image!, 0.2)
                        
                        DispatchQueue.global().async {
                            
                            DataService.dataBase.REF_POST_IMAGES.child(userUID).put(userImgData!, metadata: metaData) {
                                (metaData, error) in
                                
                                if error != nil {
                                    print("画像のアップロードに失敗しました")
                                } else {
                                    print("画像のアップロードに成功しました")
                                    //DBへ画像のURL飛ばす
                                    let userDownloadURL = metaData?.downloadURL()?.absoluteString
                                    
                                    let userPhotoURL = String(describing: FIRAuth.auth()?.currentUser?.photoURL)
                                    
                                    
                                    let changeRequest = user.profileChangeRequest()
                                    
                                    changeRequest.displayName = self.userNameField.text
                                    changeRequest.photoURL = URL(string: userDownloadURL!)
                                    
                                    changeRequest.commitChanges { error in
                                        if let error = error {
                                            // An error happened.
                                            print(error.localizedDescription)
                                        } else {
                                            print("プロフィールの登録完了")
                                            print(user.displayName!)
                                            print(user.email!)
                                            print(user.photoURL!)
                                            
                                            
                                            let userData = ["userName" : FIRAuth.auth()?.currentUser?.displayName, "email" : FIRAuth.auth()?.currentUser?.email,"userImageURL" : userPhotoURL]
                                            
                                            //DBに追記
                                            DataService.dataBase.REF_BASE.child("users/\(FIRAuth.auth()!.currentUser!.uid)").setValue(userData)
                                            
                                            
                                        }
                                    }
                                    
                                }
                            }
                        }
                        
                                    
                                    
                     
                        let userData = ["provider" : user.providerID]
                        let name = ["userName" : user.displayName]
                        let email = ["email" : user.email]
                        let photoUrl = ["photoURL" : ""]
                        
                        print("データ: \(userData)")
                        print("名前: \(name)")
                        print("Eメール: \(email)")
                        print("画像URL: \(photoUrl)")
                        
                        self.completeSignUp(id: user.uid, userData: userData, userName: name, userEmail: email, photoURL: photoUrl)
                        
                       
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.indicator.stopAnimating()
                    }
                    
                    user?.sendEmailVerification(completion: { (error) in
                        
                        if error == nil {
                            //Send Email
                            let alertViewControler = UIAlertController(title: "認証メールを送信しました!", message: "アカウントの認証をお願いします", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            
                            alertViewControler.addAction(okAction)
                            self.present(alertViewControler, animated: true, completion: nil)

                            
                            
                        } else {
                            
                            print("\(error?.localizedDescription)")
                            
                        }
                        
                        
                        
                        
                        
                    })

                    self.performSegue(withIdentifier: "registerGoGo", sender: nil)
                    
                    
                }else{
                    //失敗
                    
                    DispatchQueue.main.async {
                        
                        self.indicator.stopAnimating()
                    }
                    
                    let alertViewController = UIAlertController(title: "エラー", message:error?.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertViewController.addAction(okAction)
                    
                    self.present(alertViewController, animated:true, completion:nil)
                    
                    
                }
                
            })
            
        }
        
        
        
        
    }
    
    var myImagePicker: UIImagePickerController!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                self.mainImageBox = image
                
                self.userImage.image = self.mainImageBox
                
                
            }
            
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func profileImageButtonDidTap(_ sender: Any) {
        
        //////
        
        
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "RealUserDone" {
            
            let accountVc = (segue.destination as? AccountViewController)!
            
            accountVc.realUserName = self.userNameField.text
            
            
            
            
        }
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
    
    
    
    func completeSignUp(id: String, userData: Dictionary<String,String>,userName: Dictionary<String,Any>,userEmail: Dictionary<String,Any>, photoURL: Dictionary<String,Any>) {
        
        DataService.dataBase.createDataBaseUser(uid: id, userData: userData, userName: userName, photoURL: photoURL, userEmail: userEmail)
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Data saved to keychain \(keychainResult)")
        
        
    }
    
    

   
}
