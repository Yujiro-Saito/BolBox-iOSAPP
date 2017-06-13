//
//  SignUpViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/13.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController , UITextFieldDelegate{
    
    
    @IBOutlet weak var emailField: SignUpField!
    @IBOutlet weak var passwordField: SignUpField!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        self.emailField.becomeFirstResponder()

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
    
    
    
    
    @IBAction func registerDidTap(_ sender: Any) {
        
        showIndicator()
        
        if emailField.text == nil || passwordField.text == nil{
            DispatchQueue.main.async {
                
                self.indicator.stopAnimating()
            }
            
            let alertViewControler = UIAlertController(title: "エラー", message: "もう一度入力してください", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertViewControler.addAction(okAction)
            present(alertViewControler, animated: true, completion: nil)
            
            
            
        } else {
            
            //新規ユーザー登録
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password:passwordField.text! , completion: { (user, error) in
                
                
                if error == nil{
                    
                    //成功
                    print("登録完了しました")
                    
                    
                    
                    UserDefaults.standard.set("check", forKey: "check")
                    
                    
                    
                    user?.sendEmailVerification(completion: { (error) in
                        
                        if error == nil {
                            //Send Email
                            
                            
                        } else {
                            
                            print("\(error?.localizedDescription)")
                            
                        }
                        
                        
                        
                    })
                    
                    
                    
                    if let user = user {
                        let userData = ["provider" : user.providerID]
                        let userName = ["userName" : ""]
                        let userPhotoURl = ["photoURL" : ""]
                        
                        print("データ: \(userData)")
                        print("名前: \(userName)")
                        print("画像URL: \(userPhotoURl)")
                        
                        self.completeSignUp(id: user.uid, userData: userData, userName: userName, photoURL: userPhotoURl)
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.indicator.stopAnimating()
                    }
                    
                    self.performSegue(withIdentifier: "ToFeed", sender: nil)
                    
                    
                }else{
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
    
    
    
    func completeSignUp(id: String, userData: Dictionary<String,String>,userName: Dictionary<String, String>, photoURL: Dictionary<String, String>) {
        
        DataService.dataBase.createDataBaseUser(uid: id, userData: userData, userName: userName, photoURL: photoURL)
        
        
    }
    
    

   
}
