//
//  CategoryHeaderCollectionReusableView.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/03.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase

class CategoryHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var categorySegment: UISegmentedControl!
    
    let toCategoryVC = CategoryCollectionViewController()
    
    @IBAction func segmentTapped(_ sender: Any) {
        
        let segmentedNum = categorySegment.selectedSegmentIndex
        
        switch segmentedNum {
        case 0:
            print("0")
            toCategoryVC.selectedSegmentNum = 0
        case 1:
            print("1")
            toCategoryVC.selectedSegmentNum = 1
        case 2:
            print("2")
            toCategoryVC.selectedSegmentNum = 2
        default:
            print("3")
        }
        
        
        
    }
    
        
}
