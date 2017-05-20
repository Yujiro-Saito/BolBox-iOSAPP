//
//  newPostsViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/20.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase

class newPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var newPostsTable: UITableView!
    var posts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newPostsTable.delegate = self
        newPostsTable.dataSource = self

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //新着投稿
        DataService.dataBase.REF_POST.queryLimited(toLast: 25).observe(.value, with: { (snapshot) in
            
            self.posts = []
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        
                        self.posts.append(post)
                    }
                }
                
                
            }
            self.posts.reverse()
            self.newPostsTable.reloadData()
            
        })
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = newPostsTable.dequeueReusableCell(withIdentifier: "newPostsTable", for: indexPath) as? newPostsListTableViewCell {
            
            let post = posts[indexPath.row]
            
            if let img = newPostsViewController.imageCache.object(forKey: post.imageURL as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            
            
            
        }
        
        
        
        return UITableViewCell()
    }
    

    

}
