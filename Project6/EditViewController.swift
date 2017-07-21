//
//  EditViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/17.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

class EditViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UINavigationBarDelegate {
    
    
    @IBOutlet weak var editNav: UINavigationBar!
    @IBOutlet weak var nameField: SignUpField!
    @IBOutlet weak var userDesc: SignUpField!
    @IBOutlet weak var userImage: ProfileImage!
    @IBOutlet weak var cardView: UIView!
    var myImagePicker: UIImagePickerController!
    var mainImageBox = UIImage()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        nameField.delegate = self
        userDesc.delegate = self
        editNav.delegate = self
        
        
        self.cardView.layer.cornerRadius = 15
        
        
        if FIRAuth.auth()?.currentUser != nil {
            print("ユーザーあり")
            
            let user = FIRAuth.auth()?.currentUser
            
            let userName = user?.displayName
            let photoURL = user?.photoURL
            
            self.nameField.text = userName
            
            
            if photoURL == nil {
                userImage.image = UIImage(named: "drop")
            } else {
                userImage.af_setImage(withURL: photoURL!)
            }
            
            let userRef = DataService.dataBase.REF_BASE.child("users/\(FIRAuth.auth()!.currentUser!.uid)")
            
            
            userRef.observe(.value, with: { (snapshot) in
                
                //UserName取得
                let user = User(snapshot: snapshot)
                
                if user.userDesc == "" {
                    self.userDesc.text = ""
                } else if user.userDesc == nil {
                    self.userDesc.text = ""
                } else {
                    self.userDesc.text = user.userDesc
                }
                
                
                
            })

        

    }
        
        //バーの高さ
        self.editNav.frame = CGRect(x: 0,y: 0, width: UIScreen.main.bounds.size.width, height: 60)
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                self.mainImageBox = image
                
                self.userImage.image = self.mainImageBox
                
                
            }
            
            
        }
        picker.dismiss(animated: true, completion: nil)
    }

    
    
    @IBAction func imageDidTap(_ sender: Any) {
        
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
    
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func saveButtonDidTap(_ sender: Any) {
        
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        let userUID = NSUUID().uuidString
        let userImgData = UIImageJPEGRepresentation(userImage.image!, 0.2)
        
        //変更画像をDBへ
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
                    
                    //UserProfile変更
                    
                    let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
                    changeRequest?.displayName = self.nameField.text
                    changeRequest?.photoURL = URL(string: userDownloadURL!)
                    
                    
                    changeRequest?.commitChanges() { (error) in
                        
                        
                        //DBを更新
                        let userData = ["profileDesc" : self.userDesc.text!, "userName" : FIRAuth.auth()?.currentUser?.displayName, "email" : FIRAuth.auth()?.currentUser?.email,"userImageURL" : userPhotoURL]
                        
                        //DBに追記
                        DataService.dataBase.REF_BASE.child("users/\(FIRAuth.auth()!.currentUser!.uid)").updateChildValues(userData)
                        
                        
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    
                    
                }
            }
            
        }
        
    }
    
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        userDesc.resignFirstResponder()
        
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
    
    
    
    
    

   
}
