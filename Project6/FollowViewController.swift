//
//  FollowViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/08/30.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import AlamofireImage



class FollowViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var followCollection: UICollectionView!
    var followingPosts = [Post]()
    var detailPosts: Post?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        followCollection.delegate = self
        followCollection.dataSource = self

    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        DataService.dataBase.REF_POST.observe(.value, with: { (snapshot) in
            
            self.followingPosts = []
            
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        
                        
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        self.followingPosts.append(post)
                        
                        
                        
                    }
                }
                
                
            }
            
            
            self.followingPosts.reverse()
            self.followCollection.reloadData()
            
        })
        
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followingPosts.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = followCollection.dequeueReusableCell(withReuseIdentifier: "following", for: indexPath) as? FollowCollectionViewCell
        
        
        //読み込むまで画像は非表示
        cell?.itemImge.image = nil
        cell?.clipsToBounds = true
        cell?.itemImge.layer.cornerRadius = 5.0
        cell?.itemName.layer.cornerRadius = 5.0
        
        
        //現在のCell
        let post = followingPosts[indexPath.row]
        
        cell?.itemName.text = followingPosts[indexPath.row].name
        
        //画像の読み込み
        if self.followingPosts[indexPath.row].imageURL != nil {
            cell?.itemImge.af_setImage(withURL:  URL(string: followingPosts[indexPath.row].imageURL)!)
        }
        
        
        return cell!
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let cellSize:CGFloat = self.view.frame.size.width/2-2
        // 正方形で返すためにwidth,heightを同じにする
        return CGSize(width: cellSize, height: cellSize + 55.0)
        
        
       
    }
    
    
    
    //縦の間隔を決定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    //横の間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    

    


}
