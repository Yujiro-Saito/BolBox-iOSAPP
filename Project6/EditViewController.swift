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
import SkyFloatingLabelTextField
import RSKPlaceholderTextView

class EditViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UINavigationBarDelegate,UITextViewDelegate {
    
    
    @IBOutlet weak var editNav: UINavigationBar!
    @IBOutlet weak var userImage: ProfileImage!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameField: SkyFloatingLabelTextField!
    @IBOutlet weak var descTextview: RSKPlaceholderTextView!
    
    
    var myImagePicker: UIImagePickerController!
    var mainImageBox = UIImage()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        descTextview.delegate = self
        
        descTextview.returnKeyType = UIReturnKeyType.done
        
        nameField.delegate = self
        editNav.delegate = self
        
        
        
        nameField.title = "ユーザー名"
        nameField.tintColor = barColor
        nameField.textColor = UIColor.darkGray
        nameField.lineColor = UIColor.lightGray
        nameField.selectedTitleColor = barColor
        nameField.selectedLineColor = barColor
        nameField.lineHeight = 1.0 // bottom line height in points
        nameField.selectedLineHeight = 2.0
       
        
        
        
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
            
            
            
            
            //プロフィールの取得
            DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: FIRAuth.auth()?.currentUser?.uid).observe(.value, with: { (snapshot) in
                
                //ユーザーのデータ取得
                
                
                print(snapshot.value)
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                            let profileDesc = postDict["profileDesc"] as! String?
                            
                            self.descTextview.text = profileDesc
                            
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                
                
            })
            
            
            
            

        

    }
        
        //バーの高さ
        self.editNav.frame = CGRect(x: 0,y: 0, width: UIScreen.main.bounds.size.width, height: 60)
        
        
    }
    
    
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
        
        showIndicator()
        
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
                    
                    //let userPhotoURL = String(describing: FIRAuth.auth()?.currentUser?.photoURL)
                    
                    //UserProfile変更
                    let photoLink = FIRAuth.auth()?.currentUser?.photoURL
                    let userPhotoURL = String(describing: photoLink!)
                    let userDescription = self.descTextview.text
                    
                    
                    let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
                    changeRequest?.displayName = self.nameField.text
                    changeRequest?.photoURL = URL(string: userDownloadURL!)
                    
                    
                    changeRequest?.commitChanges() { (error) in
                        
                        
                        let userData = ["userName" : FIRAuth.auth()?.currentUser?.displayName, "email" : FIRAuth.auth()?.currentUser?.email,"userImageURL" : userPhotoURL,"profileDesc" : userDescription, "uid" : FIRAuth.auth()?.currentUser?.uid]
                        
                        //DBに追記
                        DataService.dataBase.REF_BASE.child("users/\(FIRAuth.auth()!.currentUser!.uid)").updateChildValues(userData)
                        
                        
                        DispatchQueue.main.async {
                            
                            self.indicator.stopAnimating()
                        }
                        
                        
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    
                    
                }
            }
            
        }
        
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
        
        indicator.color = UIColor.rgb(r: 31, g: 158, b: 187, alpha: 1)
        
        indicator.hidesWhenStopped = true
        
        self.view.addSubview(indicator)
        
        self.view.bringSubview(toFront: indicator)
        
        indicator.startAnimating()
        
        
        
        
    }
    

   
}
