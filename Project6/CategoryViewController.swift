//
//  CategoryViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/20.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var categoryItemTable: UITableView!
    @IBOutlet weak var sections: UISegmentedControl!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryItemTable.delegate = self
        categoryItemTable.dataSource = self
        

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = categoryItemTable.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? CategoryItemTableViewCell {
            
            
            cell.itemImage.image = UIImage(named: "game")
            cell.itemName.text = "Horizon Chase"
            cell.itemStarNum.text = "32"
            cell.itemCategory.text = "ゲーム"
            cell.itemWhatContent.text = "０年代人気があったアウトラン、ロータスターボチャレンジ、トップギア（SNES）やラッシュなどのゲームに触発されたカーレースゲームです。ホライズンチェースの各周回の各カーブで古典的なアーケード ゲームをプレイしている気分で、速度制限のないスピードと楽しみが待っています。アクセルを踏んで楽しんでください。"
            
            
        }
        
        
        
        
        return UITableViewCell()
    }

    

}
