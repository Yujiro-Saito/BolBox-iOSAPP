//
//  UserViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/08/30.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import AlamofireImage


class UserViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    
    @IBOutlet weak var userCollection: UICollectionView!
    @IBOutlet weak var followButton: UIButton!
    
    var userPosts = [Post]()
    var detailPosts: Post?
    
    
    //データ受け継ぎ用
    
    var userName: String!
    var userImageURL: String!
    var userID: String!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = "Wall"
        
        // フォント種をTime New Roman、サイズを10に指定
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSFontAttributeName: UIFont(name: "Times New Roman", size: 15)!]
        
                
        userCollection.delegate = self
        userCollection.dataSource = self
        
        
        

    }
    
    
    
    @IBAction func followButtonDidTap(_ sender: Any) {
        
        print("1")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        //ユーザー投稿を配列に取得
        
        DataService.dataBase.REF_BASE.child("posts").queryOrdered(byChild: "userID").queryEqual(toValue: userID).observe(.value, with: { (snapshot) in
            
            
            
            self.userPosts = []
            
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        print(postDict)
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        
                        self.userPosts.append(post)
                    }
                    
                    
                }
                
                
            }
            
            
            self.userPosts.reverse()
            self.userCollection.reloadData()
            
            
            
            
        })
        
        
        
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = userCollection.dequeueReusableCell(withReuseIdentifier: "userWall", for: indexPath) as? UserCollectionViewCell
        
        cell?.itemImage.image = nil
        
        cell?.clipsToBounds = true
        
        
        //現在のCell
        let post = userPosts[indexPath.row]
        
        cell?.itemLabel.text = userPosts[indexPath.row].name
        
        if userPosts[indexPath.row].imageURL != nil {
            cell?.itemImage.af_setImage(withURL: URL(string: userPosts[indexPath.row].imageURL)!)
        }
        
        
        
        return cell!
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let scaleFactor = (screenWidth / 3) - 4
        
        return CGSize(width: scaleFactor, height: scaleFactor + 0)
    }
    
    //縦の間隔を決定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    //横の間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let headerView = userCollection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UserHeader", for: indexPath) as! UserCollectionReusableView
        
        
        //Follow button
        
        headerView.followButton.backgroundColor = UIColor.clear // 背景色
        headerView.followButton.layer.borderWidth = 1.0 // 枠線の幅
        headerView.followButton.layer.borderColor = UIColor.white.cgColor // 枠線の色
        headerView.followButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        
        
        //ユーザー名
        headerView.userName.text = self.userName
        
        
        //ユーザーのプロフィール画像
        
        let userProfileImageURL = URL(string: userImageURL)
        
            headerView.userImage.af_setImage(withURL: userProfileImageURL!)
            
    
        
        
        
        
        return headerView
    }
    
    

    

}
