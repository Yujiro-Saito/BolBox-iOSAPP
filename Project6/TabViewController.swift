//
//  TabViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/26.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit


class TabViewController: UITabBarController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        self.selectedIndex = 0
        
        
        
        tabBar.tintColor = barColor
        
        
       
        
        
       
    }
    
    
    
    
    
    
    //ボタン押下時の呼び出しメソッド
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //バッチを消す
        item.badgeValue = nil
    }
    
    
    
}
