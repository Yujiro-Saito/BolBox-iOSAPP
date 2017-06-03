//
//  CategoryTableViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/03.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase

class CategoryTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var categoryTable: UITableView!
    var posts = [Post]()
    var popularPosts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTable.delegate = self
        categoryTable.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        DataService.dataBase.REF_POST.queryLimited(toLast: 10).observe(.value, with: { (snapshot) in
            
            self.popularPosts = []
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        
                        self.popularPosts.append(post)
                    }
                }
                
                
            }
            self.popularPosts.reverse()
            self.categoryTable.reloadData()
            
        })

        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularPosts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = categoryTable.dequeueReusableCell(withIdentifier: "CategoryItems", for: indexPath) as?  CategorysTableViewCell
        
      
        let post = popularPosts[indexPath.row]
        
        if let img = CategoryTableViewController.imageCache.object(forKey: post.imageURL as NSString) {
            
            cell?.configureCell(post: post, img: img)
            
        }
        else {
            
            cell?.configureCell(post: post)
            
        }
        
        self.popularPosts.sort(by: {$0.pvCount > $1.pvCount})
        
        return cell!
        

        
    }
    

   

}
