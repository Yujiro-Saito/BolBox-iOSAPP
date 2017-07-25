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
        
        //trueになるまで待機すれば
        
        self.wait( {self.appDelegateAccess.googleSuccessful == false} ) {
            
            //登録完了してtrueになったら
            print("登録完了")
            
            self.appDelegateAccess.googleSuccessful = false
            
            self.googleLogin()
            
            
        }
        
        
        
        
    }

    
    func googleLogin() {
        
        
        
        //GuestUserの削除
        if UserDefaults.standard.object(forKey: "GuestUser") != nil {
            let userDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: "GuestUser")
        }
        
        
        UserDefaults.standard.set("GoogleRegister", forKey: "GoogleRegister")
        UserDefaults.standard.set("AutoLogin", forKey: "AutoLogin")
        
        
        
        
        self.performSegue(withIdentifier: "ToHomeView", sender: nil)
    }
    
    
    
    func wait(_ waitContinuation: @escaping (()->Bool), compleation: @escaping (()->Void)) {
        var wait = waitContinuation()
        // 0.01秒周期で待機条件をクリアするまで待ちます。
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            while wait {
                DispatchQueue.main.async {
                    wait = waitContinuation()
                    semaphore.signal()
                }
                semaphore.wait()
                Thread.sleep(forTimeInterval: 0.01)
            }
            // 待機条件をクリアしたので通過後の処理を行います。
            DispatchQueue.main.async {
                compleation()
                
                
                
            }
        }
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
            
            self.performSegue(withIdentifier: "emailLogin", sender: nil)
            
            
        })
        
        
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
        })
        
        actionSheet.addAction(google)
        actionSheet.addAction(email)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
        
        
    }
    
    
    
    @IBAction func goBackButtonDidTap(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
        
        
    @IBAction func signInAnonymously(_ sender: Any) {
        
        
        FIRAuth.auth()!.signInAnonymously { (firUser, error) in
            if error == nil {
                print("スキップ登録")
                UserDefaults.standard.set("GuestUser", forKey: "GuestUser")
                //UserDefaults.standard.set("AutoLogin", forKey: "AutoLogin")
                
                self.performSegue(withIdentifier: "ToHomeView", sender: nil)
            } else {
                print(error?.localizedDescription)
            }
        }
 
 
        
        
    }
    
}

  


