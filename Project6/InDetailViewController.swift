//
//  InDetailViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/07.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

class InDetailViewController: UIViewController {
    
    
    @IBOutlet weak var detailNavBar: UINavigationBar!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postContent: UILabel!
    @IBOutlet weak var postUserName: UILabel!
    @IBOutlet weak var postUserImage: ProfileImage!
    private let postsRef = FIRDatabase.database().reference().child("posts")
    var ref = FIRDatabaseReference()
    let snapshot = FIRDataSnapshot()
    
    
    //データ受け継ぎ用
    
    var name: String?
    var numLikes = Int()
    var whatContent: String?
    var imageURL: String?
    var linkURL: String?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cardView.layer.cornerRadius = 15
        
        //画像の読み込み
        postImage.af_setImage(withURL: URL(string: imageURL!)!)
        
        //その他データ
        postTitle.text = name
        postContent.text = whatContent
        
        
    
        

    }
    
    
    
    
    @IBAction func likeButtonDidTap(_ sender: Any) {
        
      
        
        
    }
    
    

    @IBAction func backButtonDidTap(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    

}


