//
//  ThreeViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/05.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase

class ThreeViewController: UIViewController, IndicatorInfoProvider,UITableViewDelegate,UITableViewDataSource{
    
    
    
    @IBOutlet weak var threeTable: UITableView!
    
    var itemInfo: IndicatorInfo = "教育・キャリア"
    var educationPosts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        threeTable.delegate = self
        threeTable.dataSource = self
        
        self.threeTable.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //教育・キャリアの読み込み
        DataService.dataBase.REF_POST.observe(.value, with: { (snapshot) in
            
            self.educationPosts = []
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let categoryTag = postDict["category"] as! String
                        
                        
                        if categoryTag == "教育・キャリア" {
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.educationPosts.append(post)
                            self.threeTable.reloadData()
                            
                        }
                        
                    }
                }
                
                
            }
            
            
            
            self.threeTable.reloadData()
            
        })
        
        
        
        
        
        
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return educationPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let educationCell = threeTable.dequeueReusableCell(withIdentifier: "educationPosts", for: indexPath) as? ThreeTableViewCell
        
        educationCell?.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
        educationCell?.layer.borderWidth = 10
        educationCell?.clipsToBounds = true
        
        let post = educationPosts[indexPath.row]
        
        if let img = ThreeViewController.imageCache.object(forKey: post.imageURL as NSString) {
            
            educationCell?.configureCell(post: post, img: img)
            
        }
        else {
            
            educationCell?.configureCell(post: post)
            
        }
        
        
        return educationCell!
        
        
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
        
        detailPosts = self.educationPosts[indexPath.row]
        
        performSegue(withIdentifier: "ToDetailThree", sender: nil)
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
