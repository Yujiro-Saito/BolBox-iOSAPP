//
//  StoryViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/23.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController,UITextViewDelegate {
    
    
    @IBOutlet weak var storyText: UITextView!
    
    
    //データ引き継ぎ用
    
    var detailImages = [UIImage]()
    var detailOne = UIImage()
    var name = String()
    var url = String()
    var categoryTitle = String()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        storyText.delegate = self
        
        
        storyText.text = ""
        storyText.becomeFirstResponder()
        
        
        
        
        
        
        print("投稿データの詳細データ")
        print(name)
        print(categoryTitle)
        print(detailImages)
        
        

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func PostButtonDidTap(_ sender: Any) {
        
        let alertViewControler = UIAlertController(title: "投稿を行います", message: "よろしいですか", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertViewControler.addAction(okAction)
        present(alertViewControler, animated: true, completion: nil)
        
        
        
        
    }
    
    
    
    

}
