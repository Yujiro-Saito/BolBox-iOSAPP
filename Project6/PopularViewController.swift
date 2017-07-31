//
//  PopularViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/28.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase
import AlamofireImage

class PopularViewController: UIViewController, IndicatorInfoProvider,UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var popularTable: UITableView!
    
    
    var itemInfo: IndicatorInfo = "人気"
    var posts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var likingNameBox = [String]()
    let currentUserName = FIRAuth.auth()?.currentUser?.displayName

    override func viewDidLoad() {
        super.viewDidLoad()
        
        popularTable.delegate = self
        popularTable.dataSource = self
        
        self.popularTable.refreshControl = UIRefreshControl()
        self.popularTable.refreshControl?.addTarget(self, action: #selector(PopularViewController.refresh), for: .valueChanged)
        

    }
    
    
    func refresh() {
        
        DataService.dataBase.REF_BASE.child("posts").queryOrdered(byChild: "pvCount").observe(.value, with: { (snapshot) in
            
            self.posts = []
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let likes = postDict["pvCount"] as! Int
                        
                        
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        self.posts.append(post)
                        
                        self.popularTable.reloadData()
                        
                    }
                }
                
                
            }
            
            
            self.posts.reverse()
            self.popularTable.reloadData()
            
        })
        
        
        self.popularTable.refreshControl?.endRefreshing()
        
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DataService.dataBase.REF_BASE.child("posts").queryOrdered(byChild: "pvCount").observe(.value, with: { (snapshot) in
            
            self.posts = []
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let likes = postDict["pvCount"] as! Int
                        
                        
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        self.posts.append(post)
                        
                        self.popularTable.reloadData()
                        
                    }
                }
                
                
            }
            
            
            self.posts.reverse()
            self.popularTable.reloadData()
            
        })
        
    }

   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentUserName = FIRAuth.auth()?.currentUser?.displayName
        
        
        let popularCell = popularTable.dequeueReusableCell(withIdentifier: "popularCell", for: indexPath) as? PopularTableViewCell
        
        
        
        popularCell?.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
        popularCell?.layer.borderWidth = 10
        popularCell?.clipsToBounds = true
        
        
        popularCell?.userImageURL = self.posts[indexPath.row].userProfileImage
        popularCell?.userProfileName = self.posts[indexPath.row].userProfileName
        
        popularCell?.postID = self.posts[indexPath.row].postID
        popularCell?.category = self.posts[indexPath.row].category
        popularCell?.pvCount = self.posts[indexPath.row].pvCount
        popularCell?.imageURL = self.posts[indexPath.row].imageURL
        popularCell?.linkURL = self.posts[indexPath.row].linkURL
        popularCell?.userID = self.posts[indexPath.row].userID
        
        let post = posts[indexPath.row]

        popularCell?.popImage.af_setImage(withURL: URL(string: posts[indexPath.row].imageURL)!)
        
        
        
        if let img = PopularViewController.imageCache.object(forKey: post.imageURL as! NSString) {
            
            
            
            popularCell?.configureCell(post: post, img: img)
            
        }
        else {
            
            popularCell?.configureCell(post: post)
            
        }
        
        
        
        
        
        if self.posts[indexPath.row].peopleWhoLike != nil {
            popularCell?.peopleWhoLike = self.posts[indexPath.row].peopleWhoLike as Dictionary<String, AnyObject>
        }
        
        
        
        
        let likingDictionary = posts[indexPath.row].peopleWhoLike
        
        for (nameKey,namevalue) in likingDictionary {
            
            print("キーは\(nameKey)、値は\(namevalue)")
            
            
            if nameKey == currentUserName {
                
                popularCell?.likesButton.isHidden = true
                popularCell?.likesButton.isEnabled = false
                
                popularCell?.unLikeButton.isHidden = false
                popularCell?.unLikeButton.isEnabled = true
                
                
                
                
            }
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        return popularCell!
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        detailPosts = self.posts[indexPath.row]
        
        performSegue(withIdentifier: "ToDetailPop", sender: nil)
        
        
        
        
        
    }
    
    
    
    //必須
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return itemInfo
    }

    
    //詳細画面遷移時のデータ引き継ぎ
    
    var detailPosts: Post?
    var userPosts: User?
    
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
        detailVc.userDescription = userPosts?.userDesc
        
        
        
    }

}



