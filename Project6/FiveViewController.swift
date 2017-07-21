//
//  FiveViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/05.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase

class FiveViewController: UIViewController, IndicatorInfoProvider,UITableViewDelegate,UITableViewDataSource {
    
    
    
    
    @IBOutlet weak var fiveTable: UITableView!
    
    var itemInfo: IndicatorInfo = "ショッピング"
    var shoppinglPosts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fiveTable.delegate = self
        fiveTable.dataSource = self
        
        self.fiveTable.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //ショッピングのデータ読み込み
        DataService.dataBase.REF_POST.observe(.value, with: { (snapshot) in
            
            self.shoppinglPosts = []
            
            
            print(snapshot.value)
            
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let categoryTag = postDict["category"] as! String
                        
                        
                        if categoryTag == "ショッピング" {
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.shoppinglPosts.append(post)
                            
                        }
                        
                    }
                }
                
                
            }
            
            
            self.shoppinglPosts.reverse()
            self.fiveTable.reloadData()
            
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
        return shoppinglPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentUserName = FIRAuth.auth()?.currentUser?.displayName
        
        let shoppingCell = fiveTable.dequeueReusableCell(withIdentifier: "shoppingPosts", for: indexPath) as? FiveTableViewCell
        
        shoppingCell?.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
        shoppingCell?.layer.borderWidth = 10
        shoppingCell?.clipsToBounds = true
        
        shoppingCell?.userImageURL = self.shoppinglPosts[indexPath.row].userProfileImage
        shoppingCell?.userProfileName = self.shoppinglPosts[indexPath.row].userProfileName
        
        
        shoppingCell?.userID = self.shoppinglPosts[indexPath.row].userID
        shoppingCell?.postID = self.shoppinglPosts[indexPath.row].postID
        shoppingCell?.category = self.shoppinglPosts[indexPath.row].category
        shoppingCell?.pvCount = self.shoppinglPosts[indexPath.row].pvCount
        shoppingCell?.imageURL = self.shoppinglPosts[indexPath.row].imageURL
        shoppingCell?.linkURL = self.shoppinglPosts[indexPath.row].linkURL
        
        let post = shoppinglPosts[indexPath.row]
        
        shoppingCell?.cellImage.af_setImage(withURL: URL(string: shoppinglPosts[indexPath.row].imageURL)!)
        
        if let img = FiveViewController.imageCache.object(forKey: post.imageURL as! NSString) {
            
            shoppingCell?.configureCell(post: post, img: img)
            
        }
        else {
            
            shoppingCell?.configureCell(post: post)
            
        }
        
        if self.shoppinglPosts[indexPath.row].peopleWhoLike != nil {
            shoppingCell?.peopleWhoLike = self.shoppinglPosts[indexPath.row].peopleWhoLike as Dictionary<String, AnyObject>
        }
        
        let likingDictionary = shoppinglPosts[indexPath.row].peopleWhoLike
        
        for (nameKey,namevalue) in likingDictionary {
            
            print("キーは\(nameKey)、値は\(namevalue)")
            
            
            if nameKey == currentUserName {
                
                
                shoppingCell?.emptyLike.isHidden = true
                shoppingCell?.emptyLike.isEnabled = false
                
                shoppingCell?.likeButton.isHidden = false
                shoppingCell?.likeButton.isEnabled = true
                
            }
            
            
        }
        
        
        
        
        
        return shoppingCell!
        
        
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
        
        detailPosts = self.shoppinglPosts[indexPath.row]
        
        performSegue(withIdentifier: "ToDetailFive", sender: nil)
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
