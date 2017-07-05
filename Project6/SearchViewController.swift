//
//  SearchViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/05.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class SearchViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        
        //バーの色
        settings.style.buttonBarBackgroundColor = UIColor(red: 73/255, green: 72/255, blue: 62/255, alpha: 1)
        //ボタンの色
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 73/255, green: 72/255, blue: 62/255, alpha: 1)
        //セルの文字色
        settings.style.buttonBarItemTitleColor = UIColor.white
        //セレクトバーの色
        settings.style.selectedBarBackgroundColor = UIColor(red: 254/255, green: 0, blue: 124/255, alpha: 1)
        
        
        super.viewDidLoad()

    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        //管理されるViewControllerを返す処理
        let oneVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "one")
        let twoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "two")
        let threeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "three")
        let fourVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "four")
        let fiveVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "five")
        
        let childViewControllers:[UIViewController] = [oneVC, twoVC, threeVC,fourVC,fiveVC]
        return childViewControllers
    }

}
