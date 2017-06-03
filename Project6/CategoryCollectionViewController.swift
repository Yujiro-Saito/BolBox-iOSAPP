//
//  CategoryCollectionViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/03.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase

class CategoryCollectionViewController: UICollectionViewController {
    
    
    
    var selectedSegmentNum = 0
    
    
    @IBOutlet var categoryCollection: UICollectionView!
    
    
    struct Storyboard {
        
        
        static let leftAndRightPaddings: CGFloat = 32.0 // 3 items per row, meaning 4 paddings of 8 each
        static let numberOfItemsPerRow: CGFloat = 2.0
        static let titleHeightAdjustment: CGFloat = 30.0
    }
    
    //Property
    var posts = [Post]()
    var popularPosts = [Post]()
    var recommendedPosts = [Post]()
    
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionViewWidth = collectionView?.frame.width
        let itemWidth = (collectionViewWidth! - Storyboard.leftAndRightPaddings) / Storyboard.numberOfItemsPerRow
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + Storyboard.titleHeightAdjustment)
        
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        

        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        if selectedSegmentNum == 0 {
            
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
                
                
                self.collectionView?.reloadData()
                
            })
            
            self.collectionView?.reloadData()
            
 
            
            
        }
        
        /*
        else if selectedSegmentNum == 1 {
        
            print("1")
            
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
                self.collectionView?.reloadData()
                
            })
            
            self.collectionView?.reloadData()
        
        
        } else if selectedSegmentNum == 2 {
            
            
            print("2")
            
            
            
            
            
            
        }
        */
        
    }

    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if selectedSegmentNum == 0 {
            return popularPosts.count
            
        } else if selectedSegmentNum == 1 {
            return posts.count
            
        } else if selectedSegmentNum == 2 {
            return recommendedPosts.count
            
        }
        
        return 2
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Categories", for: indexPath) as? CategoryCollectionViewCell
        
        
        
        if selectedSegmentNum == 0 {
            
            //print("選ばれた番号\(selectedSegmentNum)")
            /*
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
                
                
                self.collectionView?.reloadData()
                
            })
            
            */
            
            let post = popularPosts[indexPath.row]
            
            if let img = CategoryCollectionViewController.imageCache.object(forKey: post.imageURL as NSString) {
                
                cell?.configureCell(post: post, img: img)
                
                cell?.configureCell(post: post, img: img)
                
            } else {
                
                cell?.configureCell(post: post)
                
            }
            
        }  else if selectedSegmentNum == 1 {
            
            print("選ばれた番号\(selectedSegmentNum)")
            
            
            /*
            
            let post = posts[indexPath.row]
            
            if let img = CategoryCollectionViewController.imageCache.object(forKey: post.imageURL as NSString) {
                
                cell?.configureCell(post: post, img: img)
                
                cell?.configureCell(post: post, img: img)
                
            } else {
                
                cell?.configureCell(post: post)
                
            }
*/
        }
        
        else if selectedSegmentNum == 2 {
            
            
            let post = recommendedPosts[indexPath.row]
            
            if let img = CategoryCollectionViewController.imageCache.object(forKey: post.imageURL as NSString) {
                
                cell?.configureCell(post: post, img: img)
                
                cell?.configureCell(post: post, img: img)
                
            } else {
                
                cell?.configureCell(post: post)
                
            }
            
            
            
        }
        
        
        
        
        
        return cell!
        
        
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CategoryHeader", for: indexPath) as! CategoryHeaderCollectionReusableView
        
        return headerView
    }

    
    
    
    
    
    
    

   }
