//
//  TwoViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/05.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase
import AlamofireImage
import SCLAlertView

class TwoViewController: UIViewController, IndicatorInfoProvider,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var twoTable: UITableView!
    var itemInfo: IndicatorInfo = "メディア"
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var appPosts = [Post]()
    
    @IBOutlet weak var likingButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        twoTable.delegate = self
        twoTable.dataSource = self
        
        self.twoTable.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        
        self.twoTable.refreshControl = UIRefreshControl()
        self.twoTable.refreshControl?.addTarget(self, action: #selector(TwoViewController.refresh), for: .valueChanged)
    }
    
    
    
    
    func refresh() {
        
        
        //アプリデータの読み込み
        DataService.dataBase.REF_POST.observe(.value, with: { (snapshot) in
            
            self.appPosts = []
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let categoryTag = postDict["category"] as! String
                        
                        
                        if categoryTag == "メディア" {
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.appPosts.append(post)
                            
                            
                        }
                        
                    }
                }
                
                
            }
            
            self.appPosts.reverse()
            
            self.twoTable.reloadData()
            
        })
        
        
        self.twoTable.refreshControl?.endRefreshing()
        
        
        
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //アプリデータの読み込み
        DataService.dataBase.REF_POST.observe(.value, with: { (snapshot) in
            
            self.appPosts = []
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let categoryTag = postDict["category"] as! String
                        
                        
                        if categoryTag == "メディア" {
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.appPosts.append(post)
                
                            
                        }
                        
                    }
                }
                
                
            }
            
             self.appPosts.reverse()
            
            self.twoTable.reloadData()
            
        })
        
        
        
    }
    
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    
    
    //TableView関連
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appPosts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let currentUserName = FIRAuth.auth()?.currentUser?.displayName
        
        
        let postCell = twoTable.dequeueReusableCell(withIdentifier: "appPost", for: indexPath) as? TwoTableViewCell
        
        postCell?.cellImage.image = nil
        postCell?.cellUserImage.image = nil
        
        postCell?.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
        postCell?.layer.borderWidth = 10
        postCell?.clipsToBounds = true
        
        
        postCell?.userImageURL = self.appPosts[indexPath.row].userProfileImage
        postCell?.userProfileName = self.appPosts[indexPath.row].userProfileName
        
        postCell?.postID = self.appPosts[indexPath.row].postID
        postCell?.category = self.appPosts[indexPath.row].category
        postCell?.pvCount = self.appPosts[indexPath.row].pvCount
        postCell?.imageURL = self.appPosts[indexPath.row].imageURL
        postCell?.linkURL = self.appPosts[indexPath.row].linkURL
        postCell?.userID = self.appPosts[indexPath.row].userID
        
        if self.appPosts[indexPath.row].imageURL != nil {
            postCell?.cellImage.af_setImage(withURL: URL(string: appPosts[indexPath.row].imageURL)!)
        }
        
        
        
        let post = appPosts[indexPath.row]
        
        if let img = TwoViewController.imageCache.object(forKey: post.imageURL as! NSString) {
            
            postCell?.configureCell(post: post, img: img)
            
        }
        else {
            
            postCell?.configureCell(post: post)
            
        }
        
        if self.appPosts[indexPath.row].peopleWhoLike != nil {
            postCell?.peopleWhoLike = self.appPosts[indexPath.row].peopleWhoLike as Dictionary<String, AnyObject>
        }

        
        
        let likingDictionary = appPosts[indexPath.row].peopleWhoLike
        
        for (nameKey,namevalue) in likingDictionary {
            
            print("キーは\(nameKey)、値は\(namevalue)")
            
            
            if nameKey == currentUserName {
                
                
                postCell?.dislikeButton.isHidden = true
                postCell?.dislikeButton.isEnabled = false
                
                postCell?.likeButton.isHidden = false
                postCell?.likeButton.isEnabled = true
                
            }
            
            
        }

        
        
        
        
       
        
        
        return postCell!
        
        
    }
    
    //詳細画面遷移時のデータ引き継ぎ
    
    var detailPosts: Post?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let detailVc = (segue.destination as? InDetailViewController)!
        
        detailVc.name = detailPosts?.name
        detailVc.numLikes = (detailPosts?.pvCount)!
        detailVc.whatContent = detailPosts?.whatContent
        detailVc.imageURL = detailPosts?.imageURL
        detailVc.linkURL = detailPosts?.linkURL
        detailVc.userName = detailPosts?.userProfileName
        detailVc.userImageURL = detailPosts?.userProfileImage
        detailVc.userID = detailPosts?.userID
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        detailPosts = self.appPosts[indexPath.row]
        
        performSegue(withIdentifier: "ToDetailTwo", sender: nil)
        
        
        
        
        
    }
    
    
    
    
    
    
    

        
        
        
        
    }
    
    
    

