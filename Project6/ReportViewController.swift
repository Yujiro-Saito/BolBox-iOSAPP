//
//  ReportViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/08/14.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase

class ReportViewController: UIViewController,UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reportText.delegate = self
       
        /*
        //メールアドレス
        reportText.placeholder = "具体的な投稿内容やユーザー名など"
        reportText.title = "報告"
        reportText.tintColor = barColor
        reportText.textColor = UIColor.darkGray
        reportText.lineColor = UIColor.lightGray
        reportText.selectedTitleColor = barColor
        reportText.selectedLineColor = barColor
        reportText.lineHeight = 1.0 // bottom line height in points
        reportText.selectedLineHeight = 2.0
*/

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        reportText.resignFirstResponder()
        
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
    
    
    @IBOutlet weak var reportText: UITextField!
    
    @IBAction func sendButtonDidTap(_ sender: Any) {
        
        //FBに送信
        //Emailアドレス(あれば)、ユーザー名、テキストの内容
        let currentUserName = FIRAuth.auth()?.currentUser?.displayName
        let currentUserEmail = FIRAuth.auth()?.currentUser?.email
        
        
        let reportData = ["userName" : currentUserName, "Email" : currentUserName, "reportContent" : self.reportText.text]
        
        DataService.dataBase.REF_BASE.child("reports/\(currentUserName)").setValue(reportData)
        
        
        
    }
    
    
    
    
    


}
