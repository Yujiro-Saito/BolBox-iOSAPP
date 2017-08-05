//
//  EmailLoginViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/20.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import SkyFloatingLabelTextField

class EmailLoginViewController: UIViewController,UITextFieldDelegate {
    
    
    
    
    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordField: SkyFloatingLabelTextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        
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


        
        
        
        
        
        
        
        
        
        
        

    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

   
    @IBAction func loginButtonDidTap(_ sender: Any) {
        
        showIndicator()
        
        
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password:passwordField.text! , completion: { (user, error) in
            
            
            
            if error == nil{
                print("ログインしました")
                
                if let user = user {
                    
                    
                    let userData = ["provider" : user.providerID]
                    self.completeLogin(id: user.uid, userData: userData)
                    
                    
                   
                    
                    DispatchQueue.main.async {
                        
                        self.indicator.stopAnimating()
                    }
                    
                    
                    self.performSegue(withIdentifier: "TotoGoHome", sender: nil)
                    
                    
                }
                
                
                
                
            }
                
                
                
            else{
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
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
        
        indicator.color = UIColor.darkGray
        
        indicator.hidesWhenStopped = true
        
        self.view.addSubview(indicator)
        
        self.view.bringSubview(toFront: indicator)
        
        indicator.startAnimating()
        
        
    }
    
    
    func completeLogin(id: String, userData: Dictionary<String,String>) {
        
        DataService.dataBase.loginUserDatabase(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Data saved to keychain \(keychainResult)")
        
    }

   
}
