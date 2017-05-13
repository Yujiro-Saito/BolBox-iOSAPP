//
//  HomeViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/13.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var menuItem: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenu()

    }

   
    func sideMenu() {
        
        if revealViewController() != nil {
            
            menuItem.target = revealViewController()
            menuItem.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
        }

        
        
        
        
        
    }

    

}
