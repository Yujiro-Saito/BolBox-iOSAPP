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
                            self.fiveTable.reloadData()
                            
                        }
                        
                    }
                }
                
                
            }
            
            
            
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
        
        
        
        let shoppingCell = fiveTable.dequeueReusableCell(withIdentifier: "shoppingPosts", for: indexPath) as? FiveTableViewCell
        
        shoppingCell?.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
        shoppingCell?.layer.borderWidth = 10
        shoppingCell?.clipsToBounds = true
        
        let post = shoppinglPosts[indexPath.row]
        
        if let img = FiveViewController.imageCache.object(forKey: post.imageURL as NSString) {
            
            shoppingCell?.configureCell(post: post, img: img)
            
        }
        else {
            
            shoppingCell?.configureCell(post: post)
            
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
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        detailPosts = self.shoppinglPosts[indexPath.row]
        
        performSegue(withIdentifier: "ToDetailFive", sender: nil)
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
