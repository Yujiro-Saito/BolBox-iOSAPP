//
//  AccountViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/27.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController,UINavigationBarDelegate {
    
    
    @IBOutlet weak var profileNavBar: UINavigationBar!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileImage: ProfileImage!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileNavBar.delegate = self
        
        self.profileNavBar.frame = CGRect(x: 0,y: 0, width: UIScreen.main.bounds.size.width, height: 55)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if FIRAuth.auth()?.currentUser != nil {
            // User is signed in.
            
            let user = FIRAuth.auth()?.currentUser
            
            let userName = user?.displayName
            let photoURL = user?.photoURL
            
            
            self.profileName.text = userName
            
            if photoURL == nil {
                profileImage.image = UIImage(named: "drop")
            } else {
                profileImage.af_setImage(withURL: photoURL!)
            }
            
            
            
        } else {
            // No user is signed in.
            print("ユーザーがいません")
        }

    }

}
