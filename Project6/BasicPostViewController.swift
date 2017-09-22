//
//  BasicPostViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/22.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class BasicPostViewController: UIViewController {
    
    var trackName: String!
    var previewUrl: String?
    var imageURL: String!
    var appLink: String?
    var appDesc: String?
    
    
    @IBOutlet weak var desc: UILabel!
    
    
    @IBOutlet weak var itemImage: UIImageView!

    @IBOutlet weak var itemName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageDefURL = URL(string: imageURL)
        self.itemImage.af_setImage(withURL: imageDefURL!)
        self.itemName.text = trackName
        
        self.itemImage.layer.masksToBounds = true
        self.itemImage.layer.cornerRadius = 20
        
        self.desc.text = appDesc
        
        
    }

    

}
