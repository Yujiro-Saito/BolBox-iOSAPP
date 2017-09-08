//
//  CreateFolderViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/06.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import FirebaseAuth

class CreateFolderViewController: UIViewController,UITextFieldDelegate {
    
    
    
    @IBAction func createDidTap(_ sender: Any) {
        
        
        
        
        let actionSheet = UIAlertController(title: "アクション", message: "フォルダの作成 写真 リンク", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let folder = UIAlertAction(title: "フォルダを作成", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            //folderNameに投稿
            let currentUserUID = FIRAuth.auth()?.currentUser?.uid
            
            let folderName = self.nameTextField.text
            let folderNameDic: Dictionary<String, String> = [folderName! : folderName!]
            //let folderImageDic: Dictionary<String, String> = ["folderImage" : ""]
            
            DataService.dataBase.REF_BASE.child("users/\(currentUserUID!)/folderName").updateChildValues(folderNameDic)
            //DataService.dataBase.REF_BASE.child("users/\(currentUserUID!)/folderImageURL").updateChildValues(folderImageDic)
            
            //segue
            
        })
        
        let photo = UIAlertAction(title: "写真を追加する", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            self.performSegue(withIdentifier: "ToPhoto", sender: nil)
            
            
        })
        
        let link = UIAlertAction(title: "リンクを追加する", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            self.performSegue(withIdentifier: "ToLink", sender: nil)
        })
        
        
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
        })
        
        actionSheet.addAction(folder)
        actionSheet.addAction(photo)
        actionSheet.addAction(link)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
        
      
        
        
    }
    
    @IBAction func cancelDidTap(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var cancel: UIButton!
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        self.view.bringSubview(toFront: createButton)
        
        //テキスト
        nameTextField.placeholder = "フォルダ名を入力"
        nameTextField.title = "フォルダ名"
        nameTextField.tintColor = UIColor.clear
        nameTextField.textColor = UIColor.white
        nameTextField.lineColor = UIColor.white
        nameTextField.selectedTitleColor = .white
        nameTextField.selectedLineColor = .white
        nameTextField.lineHeight = 1.0
        nameTextField.selectedLineHeight = 2.0

    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nameTextField.resignFirstResponder()
        
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
