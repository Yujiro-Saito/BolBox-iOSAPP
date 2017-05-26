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
    
    let categoryName = ["ゲーム","メディア","教育・学習","テクノロジー","旅","仕事","エンターテイメント"]
    let categoryImages = ["game1","news","shopping","tech","travel2","food","entertainment"]
    var selectedItemRow = Int()

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            print("ゲーム")
            selectedItemRow = 0
            performSegue(withIdentifier: "ToCategoryVC", sender: nil)
        case 1:
            print("メディア")
            selectedItemRow = 1
            performSegue(withIdentifier: "ToCategoryVC", sender: nil)
        case 2:
            print("教育・学習")
            selectedItemRow = 2
            performSegue(withIdentifier: "ToCategoryVC", sender: nil)
        case 3:
            print("テクノロジー")
            selectedItemRow = 3
            performSegue(withIdentifier: "ToCategoryVC", sender: nil)
        case 4:
            print("旅")
            selectedItemRow = 4
            performSegue(withIdentifier: "ToCategoryVC", sender: nil)
        case 5:
            print("仕事")
            selectedItemRow = 5
            performSegue(withIdentifier: "ToCategoryVC", sender: nil)
        case 6:
            print("エンターテイメント")
            selectedItemRow = 6
            performSegue(withIdentifier: "ToCategoryVC", sender: nil)
        default:
            print("")
        }

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToCategoryVC") {
            
            let categoryVc = (segue.destination as? CategoryViewController)!
            
            categoryVc.selectedRowNum = selectedItemRow
            
            
        }
        
        
        
    }
}
