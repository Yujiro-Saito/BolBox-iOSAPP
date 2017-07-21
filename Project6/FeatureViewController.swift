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
            
            DataService.dataBase.REF_FEATURETWO.observe(.value, with: { (snapshot) in
                
                self.featureTwoPosts = []
                
                print(snapshot.value)
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.featureTwoPosts.append(post)
                            self.featureTable.reloadData()
                            
                            
                            
                        }
                    }
                    
                    
                }
                
                
                
                self.featureTable.reloadData()
                
            })

            
            
            
            
            
            
        } else if selectedNum == 2 {
            //三つ目の記事を読み込み
            
            DataService.dataBase.REF_FEATURETHREE.observe(.value, with: { (snapshot) in
                
                self.featureThreePosts = []
                
                print(snapshot.value)
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.featureThreePosts.append(post)
                            self.featureTable.reloadData()
                            
                            
                            
                        }
                    }
                    
                    
                }
                
                
                
                self.featureTable.reloadData()
                
            })
            
            
            
            
            
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
            
            
            
            
            return featureOneCell!
            
            
            
            
            
            
        }
        
        
        else if selectedNum == 1 {
            
            
            let currentUserName = FIRAuth.auth()?.currentUser?.displayName
            
            
            let featureTwoeCell = featureTable.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as? FeatureTableViewCell
            
            
            
            featureTwoeCell?.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
            featureTwoeCell?.layer.borderWidth = 10
            featureTwoeCell?.clipsToBounds = true
            
            
            
            
            featureTwoeCell?.linkURL = self.featureTwoPosts[indexPath.row].linkURL
            featureTwoeCell?.imageURL = self.featureTwoPosts[indexPath.row].imageURL
            featureTwoeCell?.pvCount = self.featureTwoPosts[indexPath.row].pvCount
            
            let post = featureTwoPosts[indexPath.row]
            
            //
            featureTwoeCell?.featureImage.af_setImage(withURL: URL(string: featureTwoPosts[indexPath.row].imageURL)!)
            
            
            
            if let img = FeatureViewController.imageCache.object(forKey: post.imageURL as! NSString) {
                
                
                
                featureTwoeCell?.configureCell(post: post, img: img)
                
            }
            else {
                
                featureTwoeCell?.configureCell(post: post)
                
            }
            
            
            
            
            return featureTwoeCell!
            

            
            
            
         
            
            
            
            
            
        }
        
        
        else if self.selectedNum == 2 {
            
            
            let currentUserName = FIRAuth.auth()?.currentUser?.displayName
            
            
            let featureThreeCell = featureTable.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as? FeatureTableViewCell
            
            
            
            featureThreeCell?.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
            featureThreeCell?.layer.borderWidth = 10
            featureThreeCell?.clipsToBounds = true
            
            
            
            
            featureThreeCell?.linkURL = self.featureThreePosts[indexPath.row].linkURL
            featureThreeCell?.imageURL = self.featureThreePosts[indexPath.row].imageURL
            featureThreeCell?.pvCount = self.featureThreePosts[indexPath.row].pvCount
            
            let post = featureThreePosts[indexPath.row]
            
            //
            featureThreeCell?.featureImage.af_setImage(withURL: URL(string: featureThreePosts[indexPath.row].imageURL)!)
            
            
            
            if let img = FeatureViewController.imageCache.object(forKey: post.imageURL as! NSString) {
                
                
                
                featureThreeCell?.configureCell(post: post, img: img)
                
            }
            else {
                
                featureThreeCell?.configureCell(post: post)
                
            }
            
            
            
            
            return featureThreeCell!

            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
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
    
    
    @IBAction func backButton(_ sender: Any) {
        
        
        self.dismiss(animated: true, completion: nil)
        
        
        
        
    }

 

}
