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

class TwoViewController: UIViewController, IndicatorInfoProvider,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var twoTable: UITableView!
    var itemInfo: IndicatorInfo = "アプリ"
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var appPosts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        twoTable.delegate = self
        twoTable.dataSource = self
        
        self.twoTable.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
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
                        
                        print("おおおおおおおおおおおおおおおおお\(categoryTag)")
                        
                        if categoryTag == "アプリ" {
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.appPosts.append(post)
                            self.twoTable.reloadData()
                            
                        }
                        
                    }
                }
                
                
            }
            
            
            
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
        
        
        let postCell = twoTable.dequeueReusableCell(withIdentifier: "appPost", for: indexPath) as? TwoTableViewCell
        
        postCell?.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
        postCell?.layer.borderWidth = 10
        postCell?.clipsToBounds = true
        
        let post = appPosts[indexPath.row]
        
        if let img = TwoViewController.imageCache.object(forKey: post.imageURL as NSString) {
            
            postCell?.configureCell(post: post, img: img)
            
        }
        else {
            
            postCell?.configureCell(post: post)
            
        }
        
        
        return postCell!
        
        
    }
    
    //詳細画面遷移時のデータ引き継ぎ
    
    var detailPosts: Post?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let detailVc = (segue.destination as? InDetailViewController)!
        
        detailVc.name = detailPosts?.name
        detailVc.numLikes = detailPosts?.pvCount
        detailVc.whatContent = detailPosts?.whatContent
        detailVc.imageURL = detailPosts?.imageURL
        detailVc.linkURL = detailPosts?.linkURL
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        detailPosts = self.appPosts[indexPath.row]
        
        performSegue(withIdentifier: "ToDetailTwo", sender: nil)
        
        
        
        
        
    }

        
        
        
        
    }
    
    
    

