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
    var userName: String?
    var userImageURL: String?
    var userID: String!
    
    
    //データ飛ばすよう　ユーザーページ
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "userData" {
            let userProfileVc = (segue.destination as? UserProfileViewController)!
            
            userProfileVc.userName = self.userName
            userProfileVc.userImageURL = self.userImageURL
            userProfileVc.userID = self.userID

        } else if segue.identifier == "webview" {
            
            
            let webviewVc = (segue.destination as? WebViewController)!
            
            
            webviewVc.postUrl = self.linkURL
            
            
        }
        
        
        
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cardView.layer.cornerRadius = 15
        
        if userImageURL != nil && userName != nil {
            
            
            //画像の読み込み
            postUserImage.af_setImage(withURL: URL(string: userImageURL!)!)
        }
        
        postImage.af_setImage(withURL: URL(string: imageURL!)!)
        postUserName.text = userName

        //その他データ
        postTitle.text = name
        postContent.text = whatContent
        

    }
    
    
    
    @IBAction func goSeeButtonDidTap(_ sender: Any) {
        
        performSegue(withIdentifier: "webview", sender: nil)
        
    }
    
    
    @IBAction func userProfileButtonDidTap(_ sender: Any) {
        performSegue(withIdentifier: "userData", sender: nil)
    }
    

    @IBAction func backButtonDidTap(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    

}


