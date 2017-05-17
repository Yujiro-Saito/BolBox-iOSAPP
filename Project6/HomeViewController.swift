//
//  HomeViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/13.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //Properties
    @IBOutlet weak var menuItem: UIBarButtonItem!
    @IBOutlet weak var newCollection: UICollectionView!
    @IBOutlet weak var popularCollection: UICollectionView!
    @IBOutlet weak var categoryCollection: UICollectionView!
    var posts = [Post]()
    var popularPosts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    var images = ["sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample"]
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        newCollection.dataSource = self
        newCollection.delegate = self
        popularCollection.dataSource = self
        popularCollection.delegate = self
        categoryCollection.dataSource = self
        categoryCollection.delegate = self
        
        sideMenu()
        
        FIRAuth.auth()!.signInAnonymously { (firUser, error) in
            if error == nil {
                print("LoginOKKKK")
            } else {
                print(error?.localizedDescription)
            }
        }
        
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
            self.newCollection.reloadData()
            
        })
        
        //人気投稿
        DataService.dataBase.REF_POST.observe(.value, with: { (snapshot) in
            
            self.popularPosts = []
            
            print(snapshot.value)
            
            var pvArray = [Int]()
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        //let allPvCount: Int = postDict["pvCount"] as! Int
                        //print("それぞれ:\(allPvCount)")
                        
                        
                        //pvArray.append(allPvCount)
                            
                       // print(pvArray)
                        
                        //pvArray.sort{$1 < $0}

                       // print("成田: \(pvArray)")
                        
                        
                    
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        
                        self.popularPosts.sort(by: {$0.pvCount > $1.pvCount})
                        
                       
                        
            
                        self.popularPosts.append(post)
                    }
                }
                
                
            }
            
            
            self.popularCollection.reloadData()
            
        })

        
        
        
        
        

    }
    
    
   //Functions
    
    func sideMenu() {
        
        if revealViewController() != nil {
            
            menuItem.target = revealViewController()
            menuItem.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == newCollection {
            
            if let newCell = newCollection.dequeueReusableCell(withReuseIdentifier: "newCell", for: indexPath) as? newCollectionViewCell  {
                
                let post = posts[indexPath.row]

                
                if let img = HomeViewController.imageCache.object(forKey: post.imageURL as NSString) {
                    newCell.configureCell(post: post, img: img)
                } else {
                    newCell.configureCell(post: post)
                }
                
                return newCell
                
            }

        } else if collectionView == popularCollection {
            
            if let popularCell = popularCollection.dequeueReusableCell(withReuseIdentifier: "PopularCell", for: indexPath) as? popularCollectionViewCell {
                
                let post = posts[indexPath.row]
                
                if let img = HomeViewController.imageCache.object(forKey: post.imageURL as NSString) {
                    
                    popularCell.configureCell(post: post, img: img)
                    
                } else {
                    
                    popularCell.configureCell(post: post)
                    
                }
                
                return popularCell
            }
            
        }
        
      ///////
         else if let categoryCell = categoryCollection.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell {
            
            categoryCell.cellImage.image = UIImage(named: images[indexPath.row])
            categoryCell.cellTitle.text = "SmartMenu"
            
            
            return categoryCell
            
        }
        
       
        
        return newCollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == newCollection {
            
            
            return posts.count
            
        }
        
        else if collectionView == popularCollection {
            
            
            return popularPosts.count
            
        }
        
        /*else if collectionView == popularCollection {
            return images.count
        } else if collectionView == categoryCollection {
            return images.count
        }
        */
        
        return images.count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    

}
