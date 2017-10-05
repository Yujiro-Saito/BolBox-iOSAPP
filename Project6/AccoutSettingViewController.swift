//
//  AccoutSettingViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/10/03.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SafariServices

class AccoutSettingViewController: UIViewController,GIDSignInUIDelegate{

    
    let appDelegateAccess = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBAction func googleButtonTapped(_ sender: Any) {
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    @IBAction func policyButtonDidTap(_ sender: Any) {
        
        
        let finalURL = URL(string: "https://peraichi.com/landing_pages/view/66yls")
        
        let safariVC = SFSafariViewController(url: finalURL!)
        self.present(safariVC, animated: true, completion: nil)
        
        
        
    }
    @IBOutlet weak var googleLabel: UILabel!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = FIRAuth.auth()?.currentUser?.displayName
        print(user)
        
        self.googleLabel.layer.masksToBounds = true
        self.googleLabel.layer.cornerRadius = 20.0
        
        
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        self.wait( {self.appDelegateAccess.googleSuccessful == false} ) {
            
            let photos = FIRAuth.auth()?.currentUser?.photoURL
            let photoStr = String(describing: photos!)
            
            let userData = ["userName" : FIRAuth.auth()?.currentUser?.displayName!, "email" : FIRAuth.auth()?.currentUser?.email,"userImageURL" : photoStr,  "uid" : FIRAuth.auth()?.currentUser?.uid, "followerNum" : 0,"followingNum" : 0] as [String : Any]
            
            //DBに追記
            DataService.dataBase.REF_BASE.child("users/\(FIRAuth.auth()!.currentUser!.uid)").updateChildValues(userData)
            
        
            
            
            self.appDelegateAccess.googleSuccessful = false
            
            
            
            self.performSegue(withIdentifier: "ToHommiy", sender: nil)
            
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    func wait(_ waitContinuation: @escaping (()->Bool), compleation: @escaping (()->Void)) {
        var wait = waitContinuation()
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            while wait {
                DispatchQueue.main.async {
                    wait = waitContinuation()
                    semaphore.signal()
                }
                semaphore.wait()
                Thread.sleep(forTimeInterval: 1.5)
            }
            DispatchQueue.main.async {
                compleation()
                
                
                
            }
        }
    }
    
    
    
    
    
}
