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
import SafariServices

class InDetailViewController: UIViewController {
    
    
    @IBOutlet weak var userToButton: ZFRippleButton!
    @IBOutlet weak var detailNavBar: UINavigationBar!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postContent: UILabel!
    @IBOutlet weak var postUserName: UILabel!
    @IBOutlet weak var postUserImage: ProfileImage!
    @IBOutlet weak var goseeButton: ZFRippleButton!
    
    
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
    var userDescription: String?
    
    
    
    //データ飛ばすよう　ユーザーページ
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "userData" {
            let userProfileVc = (segue.destination as? UserProfileViewController)!
            
            userProfileVc.userName = self.userName
            userProfileVc.userImageURL = self.userImageURL
            userProfileVc.userID = self.userID

        } else if segue.identifier == "webview" {
            
            
            let webviewVc = (segue.destination as? WebViewController)!
            
            
            webviewVc.postUrl = self.linkURL!
            
            
        }
        
        
        
    }

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cardView.layer.cornerRadius = 15
        
        
        
        if userImageURL != nil && userName != nil {
            
            
            
            
            //画像の読み込み
            postUserImage.af_setImage(withURL: URL(string: userImageURL!)!)
            
            
            
        } else if userImageURL == nil && userName == nil {
            //メディア記事の場合
            self.userToButton.isHidden = true
            self.userToButton.isEnabled = false
            
            self.postUserName.isHidden = true
            self.postUserImage.isHidden = true
            
            
            
        }
        
        postImage.af_setImage(withURL: URL(string: imageURL!)!)
        postUserName.text = userName
        
        //その他データ
        postTitle.text = name
        postContent.text = whatContent
        
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if self.linkURL == "" {
            self.goseeButton.isHidden = true
        }
        
        
        
        
        
    }
    
    
    @IBAction func goSeeButtonDidTap(_ sender: Any) {
        
        
        let targetURL = self.linkURL
        let encodedURL = targetURL?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        //URL正式
        guard let finalUrl = URL(string: encodedURL!) else {
            print("無効なURL")
            return
        }
        
        
        if (encodedURL?.contains("https"))! || (encodedURL?.contains("http"))! {
            
            //httpかhttpsで始まってるか確認
            if (encodedURL?.hasPrefix("https"))! || (encodedURL?.hasPrefix("http"))! {
                //http(s)で始まってる場合safari起動
                let safariVC = SFSafariViewController(url: finalUrl)
                self.present(safariVC, animated: true, completion: nil)
                
            }
                //Httpsの場合
                else if let range = encodedURL?.range(of: "https") {
                    let startPosition = encodedURL?.characters.distance(from: (encodedURL?.characters.startIndex)!, to: range.lowerBound)
                
                    //4番目から最後までをURLとして扱う
                    
                    let indexNumber = startPosition
                    
                    let validURLString = (encodedURL?.substring(with: (encodedURL?.index((encodedURL?.startIndex)!, offsetBy: indexNumber!))!..<(encodedURL?.index((encodedURL?.endIndex)!, offsetBy: 0))!))
                    
                    let validURL = URL(string: validURLString!)
                

                    //safari起動
                let safariVC = SFSafariViewController(url: validURL!)
                self.present(safariVC, animated: true, completion: nil)
                
                    
            } else if let httpRange = encodedURL?.range(of: "http") {
                //Httpの場合
                let startPosition = encodedURL?.characters.distance(from: (encodedURL?.characters.startIndex)!, to: httpRange.lowerBound)
                
                //4番目から最後までをURLとして扱う
                
                let indexNumber = startPosition
                
                let validURLString = (encodedURL?.substring(with: (encodedURL?.index((encodedURL?.startIndex)!, offsetBy: indexNumber!))!..<(encodedURL?.index((encodedURL?.endIndex)!, offsetBy: 0))!))
                
                let validURL = URL(string: validURLString!)
                
                //safari起動
                let safariVC = SFSafariViewController(url: validURL!)
                self.present(safariVC, animated: true, completion: nil)
                
                
                
                
                
                
            }
        
        else {
                   }
        
       
        } else {
            //そもそもhttp(s)がない場合
            print("無効なURL")
            //アラート表示
            let alertController = UIAlertController(title: "エラー", message: "URLが無効なようです", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) {
                (action) in
                self.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            
            
            
        }
        
        
        
        
    }
    
    
    @IBAction func userProfileButtonDidTap(_ sender: Any) {
        performSegue(withIdentifier: "userData", sender: nil)
    }
    

    @IBAction func backButtonDidTap(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    

}


