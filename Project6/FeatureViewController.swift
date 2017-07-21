//
//  FeatureViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/20.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase


class FeatureViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate {
    
    @IBOutlet weak var featureTable: UITableView!
    @IBOutlet weak var featureNavbar: UINavigationBar!
    
    
    
    //データ引き継ぎ用
    var selectedNum: Int!
    
    
    //データ管理用
    var featureOnePosts = [Post]()
    var featureTwoPosts = [Post]()
    var featureThreePosts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        if selectedNum == 0 {
            //一つ目の記事を読み込み
            
            DataService.dataBase.REF_FEATUREONE.observe(.value, with: { (snapshot) in
                
                self.featureOnePosts = []
                
                print(snapshot.value)
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                                let key = snap.key
                                let post = Post(postKey: key, postData: postDict)
                                
                                self.featureOnePosts.append(post)
                                self.featureTable.reloadData()
                                
                           
                            
                        }
                    }
                    
                    
                }
                
                
                
                self.featureTable.reloadData()
                
            })
            
            
        } else if selectedNum == 1 {
            //二つ目の記事を読み込み
            
            
            
        } else if selectedNum == 2 {
            //三つ目の記事を読み込み
            
            
            
            
            
            
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        featureTable.delegate = self
        featureTable.dataSource = self
        
        featureNavbar.delegate = self
        
        //バーの高さ
        self.featureNavbar.frame = CGRect(x: 0,y: 0, width: UIScreen.main.bounds.size.width, height: 60)
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if selectedNum == 0 {
            
            let currentUserName = FIRAuth.auth()?.currentUser?.displayName
            
            
            let featureOneCell = featureTable.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as? FeatureTableViewCell
            
            
            
            featureOneCell?.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
            featureOneCell?.layer.borderWidth = 10
            featureOneCell?.clipsToBounds = true
            
            
            
            
           featureOneCell?.linkURL = self.featureOnePosts[indexPath.row].linkURL
           featureOneCell?.imageURL = self.featureOnePosts[indexPath.row].imageURL
            featureOneCell?.pvCount = self.featureOnePosts[indexPath.row].pvCount
            
            let post = featureOnePosts[indexPath.row]
            
            //
            featureOneCell?.featureImage.af_setImage(withURL: URL(string: featureOnePosts[indexPath.row].imageURL)!)
            
            
            
            if let img = FeatureViewController.imageCache.object(forKey: post.imageURL as! NSString) {
                
                
                
                featureOneCell?.configureCell(post: post, img: img)
                
            }
            else {
                
                featureOneCell?.configureCell(post: post)
                
            }
            
            
            
            
            
            
            
            
            
            
            
        }
        
        
        
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if selectedNum == 0 {
            
            return self.featureOnePosts.count
            
        } else if selectedNum == 1 {
            
           return self.featureTwoPosts.count
            
        } else if selectedNum == 2 {
         
            return self.featureThreePosts.count
            
        }
        
        
        
        return 0
        
        
        
        
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

 

}
