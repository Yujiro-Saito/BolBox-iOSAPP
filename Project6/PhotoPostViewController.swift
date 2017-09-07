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
    /*
    @IBOutlet weak var url: SkyFloatingLabelTextField!
    @IBOutlet weak var caption: SkyFloatingLabelTextField!*/
    var mainImageBox = UIImage()
    
    //データ引き継ぎ用
    var folderName = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.hidesBarsOnSwipe = true

        
        tableView.frame = CGRect(x: 0, y: 135, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        form +++ Section("登録")
            <<< TextRow(){ row in
                row.title = "リンク"
                row.placeholder = "コピーしたリンクを貼り付けてください"
            }
            <<< TextRow(){ row in
                row.title = "メモ"
                row.placeholder = "メモを記入してください"
        }
        
        /*
        caption.delegate = self
        url.delegate = self
        
        //memo
        caption.placeholder = "メモを追加"
        caption.title = "メモ"
        caption.tintColor = UIColor.clear
        caption.textColor = UIColor.white
        caption.lineColor = UIColor.white
        caption.selectedTitleColor = .white
        caption.selectedLineColor = .white
        caption.lineHeight = 1.0
        caption.selectedLineHeight = 2.0
        
        
        //url
        url.placeholder = "リンクを追加"
        url.title = "リンク"
        url.tintColor = UIColor.clear
        url.textColor = UIColor.white
        url.lineColor = UIColor.white
        url.selectedTitleColor = .white
        url.selectedLineColor = .white
        url.lineHeight = 1.0
        url.selectedLineHeight = 2.0
        
        
        */

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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
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
    
   
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    */
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                self.mainImageBox = image
                
                self.postPhoto.image = self.mainImageBox
                
                
            }
            
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
   
   

}
