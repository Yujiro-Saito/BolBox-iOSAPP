//
//  FeedViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/08/30.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import AlamofireImage



class FeedViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var feedCollection: UICollectionView!
    
    var newPosts = [Post]()
    var detailPosts: Post?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        feedCollection.delegate = self
        feedCollection.dataSource = self
        
        self.navigationItem.title = "Port"
        
        // フォント種をTime New Roman、サイズを10に指定
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSFontAttributeName: UIFont(name: "Times New Roman", size: 18)!]
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.blue
        self.navigationController?.hidesBarsOnSwipe = true
        
        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        
        DataService.dataBase.REF_POST.observe(.value, with: { (snapshot) in
            
            self.newPosts = []
            
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        
                        
                        
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.newPosts.append(post)
                            
                            
                        
                    }
                }
                
                
            }
            
            
            self.newPosts.reverse()
            self.feedCollection.reloadData()
            
        })
        
        
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newPosts.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = feedCollection.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as? FeedCollectionViewCell
        
        
        //読み込むまで画像は非表示
        cell?.itemImage.image = nil
        cell?.clipsToBounds = true
        cell?.itemImage.layer.cornerRadius = 5.0
        cell?.itemLabel.layer.cornerRadius = 5.0
        cell?.blurView.layer.cornerRadius = 5.0
        
        
        //現在のCell
        let post = newPosts[indexPath.row]
        
        cell?.itemLabel.text = newPosts[indexPath.row].name
        
        //画像の読み込み
        if self.newPosts[indexPath.row].imageURL != nil {
            cell?.itemImage.af_setImage(withURL:  URL(string: newPosts[indexPath.row].imageURL)!)
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
    
    
    
    //Item Tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        detailPosts = self.newPosts[indexPath.row]
        
        
        performSegue(withIdentifier: "detailInfo", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = (segue.destination as? InfomationViewController)!
        
        
        detailVC.name = detailPosts?.name
        detailVC.numLikes = (detailPosts?.pvCount)!
        detailVC.imageURL = detailPosts?.imageURL
        detailVC.linkURL = detailPosts?.linkURL
        detailVC.userName = detailPosts?.userProfileName
        detailVC.userID = detailPosts?.userID
        detailVC.userImageURL = detailPosts?.userProfileImage
        
    }
    

   

}
