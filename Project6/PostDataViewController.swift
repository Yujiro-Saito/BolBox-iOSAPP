//
//  PostDataViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/31.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class PostDataViewController: UIViewController {
    
    
    //データ引き継ぎ用
    var pageViewCount: Int?
    var likesCount: Int?
    
    
    @IBOutlet weak var pageViewLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pageViewLabel.text = String(describing: pageViewCount)
        likesCountLabel.text = String(describing: likesCount)
        
        
        

    }

  

}
