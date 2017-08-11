//
//  BaseViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/27.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class BaseViewController: UIViewController,UINavigationBarDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //Outlet
    @IBOutlet weak var baseNavBar: UINavigationBar!
    @IBOutlet weak var topCollectionTable: UICollectionView!
    @IBOutlet weak var firstCollection: UICollectionView!
    @IBOutlet weak var secondCollection: UICollectionView!
    @IBOutlet weak var thirdCollection: UICollectionView!
    //@IBOutlet weak var fourthCollection: UICollectionView!
    @IBOutlet weak var fifthCollection: UICollectionView!
    @IBOutlet weak var purposeCollection: UICollectionView!
    
    @IBOutlet weak var baseTab: UITabBarItem!
    
        
    
    
    //プロパティ
    var displayUserName: String?
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var initialURL = URL(string: "")
    var selectedIndex = Int()
    var numReadMore = Int()
    
    //コレクションビュー用の配列
    var topPosts = [Post]()
    var firstPosts = [Post]()
    var secondPosts = [Post]()
    var thirdPosts = [Post]()
    var fourthPosts = [Post]()
    var fifthPosts = [Post]()
    var purposePosts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //DELEGATE
        baseNavBar.delegate = self
        topCollectionTable.delegate = self
        topCollectionTable.dataSource = self
        firstCollection.delegate = self
        firstCollection.dataSource = self
        secondCollection.delegate = self
        secondCollection.dataSource = self
        thirdCollection.delegate = self
        thirdCollection.dataSource = self
        fifthCollection.delegate = self
        fifthCollection.dataSource = self
        purposeCollection.delegate = self
        purposeCollection.dataSource = self
        
        
        
        //バーの高さ
        self.baseNavBar.frame = CGRect(x: 0,y: 0, width: UIScreen.main.bounds.size.width, height: 60)
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir", size: 15)!]
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //注目のデータ読み込み
        DataService.dataBase.REF_TOP.observe(.value, with: { (snapshot) in
            
            self.topPosts = []
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        self.topPosts.append(post)
                        self.topCollectionTable.reloadData()
                    }
                    
                    
                }
                
                
            }
            
        })
        
        //Firstのデータ読み込み
        DataService.dataBase.REF_FIRST.queryLimited(toLast: 3).observe(.value, with: { (snapshot) in
            
            self.firstPosts = []
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        self.firstPosts.append(post)
                        self.firstCollection.reloadData()
                    }
                    
                    
                }
                
                
            }
            
        })
        
        
        
        //Secondのデータ読み込み
        DataService.dataBase.REF_SECOND.queryLimited(toLast: 3).observe(.value, with: { (snapshot) in
            
            self.secondPosts = []
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        self.secondPosts.append(post)
                        self.secondCollection.reloadData()
                    }
                    
                    
                }
                
                
            }
            
        })
        
        
        
        
        //Thirdのデータ読み込み
        DataService.dataBase.REF_THIRD.queryLimited(toLast: 3).observe(.value, with: { (snapshot) in
            
            self.thirdPosts = []
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        self.thirdPosts.append(post)
                        self.thirdCollection.reloadData()
                    }
                    
                    
                }
                
                
            }
            
        })
        
        
        
        
        
        
        ////Fifthのデータ読み込み
        
        DataService.dataBase.REF_FIFTH.queryLimited(toLast: 3).observe(.value, with: { (snapshot) in
            
            self.fifthPosts = []
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        self.fifthPosts.append(post)
                        self.fifthCollection.reloadData()
                    }
                    
                    
                }
                
                
            }
            
        })

        
        
        //Purposeのデータ読み込み
        DataService.dataBase.REF_PURPOSE.observe(.value, with: { (snapshot) in
            
            self.purposePosts = []
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        self.purposePosts.append(post)
                        self.purposeCollection.reloadData()
                    }
                    
                    
                }
                
                
            }
            
        })
        
        
        
        
        
        
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        
        //ログアウトした状態の場合Loginページに飛ばす
        if FIRAuth.auth()?.currentUser == nil {
            
           
            //foreverあればlogin画面
            if UserDefaults.standard.object(forKey: "Forever") != nil {
                performSegue(withIdentifier: "backtoRegister", sender: nil)
                
            } else if UserDefaults.standard.object(forKey: "Forever") == nil {
            //なければ(初期登録
                UserDefaults.standard.set("Forever", forKey: "Forever")
                
                showIndicator()
                
                FIRAuth.auth()?.signInAnonymously() { (user, error) in
                    if error == nil {
                        
                        let changeRequest = user?.profileChangeRequest()
                        
                        //ゲスト名前 ユーザー名
                        
                        let randomGuestNum = arc4random_uniform(2000)
                        print(randomGuestNum)
                        
                        changeRequest?.displayName = "ゲスト\(randomGuestNum)"
                        
                        changeRequest?.commitChanges { error in
                            if let error = error {
                                
                                print(error.localizedDescription)
                                
                                DispatchQueue.main.async {
                                    
                                    self.indicator.stopAnimating()
                                }
                                
                                
                                
                            } else {
                                
                                //成功 ホーム画面に移動
                                
                                DispatchQueue.main.async {
                                    
                                    self.indicator.stopAnimating()
                                }
                                
                                
                                print("匿名ログインに成功")
                                
                                
                                
                                
                            }
                        }
                        
                        
                    }
                    
                    
                    
                }
                
                
                
                
                
                
                
                
                
                
                
                                                        }
                
                
                
                
                
                
            
            
            
        }else if FIRAuth.auth()?.currentUser != nil {
            
            
            let currentUserCheck = FIRAuth.auth()?.currentUser!
            
            
            //初回登録
            if UserDefaults.standard.object(forKey: "Forever") == nil {
                
                UserDefaults.standard.set("Forever", forKey: "Forever")
                
                showIndicator()
                
                FIRAuth.auth()?.signInAnonymously() { (user, error) in
                    if error == nil {
                        
                        let changeRequest = user?.profileChangeRequest()
                        
                        //ゲスト名前 ユーザー名
                        
                        let randomGuestNum = arc4random_uniform(2000)
                        print(randomGuestNum)
                        
                        changeRequest?.displayName = "ゲスト\(randomGuestNum)"
                        
                        changeRequest?.commitChanges { error in
                            if let error = error {
                                
                                print(error.localizedDescription)
                                
                                DispatchQueue.main.async {
                                    
                                    self.indicator.stopAnimating()
                                }
                                
                                
                                
                            } else {
                                
                                //成功 ホーム画面に移動
                                
                                DispatchQueue.main.async {
                                    
                                    self.indicator.stopAnimating()
                                }
                                
                                
                                print("匿名ログインに成功")
                                
                                
                                
                                
                            }
                        }
                        
                        
                    }
                    
                    
                    
                }
                
                
            } else {
                
                print("２回目以降")
                
                let anonymousUser = currentUserCheck?.isAnonymous
                
                if anonymousUser == true {
                    //ゲストユーザー
                    print(currentUserCheck?.displayName!)
                } else if anonymousUser == false {
                    //
                    
                    
                }
                
                
                
                
                
                
                
                
                
                
                
                
            }
            
            
            
        }
        
        
        
        
       
        
 
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        //セルサイズを可変にする
        if collectionView == self.topCollectionTable {
            return CGSize(width: self.view.frame.size.width, height: 300)
        } else if collectionView == self.purposeCollection {
            return CGSize(width: 180, height: 102)
        } else {
            return CGSize(width: 181, height: 221)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == topCollectionTable {
            //Top記事のセル
            let topCell = topCollectionTable.dequeueReusableCell(withReuseIdentifier: "topCell", for: indexPath) as? newCollectionViewCell
            
            topCell?.celImage.image = nil
            
            let post = topPosts[indexPath.row]
            
            if post.imageURL != nil {
                topCell?.celImage.af_setImage(withURL: URL(string: self.topPosts[indexPath.row].imageURL)!)
            }
            
            topCell?.attentionLabel.text = "注目\(indexPath.row + 1)"
            
            
            
            
            if let img = BaseViewController.imageCache.object(forKey: post.imageURL as! NSString) {
                topCell?.configureCell(post: post, img: img)
            } else {
                topCell?.configureCell(post: post)
            }
            
            return topCell!
            
        } else if collectionView == firstCollection {
            //一番目の記事のセル
            
            
            let firstCell = firstCollection.dequeueReusableCell(withReuseIdentifier: "firstCell", for: indexPath) as? FirstCollectionViewCell
            
            firstCell?.firstImage.image = nil
            
            let post = firstPosts[indexPath.row]
            
            if self.firstPosts[indexPath.row].imageURL != nil {
                firstCell?.firstImage.af_setImage(withURL: URL(string: self.firstPosts[indexPath.row].imageURL)!)
            }
            
            if let img = BaseViewController.imageCache.object(forKey: post.imageURL as! NSString) {
                firstCell?.configureCell(post: post, img: img)
            } else {
                firstCell?.configureCell(post: post)
                
                
            }
            
            return firstCell!
            
            
            
            
        } else if collectionView == secondCollection {
            
            //2番目の記事のセル
            
            let secondCell = secondCollection.dequeueReusableCell(withReuseIdentifier: "secondCell", for: indexPath) as? SecondCollectionViewCell
            
            secondCell?.cellImage.image = nil
            
            let post = secondPosts[indexPath.row]
            
            if post.imageURL != nil {
                secondCell?.cellImage.af_setImage(withURL: URL(string: self.secondPosts[indexPath.row].imageURL)!)
            }
            
            if let img = BaseViewController.imageCache.object(forKey: post.imageURL as! NSString) {
                secondCell?.configureCell(post: post, img: img)
            } else {
                secondCell?.configureCell(post: post)
                
                
            }
            
            return secondCell!
            

        } else if collectionView == thirdCollection {
            
            //3番目の記事のセル
            
            let thirdCell = thirdCollection.dequeueReusableCell(withReuseIdentifier: "thirdCell", for: indexPath) as? ThirdCollectionViewCell
            
            thirdCell?.cellImage.image = nil
            
            
            let post = thirdPosts[indexPath.row]
            
            if post.imageURL != nil {
                thirdCell?.cellImage.af_setImage(withURL: URL(string: self.thirdPosts[indexPath.row].imageURL)!)
            }
            
            if let img = BaseViewController.imageCache.object(forKey: post.imageURL as! NSString) {
                thirdCell?.configureCell(post: post, img: img)
            } else {
                thirdCell?.configureCell(post: post)
                
                
            }
            
            return thirdCell!
            
           
            
        }  else if collectionView == fifthCollection {
            
            
            //5番目の記事のセル
            let fifthCell = fifthCollection.dequeueReusableCell(withReuseIdentifier: "fifthCell", for: indexPath) as? FifthCollectionViewCell
            
            fifthCell?.cellImage.image = nil
            
            let post = fifthPosts[indexPath.row]
            
            if post.imageURL != nil {
                fifthCell?.cellImage.af_setImage(withURL: URL(string: self.fifthPosts[indexPath.row].imageURL)!)
            }
            
            
            if let img = BaseViewController.imageCache.object(forKey: post.imageURL as! NSString) {
                fifthCell?.configureCell(post: post, img: img)
            } else {
                fifthCell?.configureCell(post: post)
                
                
            }
            
            
            
            return fifthCell!
            
            
            
        } else if collectionView == purposeCollection {
            
            let purposeCell = purposeCollection.dequeueReusableCell(withReuseIdentifier: "purposeCell", for: indexPath) as? PurposeCollectionViewCell
            
            purposeCell?.cellImage.image = nil
            
            let post = purposePosts[indexPath.row]
            
            if post.imageURL != nil {
                purposeCell?.cellImage.af_setImage(withURL: URL(string: self.purposePosts[indexPath.row].imageURL)!)
            }
            
            
            if let img = BaseViewController.imageCache.object(forKey: post.imageURL as! NSString) {
                purposeCell?.configureCell(post: post, img: img)
            } else {
                purposeCell?.configureCell(post: post)
                
                
            }
            
            
            
            return purposeCell!

            
            
            
            
            
            
        }
        
        
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == topCollectionTable {
            return topPosts.count
        } else if collectionView == firstCollection {
            return firstPosts.count
        } else if collectionView == secondCollection {
            return secondPosts.count
        } else if collectionView == thirdCollection {
            return thirdPosts.count
        }  else if collectionView == fifthCollection {
            return fifthPosts.count
        } else if collectionView == purposeCollection {
            return purposePosts.count
        }
        
        return 1
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //詳細画面遷移時のデータ引き継ぎ
    
    var detailPosts: Post?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "topPosts" {
            let detailVc = (segue.destination as? InDetailViewController)!
            
            detailVc.name = detailPosts?.name
            detailVc.numLikes = (detailPosts?.pvCount)!
            detailVc.whatContent = detailPosts?.whatContent
            detailVc.imageURL = detailPosts?.imageURL
            detailVc.linkURL = detailPosts?.linkURL
        } else if segue.identifier == "backtoRegister" {
            
            print("ログイン画面に戻る")
            
        } else if segue.identifier == "ToFeature" {
            
            let featureVC = (segue.destination as? FeatureViewController)!
            
            
            featureVC.selectedNum = self.selectedIndex
            
            
            
        } else if segue.identifier == "ReadMoreIndex" {
            
            
            let featureVC = (segue.destination as? FeatureViewController)!
            
            
            featureVC.readMoreNum = self.numReadMore
            
            
            
            
            
        }
        
        
        
        
        
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if collectionView == topCollectionTable {
            
            detailPosts = self.topPosts[indexPath.row]
            
            
            //IDの設定、pv数
            let separateID = self.topPosts[indexPath.row].postID
            var readCount = self.topPosts[indexPath.row].readCount
            
            
            print(separateID)
            print(readCount)
            
            readCount += 1
            
            let readAmount = ["readCount": readCount]
            
            DataService.dataBase.REF_BASE.child("topReccomend/\(separateID)").updateChildValues(readAmount)
            
            
            
            
            performSegue(withIdentifier: "topPosts", sender: nil)
            
            
        } else if collectionView == purposeCollection {
            
            //選ばれた番号　0,1,2のどれか
            selectedIndex = indexPath.row
            
            
            performSegue(withIdentifier: "ToFeature", sender: nil)
            
        } else if collectionView == firstCollection {
            
            detailPosts = self.firstPosts[indexPath.row]
            
            
            //IDの設定、pv数
            let separateID = self.firstPosts[indexPath.row].postID
            var readCount = self.firstPosts[indexPath.row].readCount
            
            
            print(separateID)
            print(readCount)
            
            readCount += 1
            
            let readAmount = ["readCount": readCount]
            
            DataService.dataBase.REF_BASE.child("first/\(separateID)").updateChildValues(readAmount)
            
            
            
            performSegue(withIdentifier: "topPosts", sender: nil)
            
            
            
        } else if collectionView == secondCollection {
            
            detailPosts = self.secondPosts[indexPath.row]
            
            //IDの設定、pv数
            let separateID = self.secondPosts[indexPath.row].postID
            var readCount = self.secondPosts[indexPath.row].readCount
            
            
            print(separateID)
            print(readCount)
            
            readCount += 1
            
            let readAmount = ["readCount": readCount]
            
            DataService.dataBase.REF_BASE.child("second/\(separateID)").updateChildValues(readAmount)
            
            performSegue(withIdentifier: "topPosts", sender: nil)
            
            
        } else if collectionView == thirdCollection {
            
            
            detailPosts = self.thirdPosts[indexPath.row]
            
            //IDの設定、pv数
            let separateID = self.thirdPosts[indexPath.row].postID
            var readCount = self.thirdPosts[indexPath.row].readCount
            
            
            print(separateID)
            print(readCount)
            
            readCount += 1
            
            let readAmount = ["readCount": readCount]
            
            DataService.dataBase.REF_BASE.child("third/\(separateID)").updateChildValues(readAmount)
            
            
            
            performSegue(withIdentifier: "topPosts", sender: nil)
            
        }  else if collectionView == fifthCollection {
            
            detailPosts = self.fifthPosts[indexPath.row]
            
            //IDの設定、pv数
            let separateID = self.fifthPosts[indexPath.row].postID
            var readCount = self.fifthPosts[indexPath.row].readCount
            
            
            print(separateID)
            print(readCount)
            
            readCount += 1
            
            let readAmount = ["readCount": readCount]
            
            DataService.dataBase.REF_BASE.child("fifth/\(separateID)").updateChildValues(readAmount)
            
            
            performSegue(withIdentifier: "topPosts", sender: nil)
            
        }
        
        
        
        
        
    }
    
    
   
    
    @IBAction func oneReadMore(_ sender: Any) {
        
        
        self.numReadMore = 1
        
        performSegue(withIdentifier: "ReadMoreIndex", sender: nil)
        
    }
    
    
    @IBAction func twoReadMore(_ sender: Any) {
        
        self.numReadMore = 2
        
        performSegue(withIdentifier: "ReadMoreIndex", sender: nil)
    }
   
    
    
    @IBAction func threeReadMore(_ sender: Any) {
        
        self.numReadMore = 3
        
        performSegue(withIdentifier: "ReadMoreIndex", sender: nil)
    }
    
    @IBAction func fourReadMore(_ sender: Any) {
        
        self.numReadMore = 4
        
        performSegue(withIdentifier: "ReadMoreIndex", sender: nil)
    }
    
    @IBAction func fiveReadMore(_ sender: Any) {
        
        
        self.numReadMore = 5
        
        performSegue(withIdentifier: "ReadMoreIndex", sender: nil)
    }
    
    
    
    
    let indicator = UIActivityIndicatorView()
    
    func showIndicator() {
        
        indicator.activityIndicatorViewStyle = .whiteLarge
        
        indicator.center = self.view.center
        
        indicator.color = UIColor.rgb(r: 31, g: 158, b: 187, alpha: 1)
        
        indicator.hidesWhenStopped = true
        
        self.view.addSubview(indicator)
        
        self.view.bringSubview(toFront: indicator)
        
        indicator.startAnimating()
        
        
        
        
    }
    
    
    
    
    
    
   
}

        

extension UIColor {
    class func rgb(r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}


extension Array
{
    mutating func shuffle()
    {
        for _ in 0..<10
        {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
