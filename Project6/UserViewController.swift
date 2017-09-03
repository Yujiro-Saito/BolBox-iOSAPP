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
    @IBOutlet weak var cardView: UIView!
    
    
    let headerAccess = UserCollectionReusableView()
    var userPosts = [Post]()
    var detailPosts: Post?
    var numOfFollowers = [String]()
    var numOfFollowing = [String]()
    var amountOfFollowers = Int()
    
    //データ受け継ぎ用
    
    var userName: String!
    var userImageURL: String!
    var userID: String!
    
    var isFollow = Bool()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = "Wall"
        
        // フォント種をTime New Roman、サイズを10に指定
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSFontAttributeName: UIFont(name: "Times New Roman", size: 18)!]
        
        userCollection.delegate = self
        userCollection.dataSource = self
        

    }
    

    @IBAction func followerButtonDidTap(_ sender: Any) {
        
        performSegue(withIdentifier: "followLists", sender: nil)
        
    }
    
    
    @IBAction func followingButtonDidTap(_ sender: Any) {
        
        performSegue(withIdentifier: "followingLists", sender: nil)
        
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
    
    func onClick(_ sender: AnyObject){
        
        
        let button = sender as! UIButton
        
        let currentUserUID = FIRAuth.auth()?.currentUser?.uid
        let followersUID: Dictionary<String, String> = [currentUserUID! : currentUserUID!]
        let uidWhoUFollow: Dictionary<String, String> = [self.userID! : self.userID!]
        let followersCount = ["followerNum": self.amountOfFollowers]
        
        //フォローしていない場合
        
        if isFollow == false {
            
            
            self.amountOfFollowers += 1
            
            
            let followersCount = ["followerNum": self.amountOfFollowers]
            
            DataService.dataBase.REF_BASE.child("users/\(self.userID!)/followers").updateChildValues(followersUID)
            DataService.dataBase.REF_BASE.child("users/\(currentUserUID!)/following").updateChildValues(uidWhoUFollow)
            
            //フォロー数を更新
            DataService.dataBase.REF_BASE.child("users/\(self.userID!)").updateChildValues(followersCount)
            button.backgroundColor = .green
            isFollow = true
            
        } else if isFollow == true {
            
            self.amountOfFollowers -= 1
            let followersCount = ["followerNum": self.amountOfFollowers]
            
            
            //フォロしている場合
            DataService.dataBase.REF_BASE.child("users/\(self.userID!)/followers/\(currentUserUID!)").removeValue()
            DataService.dataBase.REF_BASE.child("users/\(currentUserUID!)/following/\(self.userID!)").removeValue()
            
            //フォロー数を更新
            DataService.dataBase.REF_BASE.child("users/\(self.userID!)").updateChildValues(followersCount)
            
            button.backgroundColor = .clear
            
            isFollow = false
        }
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
        
        let currentUserID = FIRAuth.auth()?.currentUser?.uid
        //Follow button
        
        headerView.followButton.backgroundColor = UIColor.clear // 背景色
        headerView.followButton.layer.borderWidth = 1.0 // 枠線の幅
        headerView.followButton.layer.borderColor = UIColor.darkGray.cgColor // 枠線の色
        headerView.followButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        
        headerView.cardDesign.layer.cornerRadius = 3.0
        
        headerView.followButton.addTarget(self, action: #selector(self.onClick(_:)), for: .touchUpInside)
        
        
        //Followのチェック follower数のチェック
        DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: self.userID).observe(.value, with: { (snapshot) in
            
            //ユーザーのデータ取得
            
            
            let currentUserID = FIRAuth.auth()?.currentUser?.uid
            
            if self.userID == currentUserID! {
                
                headerView.followButton.isHidden = true
                
            }
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        
                        //follow人数をラベルに表示
                        let countOfFollowers = postDict["followerNum"] as? Int
                        headerView.followerLabel.text = String(describing: countOfFollowers!)
                        self.amountOfFollowers = countOfFollowers!
                        
                        
                        if postDict["followers"] as? Dictionary<String, AnyObject?> != nil {
                            
                            let followingDictionary = postDict["followers"] as? Dictionary<String, AnyObject?>
                            for (followKey,followValue) in followingDictionary! {
                                
                                
                                self.numOfFollowers.append(followKey)
                                
                                
                                
                                
                                if followKey == currentUserID {
                                    //フォローしている
                                    headerView.followButton.backgroundColor = UIColor.green
                                    self.isFollow = true
                                    
                                } else {
                                    //フォローしていない
                                    headerView.followButton.backgroundColor = UIColor.clear
                                    self.isFollow = false
                                }
                                
                                
                            }
                            
                            

                        }
                        
                       
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                }
                
                
            }
            
            
            
        })
        
        
        
        
        //フォロー人数のチェック
        
        DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: self.userID).observe(.value, with: { (snapshot) in
            
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        
                        
                        if postDict["following"] as? Dictionary<String, AnyObject?> != nil {
                            
                            let followingDictionary = postDict["following"] as? Dictionary<String, AnyObject?>
                            for (followKey,followValue) in followingDictionary! {
                                
                                print("キーは\(followKey)、値は\(followValue)")
                                
                                self.numOfFollowing.append(followKey)
                                
                                
                            }
                            
                            
                            
                        }
                        
                        
                        
                        
                    }
                }
            }
            
            
            
            
        })
        
        
        
        
        
        

        
        
        //ユーザー名
        headerView.userName.text = self.userName
        //フォローワー数
        //headerView.followerLabel.text = String(self.numOfFollowers.count)
        //フォロー数
        headerView.followingLabel.text = String(self.numOfFollowing.count)
        
        self.numOfFollowers = []
        self.numOfFollowing = []
        
        //ユーザーのプロフィール画像
        
        let userProfileImageURL = URL(string: userImageURL)
        
            headerView.userImage.af_setImage(withURL: userProfileImageURL!)
            
    
        
        
        
        
        return headerView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "followLists" {
            
            let followVC = (segue.destination as? FriendsListsViewController)!
            
            followVC.userID = self.userID
            
            followVC.isFollowing = false
            
            
        } else if segue.identifier == "followingLists" {
            
            
            let followVC = (segue.destination as? FriendsListsViewController)!
            
            followVC.userID = self.userID
            
            followVC.isFollowing = true
            
        }
        
        
        
        
        
        
        
        
        
        
        
    }
    
    

    

}
