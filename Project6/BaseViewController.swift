//
//  BaseViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/27.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase

class BaseViewController: UIViewController,UINavigationBarDelegate,UICollectionViewDelegate, UICollectionViewDataSource {
    
    //Outlet
    @IBOutlet weak var baseNavBar: UINavigationBar!
    @IBOutlet weak var topCollectionTable: UICollectionView!
    @IBOutlet weak var firstCollection: UICollectionView!
    
    
    //プロパティ
    var displayUserName: String?
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var initialURL = URL(string: "")
    
    
    //コレクションビュー用の配列
    var topPosts = [Post]()
    var firstPosts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DELEGATE
        baseNavBar.delegate = self
        topCollectionTable.delegate = self
        topCollectionTable.dataSource = self
        firstCollection.delegate = self
        firstCollection.dataSource = self
        
        //バーの高さ
        self.baseNavBar.frame = CGRect(x: 0,y: 0, width: UIScreen.main.bounds.size.width, height: 60)
        
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
        DataService.dataBase.REF_FIRST.observe(.value, with: { (snapshot) in
            
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
        
        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //ログインしているか確認
        if UserDefaults.standard.object(forKey: "AutoLogin") != nil {
            
            print("自動ログイン")
            
        } else {
            //ログインしていなければ登録画面に戻る
            self.performSegue(withIdentifier: "backtoRegister", sender: nil)
        }
        
        
        if UserDefaults.standard.object(forKey: "GoogleRegister") != nil {
            
            
            
            let alertViewControler = UIAlertController(title: "Welcome!", message: "ありがとうございます", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertViewControler.addAction(okAction)
            self.present(alertViewControler, animated: true, completion: nil)
            
            
            let userDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: "GoogleRegister")
            
            
        }
        
        
        
        
        if UserDefaults.standard.object(forKey: "EmailRegister") != nil {
            
            
            let alertViewControler = UIAlertController(title: "登録を完了しました", message: "ありがとうございます!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertViewControler.addAction(okAction)
            self.present(alertViewControler, animated: true, completion: nil)
            
            
            let userDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: "EmailRegister")
            
            //ユーザー登録時のユーザーネーム、アドレスの登録
            let user = FIRAuth.auth()?.currentUser
            
            if let user = user {
                let changeRequest = user.profileChangeRequest()
                
                changeRequest.displayName = "ゲスト"
                changeRequest.photoURL = self.initialURL
                
                changeRequest.commitChanges { error in
                    if let error = error {
                        // An error happened.
                        print(error.localizedDescription)
                    } else {
                        print("プロフィールの登録完了")
                        print(user.displayName!)
                        print(user.email!)
                    }
                }
            }
            
        }
        
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == topCollectionTable {
            //Top記事のセル
            let topCell = topCollectionTable.dequeueReusableCell(withReuseIdentifier: "topCell", for: indexPath) as? newCollectionViewCell
            
            
            let post = topPosts[indexPath.row]
            
            
            if let img = BaseViewController.imageCache.object(forKey: post.imageURL as NSString) {
                topCell?.configureCell(post: post, img: img)
            } else {
                topCell?.configureCell(post: post)
            }
            
            return topCell!
            
        } else if collectionView == firstCollection {
            //一番目の記事のセル
            
            
            let firstCell = firstCollection.dequeueReusableCell(withReuseIdentifier: "firstCell", for: indexPath) as? FirstCollectionViewCell
            
            let post = firstPosts[indexPath.row]
            
            
            if let img = BaseViewController.imageCache.object(forKey: post.imageURL as NSString) {
                firstCell?.configureCell(post: post, img: img)
            } else {
                firstCell?.configureCell(post: post)
            }
            
            return firstCell!
            
            
            
            
        }
        
        
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == topCollectionTable {
            return topPosts.count
        } else if collectionView == firstCollection {
            return firstPosts.count
        }
        
        return 1
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   
}

