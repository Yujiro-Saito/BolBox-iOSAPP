//
//  SignInandUpViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/11.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInandUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func registerButtonDidTap(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "登録", message: "方法", preferredStyle: UIAlertControllerStyle.actionSheet)
        let action1 = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            print("アクション１をタップした時の処理")
        })
        
        let action2 = UIAlertAction(title: "Google", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            print("アクション２をタップした時の処理")
        })
        
        let action3 = UIAlertAction(title: "メールアドレス", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            print("アクション３をタップした時の処理")
        })
        
        let action4 = UIAlertAction(title: "電話番号", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            print("アクション4をタップした時の処理")
        })

        
        
        
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
            print("キャンセルをタップした時の処理")
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

  


