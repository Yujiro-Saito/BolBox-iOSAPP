//
//  FriendsListsViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/02.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import AlamofireImage



class FriendsListsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var followUsers = [Post]()
    var detailName: String?
    var detailImageURL: String?
    var detailUID: String?
    var followUserNameBox = [String]()
    var followUserImageURL = [String]()
    var followUID = [String]()
    @IBOutlet weak var friendsTable: UITableView!
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        followUserNameBox = []
        followUserImageURL = []
    }

    //データ受け継ぎ用
    
    var userID: String!
    var isFollowing = Bool()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        friendsTable.delegate = self
        friendsTable.dataSource = self
        
        print(userID)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.hidesBarsOnSwipe = true
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        if isFollowing == false {
            //フォローワーの場合
            DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: self.userID).observe(.value, with: { (snapshot) in
                
                
                //ユーザーのデータ取得
                let currentUserID = FIRAuth.auth()?.currentUser?.uid
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                            if postDict["followers"] as? Dictionary<String, AnyObject?> != nil {
                                
                                let followingDictionary = postDict["followers"] as? Dictionary<String, AnyObject?>
                                
                                
                                for (followKey,followValue) in followingDictionary! {
                                    
                                    print("キーは\(followKey)、値は\(String(describing: followValue))")
                                    
                                    //Dataquery
                                    //if followkey == uid { usernameとimageURLを配列に追加
                                    
                                    DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: followKey).observe(.value, with: { (snapshot) in
                                        
                                        //uidと一致するユーザーの取り出し
                                        
                                        if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                            
                                            for snap in snapshot {
                                                
                                                if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                                    
                                                    let userName = postDict["userName"] as? String
                                                    let imageURL = postDict["userImageURL"] as? String
                                                    let uid = postDict["uid"] as? String
                                                    self.followUserNameBox.append(userName!)
                                                    self.followUserImageURL.append(imageURL!)
                                                    self.followUID.append(uid!)
                                                    
                                                }
                                            }
                                        }
                                        
                                        
                                        
                                        self.followUserNameBox.reverse()
                                        self.followUserImageURL.reverse()
                                        self.followUID.reverse()
                                        self.friendsTable.reloadData()
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                    })
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                }
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                
                
            })
            
        } else if isFollowing == true {
            //フォロー中表示
            
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
                                    
                                    //followkeyはフォロー中のUID
                                    
                                    DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: followKey).observe(.value, with: { (snapshot) in
                                        
                                        //uidと一致するユーザーの取り出し
                                        
                                        if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                            
                                            for snap in snapshot {
                                                
                                                if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                                    
                                                    let userName = postDict["userName"] as? String
                                                    let imageURL = postDict["userImageURL"] as? String
                                                    let uid = postDict["uid"] as? String
                                                    
                                                    
                                                    self.followUserNameBox.append(userName!)
                                                    self.followUserImageURL.append(imageURL!)
                                                    self.followUID.append(uid!)
                                                    
                                                }
                                            }
                                        }
                                        
                                        
                                        
                                        self.followUserNameBox.reverse()
                                        self.followUserImageURL.reverse()
                                        self.followUID.reverse()
                                        self.friendsTable.reloadData()
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                    })
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                }
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                
                
            })

            
            
            
        }
        
        
       

    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followUserNameBox.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = friendsTable.dequeueReusableCell(withIdentifier: "userCellItem", for: indexPath) as? FriendsTableViewCell
        
        
        cell?.userImage.image = nil
        cell?.clipsToBounds = true
        cell?.userName.text = ""
        
        let userName = followUserNameBox[indexPath.row]
        let imageURL = followUserImageURL[indexPath.row]
        
        cell?.userName.text = followUserNameBox[indexPath.row]
        
        //画像の読み込み
        if self.followUserImageURL[indexPath.row] != nil {
            cell?.userImage.af_setImage(withURL:  URL(string: followUserImageURL[indexPath.row])!)
        }
        

        return cell!
        
        
    }
    
    var uName = String()
    var UImageURL = String()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        detailUID = self.followUID[indexPath.row]
        uName = self.followUserNameBox[indexPath.row]
        UImageURL = self.followUserImageURL[indexPath.row]
        
        performSegue(withIdentifier: "Boke", sender: nil)
        
                      
    }
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Boke" {
            
            let userVC = (segue.destination as? UserViewController)!
            
            
            let currentUid = FIRAuth.auth()?.currentUser?.uid
            
            userVC.userName = self.uName
            userVC.userImageURL = self.UImageURL
            userVC.visitorUID = currentUid
            userVC.isFollow = self.isFollowing
            userVC.userID = detailUID
            
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
  

}
