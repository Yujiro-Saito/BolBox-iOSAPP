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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
       

    }
    
    
     
    
    
    
    @IBAction func registerButtonDidTap(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "登録", message: "方法", preferredStyle: UIAlertControllerStyle.actionSheet)
        let action1 = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
        })
        
        let action2 = UIAlertAction(title: "Google", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().signIn()
            
            
        })
        
        let action3 = UIAlertAction(title: "メールアドレス", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            self.performSegue(withIdentifier: "EmailSignUp", sender: nil)
            
        })
        
        let action4 = UIAlertAction(title: "電話番号", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
        })

        
        
        
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
        })
        
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        actionSheet.addAction(action4)
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

  


