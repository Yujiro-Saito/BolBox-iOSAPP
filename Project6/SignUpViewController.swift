//
//  SignUpViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/13.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SignUpViewController: UIViewController , UITextFieldDelegate{
    
    
    @IBOutlet weak var emailField: SignUpField!
    @IBOutlet weak var passwordField: SignUpField!
    @IBOutlet weak var userNameField: SignUpField!
    
    
    var initialURL = URL(string: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        userNameField.delegate = self
        
        self.userNameField.becomeFirstResponder()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        userNameField.resignFirstResponder()
        
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
        
        if emailField.text == nil || passwordField.text == nil || userNameField == nil {
            
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
                    
                    //GuestUserの削除
                    if UserDefaults.standard.object(forKey: "GuestUser") != nil {
                        let userDefaults = UserDefaults.standard
                        userDefaults.removeObject(forKey: "GuestUser")
                    }
                    
                    
                    
                    UserDefaults.standard.set("EmailRegister", forKey: "EmailRegister")
                    UserDefaults.standard.set("AutoLogin", forKey: "AutoLogin")
                    
                    if let user = user {
                        
                        
                        
                        
                        let changeRequest = user.profileChangeRequest()
                        
                        changeRequest.displayName = self.userNameField.text
                        changeRequest.photoURL = self.initialURL
                        
                        changeRequest.commitChanges { error in
                            if let error = error {
                                // An error happened.
                                print(error.localizedDescription)
                            } else {
                                print("プロフィールの登録完了")
                                print(user.displayName!)
                                print(user.email!)
                                
                                
                            }
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        let userData = ["provider" : user.providerID]
                        let name = ["userName" : user.displayName]
                        let email = ["email" : user.email]
                        let photoUrl = ["photoURL" : ""]
                        
                        print("データ: \(userData)")
                        print("名前: \(name)")
                        print("Eメール: \(email)")
                        print("画像URL: \(photoUrl)")
                        
                        self.completeSignUp(id: user.uid, userData: userData, userName: name, userEmail: email, photoURL: photoUrl)
                        
                       
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.indicator.stopAnimating()
                    }
                    
                    user?.sendEmailVerification(completion: { (error) in
                        
                        if error == nil {
                            //Send Email
                            let alertViewControler = UIAlertController(title: "認証メールを送信しました!", message: "アカウントの認証をお願いします", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            
                            alertViewControler.addAction(okAction)
                            self.present(alertViewControler, animated: true, completion: nil)

                            
                            
                        } else {
                            
                            print("\(error?.localizedDescription)")
                            
                        }
                        
                        
                        
                        
                        
                    })

                    self.performSegue(withIdentifier: "registerGoGo", sender: nil)
                    
                    
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "RealUserDone" {
            
            let accountVc = (segue.destination as? AccountViewController)!
            
            accountVc.realUserName = self.userNameField.text
            
            
            
            
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
    
    
    
    func completeSignUp(id: String, userData: Dictionary<String,String>,userName: Dictionary<String,Any>,userEmail: Dictionary<String,Any>, photoURL: Dictionary<String,Any>) {
        
        DataService.dataBase.createDataBaseUser(uid: id, userData: userData, userName: userName, photoURL: photoURL, userEmail: userEmail)
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Data saved to keychain \(keychainResult)")
        
        
    }
    
    

   
}
