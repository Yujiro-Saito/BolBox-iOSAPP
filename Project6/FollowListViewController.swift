//
//  FollowListViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/01.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import AlamofireImage

class FollowListViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet weak var followListCollection: UICollectionView!
    var followUsers = [Post]()
    var detailPosts: Post?
    var followUserNameBox = [String]()
    
    //データ受け継ぎ用
    
    var userID: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        followListCollection.delegate = self
        followListCollection.dataSource = self
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: self.userID).observe(.value, with: { (snapshot) in
            
            //ユーザーのデータ取得
            
            let currentUserID = FIRAuth.auth()?.currentUser?.uid
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        
                        if postDict["following"] as? Dictionary<String, AnyObject?> != nil {
                            
                            let followingDictionary = postDict["following"] as? Dictionary<String, AnyObject?>
                            for (followKey,followValue) in followingDictionary! {
                                
                                print("キーは\(followKey)、値は\(followValue)")
                                
                                //Dataquery
                                //if followkey == uid { usernameとimageURLを配列に追加
                                
                               DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: followKey).observe(.value, with: { (snapshot) in
                                
                                //uidと一致するユーザーの取り出し
                                
                                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                    
                                    for snap in snapshot {
                                        
                                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                            
                                            let userName = postDict["userName"] as? String
                                            let imageURL = postDict["userImageURL"] as? String
                                            
                                            print("ああああああああああああああああああああああ")
                                            print(userName)
                                            print(imageURL)
                                            
                                        }
                                    }
                                }
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                })
                                
                                
                                
                                
                                
                            
                            
                            
                            
                            
                            
                            
                                
                            }
                            
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                }
                
                
            }
            
            
            
        })
        
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followUserNameBox.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = followListCollection.dequeueReusableCell(withReuseIdentifier: "", for: indexPath) 
        
       
        
        
        return cell
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

    
    
    
    

  
}
