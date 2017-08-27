//
//  MyCollectionViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/08/27.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import AlamofireImage


class MyCollectionViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet weak var myCollection: UICollectionView!
    var userPosts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCollection.delegate = self
        myCollection.dataSource = self
        

    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //ログアウトした状態の場合Loginページに飛ばす
        if FIRAuth.auth()?.currentUser == nil {
           
            performSegue(withIdentifier: "SignUp", sender: nil)
            
            
            
        } else if FIRAuth.auth()?.currentUser != nil {
            
            //ユーザーのコレクションの読み込み
            DataService.dataBase.REF_BASE.child("posts").queryOrdered(byChild: "userID").queryEqual(toValue: FIRAuth.auth()?.currentUser?.uid).observe(.value, with: { (snapshot) in
                
                self.userPosts = []
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.userPosts.append(post)
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                
                self.userPosts.reverse()
                self.myCollection.reloadData()
                
                
                
                
            })
            
            
        }
        
       
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollection.dequeueReusableCell(withReuseIdentifier: "myCollectionCell", for: indexPath) as? MyCollectionViewCell
        
        //読み込むまで画像は非表示
        cell?.itemImage.image = nil
        cell?.clipsToBounds = true
        
        //現在のCell
        let post = userPosts[indexPath.row]
        
        
        cell?.itemTitleLabel.text = userPosts[indexPath.row].name
        
        //画像の読み込み
        if self.userPosts[indexPath.row].imageURL != nil {
            cell?.itemImage.af_setImage(withURL:  URL(string: userPosts[indexPath.row].imageURL)!)
        }
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let scaleFactor = (screenWidth / 3) - 6
        
        return CGSize(width: scaleFactor, height: scaleFactor + 45)
    }
    
    //縦の間隔を決定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    //横の間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    
    
     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let headerView = myCollection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Head", for: indexPath) as! SectionHeaderCollectionReusableView
        
        if FIRAuth.auth()?.currentUser != nil {
            
            print("ログインテスト")
            
            let user = FIRAuth.auth()?.currentUser
            
            let userName = user?.displayName
            let photoURL = user?.photoURL
            
            //ユーザー名
            headerView.userProfileName.text = userName
            
            
            //ユーザーのプロフィール画像
            if photoURL != nil {
                
                headerView.userProfileImage.af_setImage(withURL: photoURL!)
                
            } else {
                
            }
            
           
            
        }
        
        
        return headerView
    }
    
    
    
    
    
    
    
    
    
    

 
}
