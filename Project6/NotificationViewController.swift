//
//  NotificationViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/09.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

class NotificationViewController: UIViewController ,UINavigationBarDelegate,UITableViewDelegate,UITableViewDataSource{
    
    
    
    @IBOutlet weak var notificationTable: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var guestUserView: UIView!
    @IBOutlet weak var tabItem: UITabBarItem!
    
    
    
    
    var firstUserNameBox = [String]()
    var userImageURLBox = [String]()
    var userPostTitleBox = [String]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.delegate = self
        notificationTable.delegate = self
        notificationTable.dataSource = self
        
        
        self.tabItem.badgeColor = UIColor.red
        
        
        //バーの高さ
        self.navBar.frame = CGRect(x: 0,y: 0, width: UIScreen.main.bounds.size.width, height: 60)
        
        self.view.bringSubview(toFront: navBar)
        
        self.notificationTable.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        self.notificationTable.refreshControl = UIRefreshControl()
        self.notificationTable.refreshControl?.addTarget(self, action: #selector(NotificationViewController.refresh), for: .valueChanged)
        
        
        
        
        

    }
    
    let currentUserCheck = FIRAuth.auth()?.currentUser
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        self.guestUserView.isHidden = true
        
        let currentCounts = self.firstUserNameBox.count
        
        
        
        
        //ユーザーデータの読み込みと通知設定
        
        let anonymousUser = currentUserCheck!.isAnonymous
        
        if anonymousUser == true {
            //ゲストユーザー
            
            self.guestUserView.isHidden = false
            
            
            
            
        } else if anonymousUser == false {
            //ログインユーザーの場合
            //ユーザの投稿を取得
            DataService.dataBase.REF_BASE.child("posts").queryOrdered(byChild: "userID").queryEqual(toValue: FIRAuth.auth()?.currentUser?.uid).observe(.value, with: { (snapshot) in
                
                self.firstUserNameBox = []
                print(snapshot.value)
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    //繰り返し
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                            //投稿にいいねをつけている人がいる場合
                            if let peopleWhoLike = postDict["peopleWhoLike"] as? Dictionary<String, AnyObject> {
                                
                                print(peopleWhoLike)
                                
                                
                                
                                for (nameKey,namevalue) in peopleWhoLike {
                                    print("キーは\(nameKey)、値は\(namevalue)")
                                    
                                    
                                    print("ユーザー画像URLの取得\(namevalue)")
                                    
                                    
                                    
                                    let userImageURL = namevalue["imageURL"] as! String
                                    
                                    let userPostTitle = namevalue["postName"] as! String
                                    
                                    
                                    self.firstUserNameBox.append(nameKey)
                                    self.userImageURLBox.append(userImageURL)
                                    self.userPostTitleBox.append(userPostTitle)
                                    
                                    
                                    self.firstUserNameBox.reverse()
                                    self.userImageURLBox.reverse()
                                    self.userPostTitleBox.reverse()
                                    
                                    self.notificationTable.reloadData()
                                    
                                    print(self.firstUserNameBox)
                                    print(self.userImageURLBox)
                                    
                                    
                                    
                                }
                                
                                
                                
                                
                                
                                
                                
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                }
                
                
                
                
                
                
                
                
                
                
                
                
            })
            
            //通知設定
            
            ////初回時通知数を登録
            
            if UserDefaults.standard.object(forKey: "previousCounts") == nil  {
                
                print("初回いいね数を登録しました")
                UserDefaults.standard.set(self.firstUserNameBox.count, forKey: "previousCounts")
                
                
                
            }
            
            
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firstUserNameBox.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let notiCell = notificationTable.dequeueReusableCell(withIdentifier: "notification", for: indexPath) as? NotificationTableViewCell
        
        let currentCounts = self.firstUserNameBox.count
        
        notiCell?.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
        notiCell?.layer.borderWidth = 10
        notiCell?.clipsToBounds = true
        
        if firstUserNameBox.count >= 1 {
            
            
            if UserDefaults.standard.object(forKey: "previousCounts") != nil {
                
                print("通知数の検証をします")
                //前回数値を取得
                let previousNum = UserDefaults.standard.integer(forKey: "previousCounts")
                print(previousNum)
                print(currentCounts)
                
                //今回と比較 大きければ、バッジに表示とpreviousの更新
                if currentCounts > previousNum {
                    print("最終")
                    let currentNum = currentCounts - previousNum
                    print(currentNum)
                    self.tabItem.badgeValue = String(currentNum)
                    
                    let userDefaults = UserDefaults.standard
                    
                    userDefaults.removeObject(forKey: "previousCounts")
                    
                    UserDefaults.standard.set(self.firstUserNameBox.count, forKey: "previousCounts")
                    print("通知数が更新されました")
                    
                    
                }
                
                
                
                
            }
            
            
            
            
            
            
            
            
            notiCell?.userName.text = firstUserNameBox[indexPath.row]
            notiCell?.userImage.af_setImage(withURL: URL(string: userImageURLBox[indexPath.row])!)
            notiCell?.title.text = userPostTitleBox[indexPath.row]
        }
        
        
        
        
        
       
 
        
        return notiCell!
        
        
       
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func refresh() {
        
        
        //ユーザの投稿を取得
        DataService.dataBase.REF_BASE.child("posts").queryOrdered(byChild: "userID").queryEqual(toValue: FIRAuth.auth()?.currentUser?.uid).observe(.value, with: { (snapshot) in
            
            self.firstUserNameBox = []
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                //繰り返し
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        
                        //投稿にいいねをつけている人がいる場合
                        if let peopleWhoLike = postDict["peopleWhoLike"] as? Dictionary<String, AnyObject> {
                            
                            print(peopleWhoLike)
                            
                            
                            
                            for (nameKey,namevalue) in peopleWhoLike {
                                print("キーは\(nameKey)、値は\(namevalue)")
                                
                                
                                print("ユーザー画像URLの取得\(namevalue)")
                                
                                
                                
                                let userImageURL = namevalue["imageURL"] as! String
                                
                                let userPostTitle = namevalue["postName"] as! String
                                
                                
                                self.firstUserNameBox.append(nameKey)
                                self.userImageURLBox.append(userImageURL)
                                self.userPostTitleBox.append(userPostTitle)
                                
                                
                                self.firstUserNameBox.reverse()
                                self.userImageURLBox.reverse()
                                self.userPostTitleBox.reverse()
                                
                                self.notificationTable.reloadData()
                                
                                print(self.firstUserNameBox)
                                print(self.userImageURLBox)
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                }
                
                
            }
            
            
            
            
            
            
            
            
            
            
            
            
        })
        
        self.notificationTable.refreshControl?.endRefreshing()
        

    
}

}

