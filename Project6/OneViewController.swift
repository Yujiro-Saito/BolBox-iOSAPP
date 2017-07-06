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
        
        //カテゴリーメディアのデータ読み込み
        DataService.dataBase.REF_POST.observe(.value, with: { (snapshot) in
            
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let categoryTag = postDict["category"] as! String
                        
                        print("おおおおおおおおおおおおおおおおお\(categoryTag)")
                        
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
        
        let post = mediaPosts[indexPath.row]
        
        if let img = OneViewController.imageCache.object(forKey: post.imageURL as NSString) {
            
            mediaCell?.configureCell(post: post, img: img)
            
        }
        else {
            
            mediaCell?.configureCell(post: post)
            
        }
        
        
        return mediaCell!
        
        
    }
    
    
    
    
    
    
    
    
    
    
    

}
