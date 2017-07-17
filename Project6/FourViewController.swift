//
//  FourViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/05.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase



class FourViewController: UIViewController, IndicatorInfoProvider,UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    @IBOutlet weak var fourTable: UITableView!
    var travelPosts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    //ここがボタンのタイトルに利用されます
    var itemInfo: IndicatorInfo = "トラベル"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fourTable.delegate = self
        fourTable.dataSource = self
        
        self.fourTable.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        //トラベルのデータ読み込み
        DataService.dataBase.REF_POST.observe(.value, with: { (snapshot) in
            
            self.travelPosts = []
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let categoryTag = postDict["category"] as! String
                        
                        
                        if categoryTag == "トラベル" {
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.travelPosts.append(post)
                            self.fourTable.reloadData()
                            
                        }
                        
                    }
                }
                
                
            }
            
            
            
            self.fourTable.reloadData()
            
        })
        

        
        
        
        
        
        
        
        
        
        
    }
    
    //必須
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travelPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentUserName = FIRAuth.auth()?.currentUser?.displayName
        
        let travelCell = fourTable.dequeueReusableCell(withIdentifier: "travelPosts", for: indexPath) as? FourTableViewCell
        
        travelCell?.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
        travelCell?.layer.borderWidth = 10
        travelCell?.clipsToBounds = true
        
        
        travelCell?.userImageURL = self.travelPosts[indexPath.row].userProfileImage
        travelCell?.userProfileName = self.travelPosts[indexPath.row].userProfileName
        
        travelCell?.userID = self.travelPosts[indexPath.row].userID
        travelCell?.postID = self.travelPosts[indexPath.row].postID
        travelCell?.category = self.travelPosts[indexPath.row].category
        travelCell?.pvCount = self.travelPosts[indexPath.row].pvCount
        travelCell?.imageURL = self.travelPosts[indexPath.row].imageURL
        travelCell?.linkURL = self.travelPosts[indexPath.row].linkURL
        
        
        if self.travelPosts[indexPath.row].peopleWhoLike != nil {
            travelCell?.peopleWhoLike = self.travelPosts[indexPath.row].peopleWhoLike as Dictionary<String, AnyObject>
        }

        let likingDictionary = travelPosts[indexPath.row].peopleWhoLike
        
        for (nameKey,namevalue) in likingDictionary {
            
            print("キーは\(nameKey)、値は\(namevalue)")
            
            
            if nameKey == currentUserName {
                
                
                travelCell?.emptyLike.isHidden = true
                travelCell?.emptyLike.isEnabled = false
                
                travelCell?.likeButton.isHidden = false
                travelCell?.likeButton.isEnabled = true
                
            }
            
            
        }
        
        
        let post = travelPosts[indexPath.row]
        
        if let img = FourViewController.imageCache.object(forKey: post.imageURL as NSString) {
            
            travelCell?.configureCell(post: post, img: img)
            
        }
        else {
            
            travelCell?.configureCell(post: post)
            
        }
        
        
        return travelCell!
        
        
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
        
        detailPosts = self.travelPosts[indexPath.row]
        
        performSegue(withIdentifier: "ToDetailFour", sender: nil)
        
        
        
        
        
    }
    
    
    
    
    
    
}
