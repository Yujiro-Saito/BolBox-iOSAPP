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
    
    
    @IBOutlet weak var segmentedThree: UISegmentedControl!
    
    
    @IBOutlet weak var categoryTable: UITableView!
    var posts = [Post]()
    var popularPosts = [Post]()
    var recommenedPosts = [Post]()
    var selectedSegment = 0
    static var imageCache: NSCache<NSString, UIImage> = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTable.delegate = self
        categoryTable.dataSource = self
        
        
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //人気投稿
        
        
        DataService.dataBase.REF_POST.queryOrdered(byChild: "pvCount").observe(.value, with: { (snapshot) in
            
            self.popularPosts = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        
                        
                        
                        self.popularPosts.append(post)
                        
                        self.popularPosts.sort(by: {$0.pvCount > $1.pvCount})
                        
                    }
                }
                
                
            }
            
            
            self.categoryTable.reloadData()
            
        })
        
        
        
        //おすすめ
        DataService.dataBase.REF_POST.observe(.value, with: { (snapshot) in
            
            self.recommenedPosts = []
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        
                        self.recommenedPosts.append(post)
                    }
                }
                
                
            }
            self.recommenedPosts.reverse()
            self.recommenedPosts.shuffle()
            self.categoryTable.reloadData()
            
        })

        
        


        
    }
    
   

    @IBAction func segmentedTapped(_ sender: Any) {
        
        
        let segmentedNum = segmentedThree.selectedSegmentIndex
        
        switch segmentedNum {
        case 0:
            print("人気")
            
            selectedSegment = 0
            
            DataService.dataBase.REF_POST.queryOrdered(byChild: "pvCount").observe(.value, with: { (snapshot) in
                
                self.popularPosts = []
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            
                            
                            
                            self.popularPosts.append(post)
                            
                            self.popularPosts.sort(by: {$0.pvCount > $1.pvCount})
                            
                        }
                    }
                    
                    
                }
                
                
                self.categoryTable.reloadData()
                
            })
            
            
        case 1:
            print("新着")
            
            selectedSegment = 1
            
            //新着投稿
            DataService.dataBase.REF_POST.observe(.value, with: { (snapshot) in
                
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
                self.categoryTable.reloadData()
                
            })
            
        case 2:
            print("おすすめ")
            
            
            
            
            selectedSegment = 2
            
            //おすすめ
            DataService.dataBase.REF_POST.observe(.value, with: { (snapshot) in
                
                self.recommenedPosts = []
                
                print(snapshot.value)
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            
                            self.recommenedPosts.append(post)
                        }
                    }
                    
                    
                }
                self.recommenedPosts.reverse()
                self.recommenedPosts.shuffle()
                self.categoryTable.reloadData()
                
            })
 
            
        default:
            print("ENDS")
        }
        
        
        
        
        
    }
    
        
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if selectedSegment == 0 {
            return popularPosts.count
        } else if selectedSegment == 1 {
            return posts.count
        } else if selectedSegment == 2 {
            return recommenedPosts.count
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = categoryTable.dequeueReusableCell(withIdentifier: "CategoryItems", for: indexPath) as?  CategorysTableViewCell
        
        if selectedSegment == 0 {
            
            let post = popularPosts[indexPath.row]
            
            if let img = CategoryTableViewController.imageCache.object(forKey: post.imageURL as NSString) {
                
                cell?.configureCell(post: post, img: img)
                
            }
            else {
                
                cell?.configureCell(post: post)
                
            }
            
            self.popularPosts.sort(by: {$0.pvCount > $1.pvCount})
            
            return cell!
        
        } else if selectedSegment == 1 {
            
            
            let post = posts[indexPath.row]
            
            
            if let img = CategoryTableViewController.imageCache.object(forKey: post.imageURL as NSString) {
                cell?.configureCell(post: post, img: img)
            } else {
                cell?.configureCell(post: post)
            }
            
            return cell!
            
        } else if selectedSegment == 2 {
            
            let post = recommenedPosts[indexPath.row]
            
            if let img = CategoryTableViewController.imageCache.object(forKey: post.imageURL as NSString) {
                cell?.configureCell(post: post, img: img)
            } else {
                cell?.configureCell(post: post)
            }
            
            return cell!
            
        }

    
    
        
        
        
        
        return cell!
        

        
    }
    

   

}


extension Array
{
    mutating func shuffle()
    {
        for _ in 0..<10
        {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}



