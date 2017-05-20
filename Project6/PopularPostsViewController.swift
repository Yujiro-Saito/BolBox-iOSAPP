//
//  PopularPostsViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/20.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase

class PopularPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var popularPostsTable: UITableView!
    var posts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        popularPostsTable.delegate = self
        popularPostsTable.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        DataService.dataBase.REF_POST.queryOrdered(byChild: "pvCount").queryLimited(toLast: 15).observe(.value, with: { (snapshot) in
            
            self.posts = []
            
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        
                        
                        self.posts.sort(by: {$0.pvCount > $1.pvCount})
                        
                        self.posts.append(post)
                        
                    }
                }
                
                
            }
            
            
            self.popularPostsTable.reloadData()
            
        })
        
        
        
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = popularPostsTable.dequeueReusableCell(withIdentifier: "popuPosts", for: indexPath) as? PopularPostsListTableViewCell {
            
            let post = posts[indexPath.row]
            
            if let img = PopularPostsViewController.imageCache.object(forKey: post.imageURL as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            
            self.posts.sort(by: {$0.pvCount > $1.pvCount})
            
            return cell

            
        }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}
