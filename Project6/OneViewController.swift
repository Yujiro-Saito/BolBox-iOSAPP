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

class OneViewController: UIViewController, IndicatorInfoProvider,UITableViewDelegate, UITableViewDataSource {

    
    
    
    
    @IBOutlet weak var oneTable: UITableView!
    var itemInfo: IndicatorInfo = "メディア"
    var mediaPosts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oneTable.delegate = self
        oneTable.dataSource = self
        
        self.oneTable.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //メディアのデータ読み込み
        DataService.dataBase.REF_POST.observe(.value, with: { (snapshot) in
            
            self.mediaPosts = []
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let categoryTag = postDict["category"] as! String
                        
                        
                        if categoryTag == "メディア" {
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.mediaPosts.append(post)
                            self.oneTable.reloadData()
                        
                        }
                            
                    }
                }
                
                
            }
            
            
            
            self.oneTable.reloadData()
            
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
        return mediaPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
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
        
        //DBにアクセスしていいね押しているか確認
        DataService.dataBase.REF_BASE.child("posts/-\(self.mediaPosts[indexPath.row].postID)/peopleWhoLike").observe(.value, with: { (snapshot) in
            
            
            print(snapshot)
            
           if let postDict = snapshot.value as? Dictionary<String, AnyObject> {
            
            print(postDict)
            
           
            
            }
            
            
            
            
            
            
                        })
        
        
        if let img = OneViewController.imageCache.object(forKey: post.imageURL as NSString) {
            
            
            
            mediaCell?.configureCell(post: post, img: img)
            
        }
        else {
            
            mediaCell?.configureCell(post: post)
            
        }
        
        
        return mediaCell!
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        detailPosts = self.mediaPosts[indexPath.row]
        
        performSegue(withIdentifier: "ToDetailOne", sender: nil)
        
        
        
        
        
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
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    

}
