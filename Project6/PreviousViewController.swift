//
//  PreviousViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/01.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase

class PreviousViewController: UIViewController,UINavigationBarDelegate/*, UITableViewDataSource, UITableViewDelegate*/  {
    
    
    //@IBOutlet weak var basedSegment: UISegmentedControl!
    @IBOutlet weak var baseNavBar: UINavigationBar!
    //@IBOutlet weak var baseTable: UITableView!
    
    
    var newPosts = [Post]()
    var popularPosts = [Post]()
    var displayUserName: String?
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var initialURL = URL(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        baseNavBar.delegate = self
        //baseTable.delegate = self
        //baseTable.dataSource = self
        
        
        
        
        /*FIRAuth.auth()!.signInAnonymously { (firUser, error) in
         if error == nil {
         print("Login")
         } else {
         print(error?.localizedDescription)
         }
         
         }
         */
        self.baseNavBar.frame = CGRect(x: 0,y: 0, width: UIScreen.main.bounds.size.width, height: 55)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        /*
         //新着投稿の取得
         let segmentNum = basedSegment.selectedSegmentIndex
         
         if segmentNum == 0 {
         DataService.dataBase.REF_POST.observe(.value, with: { (snapshot) in
         
         self.newPosts = []
         
         print(snapshot.value)
         
         if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
         
         for snap in snapshot {
         print("SNAP: \(snap)")
         
         if let postDict = snap.value as? Dictionary<String, AnyObject> {
         
         let key = snap.key
         let post = Post(postKey: key, postData: postDict)
         
         self.newPosts.append(post)
         self.baseTable.reloadData()
         }
         
         
         }
         
         
         }
         
         })
         
         baseTable.reloadData()
         
         } else if segmentNum == 1 {
         
         DataService.dataBase.REF_POST.queryOrdered(byChild: "pvCount").queryLimited(toLast: 15).observe(.value, with: { (snapshot) in
         
         self.popularPosts = []
         
         print(snapshot.value)
         
         if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
         
         for snap in snapshot {
         print("SNAP: \(snap)")
         
         if let postDict = snap.value as? Dictionary<String, AnyObject> {
         
         let key = snap.key
         let post = Post(postKey: key, postData: postDict)
         
         
         self.popularPosts.append(post)
         
         self.popularPosts.sort(by: {$0.pvCount > $1.pvCount})
         self.baseTable.reloadData()
         
         }
         }
         }
         
         })
         baseTable.reloadData()
         
         
         
         
         }
         
         */
    }
    
    
    
    
    
    
    //セグメントタップ
    /*@IBAction func baseSegmentDidTap(_ sender: Any) {
     
     let segmentNum = basedSegment.selectedSegmentIndex
     
     //新着の読み込み
     if segmentNum == 0 {
     
     do {
     
     DataService.dataBase.REF_POST.observe(.value, with: { (snapshot) in
     
     self.newPosts = []
     
     print(snapshot.value)
     
     if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
     
     for snap in snapshot {
     print("SNAP: \(snap)")
     
     if let postDict = snap.value as? Dictionary<String, AnyObject> {
     
     let key = snap.key
     let post = Post(postKey: key, postData: postDict)
     
     self.newPosts.append(post)
     self.baseTable.reloadData()
     
     
     }
     
     
     }
     
     
     }
     
     })
     baseTable.reloadData()
     
     
     
     
     
     } catch {
     print(error.localizedDescription)
     }
     
     
     //人気の読み込み
     } else if segmentNum == 1 {
     
     do {
     DataService.dataBase.REF_POST.queryOrdered(byChild: "pvCount").queryLimited(toLast: 15).observe(.value, with: { (snapshot) in
     
     self.popularPosts = []
     
     print(snapshot.value)
     
     if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
     
     for snap in snapshot {
     print("SNAP: \(snap)")
     
     if let postDict = snap.value as? Dictionary<String, AnyObject> {
     
     let key = snap.key
     let post = Post(postKey: key, postData: postDict)
     
     
     self.popularPosts.append(post)
     
     self.popularPosts.sort(by: {$0.pvCount > $1.pvCount})
     self.baseTable.reloadData()
     
     }
     }
     }
     
     })
     baseTable.reloadData()
     
     } catch {
     print(error.localizedDescription)
     }
     
     
     
     }
     
     
     }
     */
    //テーブルビュー関連
    /*
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     let segmentNum = basedSegment.selectedSegmentIndex
     
     if segmentNum == 0 {
     return newPosts.count
     } else if segmentNum == 1 {
     return popularPosts.count
     }
     
     return 5
     }
     
     func numberOfSections(in tableView: UITableView) -> Int {
     return 1
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
     let segmentNum = basedSegment.selectedSegmentIndex
     
     let cell = baseTable.dequeueReusableCell(withIdentifier: "baseCell", for: indexPath) as? BaseTableViewCell
     
     cell?.layer.borderColor = UIColor.clear.cgColor
     cell?.layer.borderWidth = 5
     cell?.clipsToBounds = true
     
     
     if segmentNum == 0 {
     //新着投稿
     let post = newPosts[indexPath.row]
     
     if let img = BaseViewController.imageCache.object(forKey: post.imageURL as NSString) {
     
     cell?.configureCell(post: post, img: img)
     } else {
     cell?.configureCell(post: post)
     }
     
     return cell!
     
     } else if segmentNum == 1 {
     //人気投稿
     let post = popularPosts[indexPath.row]
     
     if let img = BaseViewController.imageCache.object(forKey: post.imageURL as NSString) {
     
     cell?.configureCell(post: post, img: img)
     } else {
     cell?.configureCell(post: post)
     }
     
     self.popularPosts.sort(by: {$0.pvCount > $1.pvCount})
     return cell!
     
     
     }
     
     
     return cell!
     
     
     
     }
     
     
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 5
     }
     
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     let headerView = UIView()
     headerView.backgroundColor = UIColor.clear
     return headerView
     }
     
     
     @IBAction func dataDelete(_ sender: Any) {
     print("delete")
     
     }
     
     
     
     */
    
}
