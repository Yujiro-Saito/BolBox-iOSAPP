//
//  LinkPostViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/06.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage
import SkyFloatingLabelTextField

class LinkPostViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var linkField: SkyFloatingLabelTextField!
    @IBOutlet weak var memoField: SkyFloatingLabelTextField!
    
    //データ引き継ぎ用
    var folderName = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        linkField.delegate = self
        memoField.delegate = self
        
        
        
        //memo
        memoField.placeholder = "メモを追加"
        memoField.title = "メモ"
        memoField.tintColor = UIColor.clear
        memoField.textColor = UIColor.white
        memoField.lineColor = UIColor.white
        memoField.selectedTitleColor = .white
        memoField.selectedLineColor = .white
        memoField.lineHeight = 1.0
        memoField.selectedLineHeight = 2.0
        
        
        //url
        linkField.placeholder = "リンクを追加"
        linkField.title = "リンク"
        linkField.tintColor = UIColor.clear
        linkField.textColor = UIColor.white
        linkField.lineColor = UIColor.white
        linkField.selectedTitleColor = .white
        linkField.selectedLineColor = .white
        linkField.lineHeight = 1.0
        linkField.selectedLineHeight = 2.0

    }


    @IBAction func postButtonDidTap(_ sender: Any) {
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        linkField.resignFirstResponder()
        memoField.resignFirstResponder()
        
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
    

}
