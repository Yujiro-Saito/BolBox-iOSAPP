//
//  SlideViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/19.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class SlideViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var categoryTable: UITableView!
    
    let categoryName = ["ゲーム","メディア","ショッピング","テクノロジー","旅","食","エンターテイメント"]
    let categoryImages = ["game1","news","shopping","tech","travel2","food","entertainment"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTable.delegate = self
        categoryTable.dataSource = self

    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if let cell = categoryTable.dequeueReusableCell(withIdentifier: "catCell", for: indexPath) as? CategoryTableViewCell {
            
            cell.categoryName.text = categoryName[indexPath.row]
            cell.categoryImage.image = UIImage(named: categoryImages[indexPath.row])
            
            
            return cell

            
        }
        
        return UITableViewCell()
        
            }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryName.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    

  
}
