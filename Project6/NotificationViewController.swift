//
//  NotificationViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/09.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController ,UINavigationBarDelegate{
    
    
    
    @IBOutlet weak var navBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.delegate = self
        
        //バーの高さ
        self.navBar.frame = CGRect(x: 0,y: 0, width: UIScreen.main.bounds.size.width, height: 60)
        
        self.view.bringSubview(toFront: navBar)

    }

    
    

    

}
