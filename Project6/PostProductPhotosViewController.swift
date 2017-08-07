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
    var myImagePicker: UIImagePickerController!
    var mainImageBox = UIImage()
    
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var introImage: UIButton!
    @IBOutlet weak var postButton: ZFRippleButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var urlFields: SkyFloatingLabelTextField!
    
    
    
    
    //データ引き継ぎ用
    
    var productName = String()
    var productCategory = String()
    
    var mainBool = false
    var profileBool = false
    
    
    //プロフィール画像
    var profileImage = UIImageView()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlFields.delegate = self
        
        
        //名前テキスト
        urlFields.placeholder = "URL(あれば)"
        urlFields.title = "URL"
        urlFields.tintColor = barColor
        urlFields.textColor = UIColor.darkGray
        urlFields.lineColor = UIColor.lightGray
        urlFields.selectedTitleColor = barColor
        urlFields.selectedLineColor = barColor
        urlFields.lineHeight = 1.0 // bottom line height in points
        urlFields.selectedLineHeight = 2.0
        
        
        
        
        
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        urlFields.resignFirstResponder()
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let finalPostVC = (segue.destination as? PostFinalViewController)!
        
        finalPostVC.postItemName = self.productName
        finalPostVC.postItemCategory = self.productCategory
        finalPostVC.itemImage = self.mainImagePhoto
        
        if self.urlFields.text != nil && self.urlFields.text != ""  {
            finalPostVC.itemUrl = self.urlFields.text
        }
        
        
        
        
    }
    
    @IBAction func ToKeepOn(_ sender: Any) {
        
        
        
        if mainImagePhoto.image != nil  {
            
            
            performSegue(withIdentifier: "ToFinPosts", sender: nil)
            
            
            
            
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
