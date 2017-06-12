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
