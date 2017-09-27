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
    var styleNumBox = [Int]()
    
    //new data
    var folderNameBox = [String]()
    var folderName = String()
    var folderImageURLBox = [String]()
    
    var isPhoto = Bool()
    var postingType = Int()
    
    //data
    var isFollow = Bool()
    var isBasement = Bool()

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        
        myCollection.delegate = self
        myCollection.dataSource = self
        
        self.mainButton.isEnabled = false
        self.photoButton.isHidden = true
        self.photoLabel.isHidden = true
        self.linkButton.isHidden = true
        self.linkLabel.isHidden = true
        
        // ナビゲーションを透明にする処理
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //self.navigationController?.hidesBarsOnSwipe = true
        
        //Individuals
        
        self.folderNameBox = []
        self.folderImageURLBox = []
        self.styleNumBox = []
        
        self.isBasement = true
        
        
        
        
       
        
        
        
    }
    
    
    
    @IBAction func toFollowing(_ sender: Any) {
        performSegue(withIdentifier: "followingLists", sender: nil)
    }
    
    @IBAction func toFollower(_ sender: Any) {
        performSegue(withIdentifier: "followLists", sender: nil)
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        self.tabBarController?.tabBar.isHidden = false
        bottomConstraint.constant = -200
        
        //ログアウトした状態の場合Loginページに飛ばす
        if FIRAuth.auth()?.currentUser == nil {
           
            performSegue(withIdentifier: "SignUp", sender: nil)
            
        }
        
        
        
        
        //Basics
        self.folderNameBox = []
        self.folderImageURLBox = []
        self.styleNumBox = []
        
        
        
        //ユーザーのコレクションの読み込み
        DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: FIRAuth.auth()?.currentUser?.uid).observe(.value, with: { (snapshot) in
            
            self.userPosts = []
            self.folderNameBox = []
            self.folderImageURLBox = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        
                        if postDict["bposts"] as? Dictionary<String, Dictionary<String, AnyObject?>> != nil {
                            
                            let posty = postDict["bposts"] as? Dictionary<String, Dictionary<String, AnyObject>>
                            
                            for (_,value) in posty! {
                                
                                let styleNum = value["bgType"] as! Int
                                self.styleNumBox.append(styleNum)
                                
                                
                                
                            }
                            
                            
                            
                        }
                        
                        if postDict["basics"] as? Dictionary<String, Dictionary<String, AnyObject?>> != nil {
                            
                            
                            let basics = postDict["basics"] as? Dictionary<String, Dictionary<String, String>>
                            
                            for (_,value) in basics! {
                                
                                let basicURL = value["imageURL"]!
                                let basicName = value["name"]!
                                self.folderImageURLBox.append(basicURL)
                                self.folderNameBox.append(basicName)
                                
                                
                                
                            }
                            
                            
                            
                            
                        }
                        
                    }
                    
                    
                    
                }
                
                
                
                
                
            }
            
            
            
            self.folderNameBox.reverse()
            self.folderImageURLBox.reverse()
            self.styleNumBox.reverse()
            
            self.myCollection.reloadData()
            
            
        })
        
        
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
        }
        

        
    }
    
    
    
    //traditional
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var photoLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var linkLabel: UILabel!
    
    
    
    
    //Base 
    @IBOutlet weak var appLabel: UILabel!
    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var bookLabel: UILabel!
    
    @IBOutlet weak var appImage: UIImageView!
    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var bookImage: UIImageView!
    
    @IBOutlet weak var AppButton: UIButton!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var movieButton: UIButton!
    @IBOutlet weak var bookButton: UIButton!
    
    @IBAction func appTapped(_ sender: Any) {
        
        
        self.postingType = 0
        self.tabBarController?.tabBar.isHidden = false
        bottomConstraint.constant = -200
        
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            
            
            self.backgroundButton.alpha = 0
            
            
            
        }
        performSegue(withIdentifier: "ItemSearch", sender: nil)
    }
    
    @IBAction func musicTapped(_ sender: Any) {
        
        self.postingType = 1
        self.tabBarController?.tabBar.isHidden = false
        bottomConstraint.constant = -200
        
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            
            
            self.backgroundButton.alpha = 0
            
            
            
        }
        performSegue(withIdentifier: "ItemSearch", sender: nil)
    }
    
    @IBAction func movieTapped(_ sender: Any) {
        self.postingType = 2
        self.tabBarController?.tabBar.isHidden = false
        bottomConstraint.constant = -200
        
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            
            
            self.backgroundButton.alpha = 0
            
            
            
        }
        performSegue(withIdentifier: "ItemSearch", sender: nil)
    }
    
    @IBAction func bookTapped(_ sender: Any) {
        self.postingType = 3
        self.tabBarController?.tabBar.isHidden = false
        bottomConstraint.constant = -200
        
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            
            
            self.backgroundButton.alpha = 0
            
            
            
        }
        performSegue(withIdentifier: "ItemSearch", sender: nil)
    }
    
    
    @IBAction func pageTabDidTap(_ sender: UISegmentedControl) {
        
        
        
        if sender.selectedSegmentIndex == 0 {
            
            //main隠す
            self.mainLabel.text = "追加"
            self.mainButton.isEnabled = false
            self.photoButton.isHidden = true
            self.photoLabel.isHidden = true
            self.linkButton.isHidden = true
            self.linkLabel.isHidden = true
            
            //base出す
            self.appLabel.isHidden = false
            self.musicLabel.isHidden = false
            self.movieLabel.isHidden = false
            self.bookLabel.isHidden = false
            self.appImage.isHidden = false
            self.musicImage.isHidden = false
            self.movieImage.isHidden = false
            self.bookImage.isHidden = false
            self.AppButton.isHidden = false
            self.musicButton.isHidden = false
            self.movieButton.isHidden = false
            self.bookButton.isHidden = false
            
            
            self.isBasement = true
            
            
            
            
            showIndicator()
            
            //Basics
            self.folderNameBox = []
            self.folderImageURLBox = []
            self.styleNumBox = []
            
            
            
            //ユーザーのコレクションの読み込み
            DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: FIRAuth.auth()?.currentUser?.uid).observe(.value, with: { (snapshot) in
                
                self.userPosts = []
                self.folderNameBox = []
                self.folderImageURLBox = []
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                            if postDict["posts"] as? Dictionary<String, Dictionary<String, AnyObject?>> != nil {
                                
                                let posty = postDict["posts"] as? Dictionary<String, Dictionary<String, AnyObject>>
                                
                                for (_,value) in posty! {
                                    
                                    let styleNum = value["bgType"] as! Int
                                    self.styleNumBox.append(styleNum)
                                    
                                    
                                    
                                }
                                
                                
                                
                            }
                            
                            if postDict["basics"] as? Dictionary<String, Dictionary<String, AnyObject?>> != nil {
                                
                                
                                let basics = postDict["basics"] as? Dictionary<String, Dictionary<String, String>>
                                
                                for (_,value) in basics! {
                                    
                                    let basicURL = value["imageURL"]!
                                    let basicName = value["name"]!
                                    self.folderImageURLBox.append(basicURL)
                                    self.folderNameBox.append(basicName)
                                    
                                    
                                    
                                }
                                
                                
                                
                                
                            }
                            
                        }
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                }
                
                
                
                self.folderNameBox.reverse()
                self.folderImageURLBox.reverse()
                self.styleNumBox.reverse()
                
                self.myCollection.reloadData()
                
                
            })
            
            
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }

            
            
            
            
            
            
        } else {
            
            //main隠す
            self.mainLabel.text = "フォルダの作成"
            self.mainButton.isEnabled = true
            self.photoButton.isHidden = false
            self.photoLabel.isHidden = false
            self.linkButton.isHidden = false
            self.linkLabel.isHidden = false
            
            //base出す
            self.appLabel.isHidden = true
            self.musicLabel.isHidden = true
            self.movieLabel.isHidden = true
            self.bookLabel.isHidden = true
            self.appImage.isHidden = true
            self.musicImage.isHidden = true
            self.movieImage.isHidden = true
            self.bookImage.isHidden = true
            self.AppButton.isHidden = true
            self.musicButton.isHidden = true
            self.movieButton.isHidden = true
            self.bookButton.isHidden = true
            
            
            self.isBasement = false
            showIndicator()
            
            //Individuals
            
            self.folderNameBox = []
            self.folderImageURLBox = []
            self.styleNumBox = []
            
        
            
            //ユーザーのコレクションの読み込み
            DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: FIRAuth.auth()?.currentUser?.uid).observe(.value, with: { (snapshot) in
                
                self.userPosts = []
                self.folderNameBox = []
                self.folderImageURLBox = []
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                            if postDict["posts"] as? Dictionary<String, Dictionary<String, AnyObject?>> != nil {
                                
                                let posty = postDict["posts"] as? Dictionary<String, Dictionary<String, AnyObject>>
                                
                                for (key,value) in posty! {
                                    
                                    let styleNum = value["bgType"] as! Int
                                    self.styleNumBox.append(styleNum)
                                    
                                    
                                    
                                }
                                
                                
                                
                            }
                            
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
                
                
                
                self.folderNameBox.reverse()
                self.folderImageURLBox.reverse()
                self.styleNumBox.reverse()
                
                self.myCollection.reloadData()
                
                
                
                
                
            })
            
            
            
            
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }
            
            
        }
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
        cell?.bgView.layer.cornerRadius = 3.0
        
        cell?.bgView.layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.7).cgColor
        
        cell?.bgView.layer.shadowOpacity = 0.9
        cell?.bgView.layer.shadowRadius = 5.0
        cell?.bgView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        cell?.bgView.layer.borderWidth = 1.0
        cell?.bgView.layer.borderColor = UIColor.white.cgColor // 枠線の色
        
        
        
        cell?.itemTitleLabel.text = folderNameBox[indexPath.row]
        
        let photoURL = FIRAuth.auth()?.currentUser?.photoURL
        
        if folderImageURLBox[indexPath.row] == "" {
            cell?.itemImage.af_setImage(withURL: photoURL!)
        } else if folderImageURLBox[indexPath.row] != "" {
            cell?.itemImage.af_setImage(withURL:  URL(string: self.folderImageURLBox[indexPath.row])!)
        }
        
        
       
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let screenWidth = UIScreen.main.bounds.width
        //let scaleFactor = (screenWidth / 3) - 4
        //let scaleFactor = screenWidth - 32
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
        let headerView = myCollection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Head", for: indexPath) as! SectionHeaderCollectionReusableView
        
        
        
            headerView.editButton.backgroundColor = UIColor.clear // 背景色
            headerView.editButton.layer.borderWidth = 1.0 // 枠線の幅
            headerView.editButton.layer.borderColor = UIColor.white.cgColor // 枠線の色
            headerView.editButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        
            headerView.userProfileImage.layer.borderWidth = 3.0
            headerView.userProfileImage.layer.borderColor = UIColor.white.cgColor // 枠線の色
            headerView.userProfileImage.layer.masksToBounds = true
            headerView.userProfileImage.layer.cornerRadius = 1.0
        
        
            headerView.separator.setTitle("Basic", forSegmentAt: 0)
            headerView.separator.setTitle("自分", forSegmentAt: 1)
            headerView.separator.backgroundColor = UIColor.clear
            headerView.separator.tintColor = UIColor.white
        
        
        
        
                
                //////////////////////
                let user = FIRAuth.auth()?.currentUser
                
                let userName = user?.displayName
                let photoURL = user?.photoURL
                let selfUID = user?.uid
                
                //ユーザー名
                headerView.userProfileName.text = userName
                
                
                //ユーザーのプロフィール画像
                if photoURL != nil {
                    
                    //headerView.userProfileImage.af_setImage(withURL: photoURL!)
                    headerView.userProfileImage.image = UIImage(named: "bgg")
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
    
    var numInt = Int()
    //Item Tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //detailPosts = self.userPosts[indexPath.row]
        
        
        folderName = self.folderNameBox[indexPath.row]
        numInt = self.styleNumBox[indexPath.row]
        
        performSegue(withIdentifier: "toysToFun", sender: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemSearch" {
          
            let itemSearchVC = (segue.destination as? AddbasicsViewController)!
            
            
            itemSearchVC.postType = self.postingType
            
            
        
            
            
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
            
            let another = (segue.destination as? MyToysViewController)!
            
            
            another.folderName = folderName
            another.postsType = numInt
            another.isBasic = self.isBasement
            
            
            
          
            
        } else if segue.identifier == "Options" {
            
            let optionVC = (segue.destination as? FolderNameListsViewController)!
            optionVC.data = isPhoto
            
            
        }
        
        
    }
    
    
    let indicator = UIActivityIndicatorView()
    
    func showIndicator() {
        
        indicator.activityIndicatorViewStyle = .whiteLarge
        
        indicator.center = self.view.center
        
        indicator.color = UIColor.white
        
        indicator.hidesWhenStopped = true
        
        self.view.addSubview(indicator)
        
        self.view.bringSubview(toFront: indicator)
        
        indicator.startAnimating()
        
    }
    
    
    func wait(_ waitContinuation: @escaping (()->Bool), compleation: @escaping (()->Void)) {
        var wait = waitContinuation()
        
        
        // 0.01秒周期で待機条件をクリアするまで待ちます。
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            while wait {
                DispatchQueue.main.async {
                    wait = waitContinuation()
                    semaphore.signal()
                }
                semaphore.wait()
                Thread.sleep(forTimeInterval: 0.01)
            }
            
            
            // 待機条件をクリアしたので通過後の処理を行います。
            DispatchQueue.main.async {
                compleation()
                
                
                
            }
        }
    }
    

}
