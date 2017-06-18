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
    
    
    var signIn = false
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if self.signIn == true {
            
            googleLogin()
            
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
                

    }
    
    
    func googleLogin() {
        
        UserDefaults.standard.set("register", forKey: "register")
        UserDefaults.standard.set("Pop", forKey: "Pop")
        self.performSegue(withIdentifier: "ToHomeView", sender: nil)
    }
    
    
    
    
    @IBAction func registerButtonDidTap(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "登録", message: "方法", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let google = UIAlertAction(title: "Google", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            
            self.signIn = true
            
        
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

  


