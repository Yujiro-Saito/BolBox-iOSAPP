//
//  SignInandUpViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/11.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInandUpViewController: UIViewController,GIDSignInUIDelegate {
    
    
    
    
    let appDelegateAccess = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        print("真偽判定")
        
        if appDelegateAccess.googleSuccessful == true {
            googleLogin()
        } else {
            print("登録の未完了")
        }
       
        
        
        
    }

    
    func googleLogin() {
        
        UserDefaults.standard.set("GoogleRegister", forKey: "GoogleRegister")
        UserDefaults.standard.set("AutoLogin", forKey: "AutoLogin")
        self.performSegue(withIdentifier: "ToHomeView", sender: nil)
    }
    
    
    
    
    
    
    @IBAction func registerButtonDidTap(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "登録", message: "方法", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let google = UIAlertAction(title: "Google", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().signIn()
            
            
            
            
            
        })
        
        let email = UIAlertAction(title: "メールアドレス", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            self.performSegue(withIdentifier: "EmailSignUp", sender: nil)
            
            
        })
        
        
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
        })
        
        actionSheet.addAction(google)
        actionSheet.addAction(email)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
        
    }
    
    
    @IBAction func signInButtonDidtap(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "ログイン", message: "方法", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let google = UIAlertAction(title: "Google", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            
            
            
            
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().signIn()
            
            
            
            
            
            
        })
        
        let email = UIAlertAction(title: "メールアドレス", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            //self.performSegue(withIdentifier: "EmailSignUp", sender: nil)
            
            
        })
        
        
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
        })
        
        actionSheet.addAction(google)
        actionSheet.addAction(email)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
        
        
    }
    
        
        
    @IBAction func signInAnonymously(_ sender: Any) {
        
        /*
        FIRAuth.auth()!.signInAnonymously { (firUser, error) in
            if error == nil {
                print("スキップしました")
            } else {
                print(error?.localizedDescription)
            }
        }
 
 */
        
        performSegue(withIdentifier: "ToHomeView", sender: nil)
        
    }
    
}

  


