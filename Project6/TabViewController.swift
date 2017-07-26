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
        
       /////////////////--------------
        
        //最初通知にこっそり移動
        //画面白
        self.selectedIndex = 2
        
        
        
        
       
    }
    
    
    
    
    
    
    //ボタン押下時の呼び出しメソッド
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //バッチを消す
        item.badgeValue = nil
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




}
