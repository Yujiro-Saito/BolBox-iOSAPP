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
        //folderNameに投稿
        let currentUserUID = FIRAuth.auth()?.currentUser?.uid
        
        let folderName = self.nameTextField.text
        let folderNameDic: Dictionary<String, String> = [folderName! : folderName!]
        let folderImageDic: Dictionary<String, String> = ["folderImage" : ""]
        
        DataService.dataBase.REF_BASE.child("users/\(currentUserUID!)/folderName").updateChildValues(folderNameDic)
        DataService.dataBase.REF_BASE.child("users/\(currentUserUID!)/folderImageURL").updateChildValues(folderImageDic)
        
        //segue
        
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
