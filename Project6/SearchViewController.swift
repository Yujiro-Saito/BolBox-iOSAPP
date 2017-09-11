//
//  SearchViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/05.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class SearchViewController: ButtonBarPagerTabStripViewController,UINavigationBarDelegate {
    
    
    
    @IBOutlet weak var categoryLabel: ButtonBarView!
    var folderString = String()
    

    override func viewDidLoad() {
        
        
        //バーの色
        settings.style.buttonBarBackgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        //ボタンの色
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        //セルの文字色
        settings.style.buttonBarItemTitleColor = UIColor.darkGray
        //セレクトバーの色
        settings.style.selectedBarBackgroundColor = UIColor(red: 31/255.0, green: 158/255.0, blue: 187/255.0, alpha: 1.0)

        
        
        
        //Font size
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 17)
        
        //Selected bar line height
        settings.style.selectedBarHeight = 5
        
        
        
        super.viewDidLoad()
        
        print("のおおおおおおおお")
        print(folderString)
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.hidesBarsOnSwipe = true
       
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        //管理されるViewControllerを返す処理
        let imageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "images")
        let linkVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "link")
        let childViewControllers:[UIViewController] = [imageVC, linkVC]
        return childViewControllers
    }

}
