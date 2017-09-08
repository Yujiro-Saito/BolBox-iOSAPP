//
//  LinkPostViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/06.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage
import Eureka
//import SkyFloatingLabelTextField

class LinkPostViewController: FormViewController {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.hidesBarsOnSwipe = true
        
        //データ引き継ぎ用
        //var folderName = String()

        //tableView.backgroundColor = UIColor.rgb(r: 69, g: 113, b: 144, alpha: 1.0)
        
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        
        form +++ Section("登録")
            <<< TextRow(){ row in
                row.title = "リンク"
                row.placeholder = "コピーしたリンクを貼り付けてください"
            }
            <<< TextRow(){ row in
                row.title = "メモ"
                row.placeholder = "メモを記入してください"
        }
        
    }
    
    


}
