//
//  OneViewController.swift
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

class OneViewController: UIViewController, IndicatorInfoProvider,UITableViewDelegate, UITableViewDataSource {

    
    
    
    
    @IBOutlet weak var oneTable: UITableView!
    var itemInfo: IndicatorInfo = "アプリ"
    var mediaPosts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var likingNameBox = [String]()
    let currentUserName = FIRAuth.auth()?.currentUser?.displayName
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oneTable.delegate = self
        oneTable.dataSource = self
        
        self.oneTable.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.oneTable.refreshControl = UIRefreshControl()
        self.oneTable.refreshControl?.addTarget(self, action: #selector(OneViewController.refresh), for: .valueChanged)
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
        DataService.dataBase.REF_POST.observe(.value, with: { (snapshot) in
            
            self.mediaPosts = []
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let categoryTag = postDict["category"] as! String
                        
                        
                        if categoryTag == "アプリ" {
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.mediaPosts.append(post)
                            
                        
                        }
                            
                    }
                }
                
                
            }
            
            
            self.mediaPosts.reverse()
            self.oneTable.reloadData()
            
        })
        
        
 
       
        
    }
    
    func refresh() {
        
        
        //メディアのデータ読み込み
        DataService.dataBase.REF_POST.observe(.value, with: { (snapshot) in
            
            self.mediaPosts = []
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let categoryTag = postDict["category"] as! String
                        
                        
                        if categoryTag == "アプリ" {
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.mediaPosts.append(post)
                            
                            
                        }
                        
                    }
                }
                
                
            }
            
            
            self.mediaPosts.reverse()
            self.oneTable.reloadData()
            
        })
        
        self.oneTable.refreshControl?.endRefreshing()
        
        
        
    }
    
    //必須
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return itemInfo
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let currentUserName = FIRAuth.auth()?.currentUser?.displayName
        
        
        let mediaCell = oneTable.dequeueReusableCell(withIdentifier: "mediaPost", for: indexPath) as? OneTableViewCell
        
        
        
        mediaCell?.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
        mediaCell?.layer.borderWidth = 10
        mediaCell?.clipsToBounds = true
        
        mediaCell?.userImageURL = self.mediaPosts[indexPath.row].userProfileImage
        mediaCell?.userProfileName = self.mediaPosts[indexPath.row].userProfileName
        
        mediaCell?.postID = self.mediaPosts[indexPath.row].postID
        mediaCell?.category = self.mediaPosts[indexPath.row].category
        mediaCell?.pvCount = self.mediaPosts[indexPath.row].pvCount
        mediaCell?.imageURL = self.mediaPosts[indexPath.row].imageURL
        mediaCell?.linkURL = self.mediaPosts[indexPath.row].linkURL
        mediaCell?.userID = self.mediaPosts[indexPath.row].userID
        
        let post = mediaPosts[indexPath.row]
        
        //
        mediaCell?.oneImage.af_setImage(withURL: URL(string: mediaPosts[indexPath.row].imageURL)!)
        
        
        
        if let img = OneViewController.imageCache.object(forKey: post.imageURL as! NSString) {
            
            
            
            mediaCell?.configureCell(post: post, img: img)
            
        }
        else {
            
            mediaCell?.configureCell(post: post)
            
        }
        
        
        
        
        
        if self.mediaPosts[indexPath.row].peopleWhoLike != nil {
            mediaCell?.peopleWhoLike = self.mediaPosts[indexPath.row].peopleWhoLike as Dictionary<String, AnyObject>
        }
        
        
        

         print(mediaPosts[indexPath.row].peopleWhoLike)
        
        let likingDictionary = mediaPosts[indexPath.row].peopleWhoLike
        
        for (nameKey,namevalue) in likingDictionary {
            
            print("キーは\(nameKey)、値は\(namevalue)")
            
            
            if nameKey == currentUserName {
                
                
                mediaCell?.likesButton.isHidden = true
                mediaCell?.likesButton.isEnabled = false
                
                mediaCell?.unLikeButton.isHidden = false
                mediaCell?.unLikeButton.isEnabled = true
                
                

                
            }
        
        
        }
        
        
        
        
        return mediaCell!
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        detailPosts = self.mediaPosts[indexPath.row]
        
        performSegue(withIdentifier: "ToDetailOne", sender: nil)
        
        
        
        
        
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
