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
    
    
    @IBOutlet weak var modalView: UIView!
    
    @IBOutlet weak var myCollection: UICollectionView!
    var userPosts = [Post]()
    var detailPosts: Post?
    var amountOfFollowers = Int()
    var numOfFollowing = [String]()
    var numOfFollowers = [String]()
    
    //new data
    var folderNameBox = [String]()
    var folderName = String()
    var folderImageURLBox = [String]()
    
    var isPhoto = Bool()
    
    //data
    var isFollow = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCollection.delegate = self
        myCollection.dataSource = self
        
        // ナビゲーションを透明にする処理
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.blue
        self.navigationController?.hidesBarsOnSwipe = true
            
    }
    
    
    
    @IBAction func toFollowing(_ sender: Any) {
        performSegue(withIdentifier: "followingLists", sender: nil)
    }
    
    @IBAction func toFollower(_ sender: Any) {
        performSegue(withIdentifier: "followLists", sender: nil)
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        //ログアウトした状態の場合Loginページに飛ばす
        if FIRAuth.auth()?.currentUser == nil {
           
            performSegue(withIdentifier: "SignUp", sender: nil)
            
        }
        
        
        
        //ユーザーのコレクションの読み込み
        DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: FIRAuth.auth()?.currentUser?.uid).observe(.value, with: { (snapshot) in
            
            self.userPosts = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        
                        //self.userPosts.append(post)
                        
                        if postDict["folderName"] as? Dictionary<String, AnyObject?> != nil {
                            
                            
                            let folderName = postDict["folderName"] as? Dictionary<String, AnyObject?>
                            
                            for (key,value) in folderName! {
                                
                                self.folderNameBox.append(key)
                                
                                
                            }
                            
                            
                            
                            
                        }
                        
                        
                        
                        if postDict["folderImageURL"] as? Dictionary<String, AnyObject?> != nil {
                            
                            
                            let url = postDict["folderImageURL"] as? Dictionary<String, AnyObject?>
                            
                            for (key,value) in url! {
                                
                                self.folderImageURLBox.append(value as! String)
                                
                                
                            }
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                }
                
                
            }
            
            
            self.userPosts.reverse()
            self.folderNameBox.reverse()
            self.folderImageURLBox.reverse()
            self.myCollection.reloadData()
            
            
            
            
        })

        
        
        
        
        
        
        
        
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        
        self.folderNameBox = []
        self.folderImageURLBox = []
    }
    
    @IBOutlet weak var backgroundButton: UIButton!
    
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBAction func closeModal(_ sender: Any) {
        
        self.tabBarController?.tabBar.isHidden = false
        bottomConstraint.constant = -200
        
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            
            
            self.backgroundButton.alpha = 0
            
            
            
        }

        
        
    }
    
    
    
    @IBAction func newFolder(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        bottomConstraint.constant = -200
        
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            
            
            self.backgroundButton.alpha = 0
            
            
            
        }
        self.performSegue(withIdentifier: "MakeFolder", sender: nil)
    }
    
    
    @IBAction func photo(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        bottomConstraint.constant = -200
        
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            
            
            self.backgroundButton.alpha = 0
            
            
            
        }
        self.isPhoto = true
        self.performSegue(withIdentifier: "Options", sender: nil)
    }
    
    @IBAction func link(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        bottomConstraint.constant = -200
        
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            
            
            self.backgroundButton.alpha = 0
            
            
            
        }
        self.isPhoto = false
        self.performSegue(withIdentifier: "Options", sender: nil)
        
    }
    
    @IBAction func actionButtonDidTap(_ sender: Any) {
        
        self.tabBarController?.tabBar.isHidden = true
        
        bottomConstraint.constant = 0
        
        
        UIView.animate(withDuration: 0.15) {
            self.view.layoutIfNeeded()
            
            
            self.backgroundButton.alpha = 0.5
            
            
            
        }
        
        
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folderNameBox.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollection.dequeueReusableCell(withReuseIdentifier: "myCollectionCell", for: indexPath) as? MyCollectionViewCell
        
        //読み込むまで画像は非表示
        cell?.itemImage.image = nil
        cell?.layer.masksToBounds = true
        cell?.layer.cornerRadius = 5.0
        
        cell?.itemTitleLabel.text = folderNameBox[indexPath.row]
        
        
        //cell?.itemImage.layer.cornerRadius = 1.0
        //cell?.itemImage.layer.cornerRadius = 10.0
        //現在のCell
        //let post = userPosts[indexPath.row]
        
        
        
        
        
        //画像の読み込み
        if self.folderImageURLBox[indexPath.row] == "" {
            cell?.itemImage.image = UIImage(named: "")
        }
        
        else if self.folderImageURLBox[indexPath.row] != "" {
            cell?.itemImage.af_setImage(withURL:  URL(string: self.folderImageURLBox[indexPath.row])!)
        }
        
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        //let scaleFactor = (screenWidth / 3) - 4
        let scaleFactor = screenWidth - 32
        
        return CGSize(width: scaleFactor, height: 100)
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
        let headerView = myCollection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Head", for: indexPath) as! SectionHeaderCollectionReusableView
        
        
        
        
            
            
            headerView.editButton.backgroundColor = UIColor.clear // 背景色
            headerView.editButton.layer.borderWidth = 1.0 // 枠線の幅
            headerView.editButton.layer.borderColor = UIColor.white.cgColor // 枠線の色
            headerView.editButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        
                
                //////////////////////
                let user = FIRAuth.auth()?.currentUser
                
                let userName = user?.displayName
                let photoURL = user?.photoURL
                let selfUID = user?.uid
                
                //ユーザー名
                headerView.userProfileName.text = userName
                
                
                //ユーザーのプロフィール画像
                if photoURL != nil {
                    
                    headerView.userProfileImage.af_setImage(withURL: photoURL!)
                    
                }
                
                
                //Followのチェック follower数のチェック
                DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: selfUID!).observe(.value, with: { (snapshot) in
                    
                    
                    if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        
                        for snap in snapshot {
                            print("SNAP: \(snap)")
                            
                            if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                
                                //followwer人数をラベルに表示
                                let countOfFollowers = postDict["followerNum"] as? Int
                                headerView.followerLabel.text = String(describing: countOfFollowers!)
                                self.amountOfFollowers = countOfFollowers!
                                
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
                
            
            //フォロー数
            headerView.followingLabel.text = String(self.numOfFollowing.count)
            
            self.numOfFollowing = []
            
        
        
        
        
        return headerView
    }
    
    
    //Item Tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //detailPosts = self.userPosts[indexPath.row]
        
        
        folderName = self.folderNameBox[indexPath.row]
        
        //performSegue(withIdentifier: "GoCheck", sender: nil)
        
        performSegue(withIdentifier: "toysToFun", sender: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoCheck" {
            
            let detailVC = (segue.destination as? InfomationViewController)!
            
            
            detailVC.name = detailPosts?.name
            detailVC.numLikes = (detailPosts?.pvCount)!
            detailVC.imageURL = detailPosts?.imageURL
            detailVC.linkURL = detailPosts?.linkURL
            detailVC.userName = detailPosts?.userProfileName
            detailVC.userID = detailPosts?.userID
            detailVC.userImageURL = detailPosts?.userProfileImage
            detailVC.postID = detailPosts?.postID
            
            
            
        } else if segue.identifier == "followLists" {
            
            let followVC = (segue.destination as? FriendsListsViewController)!
            
            let currentUserID = FIRAuth.auth()?.currentUser?.uid
            
            followVC.userID = currentUserID!
            
            followVC.isFollowing = false
            
            
        } else if segue.identifier == "followingLists" {
            
            
            let followVC = (segue.destination as? FriendsListsViewController)!
            
            let currentUserID = FIRAuth.auth()?.currentUser?.uid
            
            followVC.userID = currentUserID!
            
            followVC.isFollowing = true
        } else if segue.identifier == "toysToFun" {
            
            let toysVC = (segue.destination as? MyToysViewController)!
            
            toysVC.folderName = folderName
          
            
        } else if segue.identifier == "Options" {
            
            let optionVC = (segue.destination as? FolderNameListsViewController)!
            optionVC.data = isPhoto
            
            
        }
        
        
    }
}
