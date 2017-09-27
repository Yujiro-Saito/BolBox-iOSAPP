//
//  YoutubePostViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/27.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import AlamofireImage

class YoutubePostViewController: UIViewController {

    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var imageURL = String()
    var titleString = String()
    var videoCode = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("diejdijede")
        print(imageURL)
        print(titleString)
        print(videoCode)
        let url = URL(string: imageURL)
        
        self.titleLabel.text = titleString
        self.bgImage.af_setImage(withURL: url!)
        self.mainImage.af_setImage(withURL: url!)
        
        

    }

   

}
