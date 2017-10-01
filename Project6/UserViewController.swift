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
    
    
    var userPosts = [Post]()
    var detailPosts: Post?
    var numOfFollowers = [String]()
    var numOfFollowing = [String]()
    var amountOfFollowers = Int()
    let uidss: String = (FIRAuth.auth()?.currentUser?.uid)!
    
    //データ受け継ぎ用
    
    var userName: String!
    var userImageURL: String!
    var userID: String!
    var visitorUID : String!
    
    var isFollow = Bool()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // フォント種をTime New Roman、サイズを10に指定
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSFontAttributeName: UIFont(name: "Times New Roman", size: 18)!]
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.blue
        self.navigationController?.hidesBarsOnSwipe = true
        
        
        userCollection.delegate = self
        userCollection.dataSource = self
        
        
        

    }
    

    @IBAction func followerButtonDidTap(_ sender: Any) {
        
        performSegue(withIdentifier: "followLists", sender: nil)
        
    }
    
    
    @IBAction func followingButtonDidTap(_ sender: Any) {
        
        performSegue(withIdentifier: "followingLists", sender: nil)
        
    }
    
    
    
    var folderNameBox = [String]()
    var folderName = String()
    var folderImageURLBox = [String]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        
        
        
        //ユーザーのコレクションの読み込み
        DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: userID).observe(.value, with: { (snapshot) in
         
            self.userPosts = []
            self.folderNameBox = []
            self.folderImageURLBox = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        
                        
                        
                        
                        
                        
                       
                        
                        if postDict["folderName"] as? Dictionary<String, Dictionary<String, AnyObject?>> != nil {
                            
                            
                            let folderName = postDict["folderName"] as? Dictionary<String, Dictionary<String, String>>
                            
                            for (key,value) in folderName! {
                                
                                let valueImageURL = value["imageURL"] as! String
                                let valueText = value["name"] as! String
                                self.folderImageURLBox.append(valueImageURL)
                                self.folderNameBox.append(valueText)
                                
                                
                                
                            }
                            
                            
                            
                            
                        }
                        
                    }
                    
                    
                    
                }
                
                
                
                
                
            }
            
            
            self.userPosts.reverse()
            self.folderNameBox.reverse()
            self.folderImageURLBox.reverse()
            
            self.userCollection.reloadData()
            
            
        })
        
        
        
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folderNameBox.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = userCollection.dequeueReusableCell(withReuseIdentifier: "userWall", for: indexPath) as? UserCollectionViewCell
        
        cell?.itemImage.image = nil
        
        cell?.clipsToBounds = true
        
        cell?.bgView.layer.cornerRadius = 3.0
        
        cell?.bgView.layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.7).cgColor
        
        cell?.bgView.layer.shadowOpacity = 0.9
        cell?.bgView.layer.shadowRadius = 5.0
        cell?.bgView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        cell?.bgView.layer.borderWidth = 1.0
        cell?.bgView.layer.borderColor = UIColor.white.cgColor // 枠線の色
        
        
        
        cell?.itemLabel.text = folderNameBox[indexPath.row]
        
        cell?.itemImage.af_setImage(withURL:  URL(string: self.folderImageURLBox[indexPath.row])!)
        
        
        return cell!
    }
    
    func onClick(_ sender: AnyObject){
        
        
        
        
        

        
        
        
        let button = sender as! UIButton
        //自分 useriDがこの人
        
        let followersUID: Dictionary<String, String> = [self.uidss : self.uidss]
        let uidWhoUFollow = [self.userID! : self.userID!]
        var followersCount = ["followerNum": self.amountOfFollowers]
        
        //DataService.dataBase.REF_BASE.child("users/\(self.uidss)/following").updateChildValues(uidWhoUFollow)
        
        
        
        
        
        //フォローしていない場合
        
        if isFollow == false {
            
            
            self.amountOfFollowers += 1
            
            var numFollowings = self.numOfFollowing.count
            numFollowings += 1
            let numing = ["followingNum": numFollowings]
            
            
            followersCount = ["followerNum": self.amountOfFollowers]
            
           
           
            
            DispatchQueue.main.async {
                
                DataService.dataBase.REF_BASE.child("users/\(self.uidss)/following").updateChildValues(uidWhoUFollow)
                
                DataService.dataBase.REF_BASE.child("users/\(self.userID!)/followers").updateChildValues(followersUID)
                
                //フォロー数を更新
                DataService.dataBase.REF_BASE.child("users/\(self.userID!)").updateChildValues(followersCount)
                
                DataService.dataBase.REF_BASE.child("users/\(self.uidss)").updateChildValues(numing)
            }
            
            
            button.backgroundColor = .green
            isFollow = true
            
        } else if isFollow == true {
            
            self.amountOfFollowers -= 1
            let followersCount = ["followerNum": self.amountOfFollowers]
            
            
            var numFollowings = self.numOfFollowing.count
            numFollowings -= 1
            let numing = ["followingNum": numFollowings]
            
            DispatchQueue.main.async {
                //フォロしている場合
                DataService.dataBase.REF_BASE.child("users/\(self.uidss)/following/\(self.userID!)").removeValue()
                DataService.dataBase.REF_BASE.child("users/\(self.userID!)/followers/\(self.uidss)").removeValue()
                
                //フォロー数を更新
                DataService.dataBase.REF_BASE.child("users/\(self.userID!)").updateChildValues(followersCount)
                
                DataService.dataBase.REF_BASE.child("users/\(self.uidss)").updateChildValues(numing)
            }
            
            
            
            
            button.backgroundColor = .clear
            
            isFollow = false
        }
 
 
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSize:CGFloat = self.view.frame.size.width/2-2
        
        return CGSize(width: cellSize, height: 200)
    }
    
    //縦の間隔を決定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
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
        
        
        if self.isFollow == true {
            headerView.followButton.backgroundColor = UIColor.green // 背景色
            headerView.followButton.layer.borderWidth = 1.0 // 枠線の幅
            headerView.followButton.layer.borderColor = UIColor.darkGray.cgColor // 枠線の色
            headerView.followButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        } else if self.isFollow == false {
            headerView.followButton.backgroundColor = UIColor.clear // 背景色
            headerView.followButton.layer.borderWidth = 1.0 // 枠線の幅
            headerView.followButton.layer.borderColor = UIColor.darkGray.cgColor // 枠線の色
            headerView.followButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        }
        
        
        
        
        
        
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
                        let countOfFollowing = postDict["followingNum"] as? Int
                        headerView.followingLabel.text = String(describing: countOfFollowing!)
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
        
        
        
        
        var numFollowings = self.numOfFollowing.count
        

        
        
        //ユーザー名
        headerView.userName.text = self.userName
        //フォローワー数
        //フォロー数
       // headerView.followingLabel.text = String(self.numOfFollowing.count)
        headerView.followingLabel.text = String(numFollowings)
        /////////
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
        
        
        else if segue.identifier == "MyTOysView" {
            
            
            let another = (segue.destination as? MyToysViewController)!
            
            
            another.folderName = folderName
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        folderName = self.folderNameBox[indexPath.row]
        
        performSegue(withIdentifier: "MyTOysView", sender: nil)
        
        
        
    }
    
    

    var numberInt = Int()
    
    
    

}
