//
//  PopularMoreReadCollectionViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/31.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase


class PopularMoreReadCollectionViewController: UICollectionViewController {

    struct Storyboard {
        
        
        static let leftAndRightPaddings: CGFloat = 32.0 // 3 items per row, meaning 4 paddings of 8 each
        static let numberOfItemsPerRow: CGFloat = 2.0
        static let titleHeightAdjustment: CGFloat = 30.0
    }
    
    
    
    @IBOutlet var popularMoreCollection: UICollectionView!
    
    //Property
    var posts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionViewWidth = collectionView?.frame.width
        let itemWidth = (collectionViewWidth! - Storyboard.leftAndRightPaddings) / Storyboard.numberOfItemsPerRow
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + Storyboard.titleHeightAdjustment)

       
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
                        
                        
                        
                        self.posts.append(post)
                        self.posts.sort(by: {$0.pvCount > $1.pvCount})
                        
                    }
                }
                
                
            }
            
            
            self.collectionView?.reloadData()
            
        })
        
        
        
        
    }
    
    

   
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMoreAndMore", for: indexPath) as? PopularMoreReadCollectionViewCell
        
        let post = posts[indexPath.row]
        
        if let img = PopularMoreReadCollectionViewController.imageCache.object(forKey: post.imageURL as NSString) {
            cell?.configureCell(post: post, img: img)
            
        } else {
           cell?.configureCell(post: post)
        }
    
    
    
        return cell!
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader1", for: indexPath) as! SectionHeaderPopCollectionReusableView
        
        headerView.sectionTitle.text = "人気"
        
        return headerView
    }
    
    
    
    
    


}
