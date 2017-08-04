//
//  EmailPasswordViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/08/04.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class EmailPasswordViewController: UIViewController,UITextFieldDelegate {
    
    
    
    
    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmField: SkyFloatingLabelTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        confirmField.delegate = self
        
        
        //メールアドレス
        emailField.placeholder = "メールアドレス"
        emailField.title = "メールアドレス"
        emailField.tintColor = barColor
        emailField.textColor = UIColor.darkGray
        emailField.lineColor = UIColor.lightGray
        emailField.selectedTitleColor = barColor
        emailField.selectedLineColor = barColor
        emailField.lineHeight = 1.0 // bottom line height in points
        emailField.selectedLineHeight = 2.0
        
        
        //パスワード
        passwordField.placeholder = "パスワード"
        passwordField.title = "パスワード"
        passwordField.tintColor = barColor
        passwordField.textColor = UIColor.darkGray
        passwordField.lineColor = UIColor.lightGray
        passwordField.selectedTitleColor = barColor
        passwordField.selectedLineColor = barColor
        passwordField.lineHeight = 1.0 // bottom line height in points
        passwordField.selectedLineHeight = 2.0
        
        
        //パスワード確認
        confirmField.placeholder = "パスワード確認"
        confirmField.title = "パスワード確認"
        confirmField.tintColor = barColor
        confirmField.textColor = UIColor.darkGray
        confirmField.lineColor = UIColor.lightGray
        confirmField.selectedTitleColor = barColor
        confirmField.selectedLineColor = barColor
        confirmField.lineHeight = 1.0 // bottom line height in points
        confirmField.selectedLineHeight = 2.0
        
        
        
        

    }
    
    
    @IBAction func goNextButton(_ sender: Any) {
        
        if self.emailField.text != nil && self.passwordField.text != nil && self.confirmField.text != nil {
            
            if self.passwordField.text == self.confirmField.text {
                //
                
                performSegue(withIdentifier: "TocompleteRegister", sender: nil)
                
            } else {
                //渓谷
                
                let alertViewControler = UIAlertController(title: "エラー", message: "パスワードの入力にエラーがあります", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertViewControler.addAction(okAction)
                self.present(alertViewControler, animated: true, completion: nil)
                
                
                
                
            }
            
            
        }
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let signUpVc = (segue.destination as? SignUpViewController)!
        
        signUpVc.email = self.emailField.text!
        signUpVc.password = self.passwordField.text!
        
        
        
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        confirmField.resignFirstResponder()
        
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
