//
//  FeatureViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/20.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase


class FeatureViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate {
    
    @IBOutlet weak var featureTable: UITableView!
    @IBOutlet weak var featureNavbar: UINavigationBar!
    
    
    
    //データ引き継ぎ用
    var selectedNum: Int!
    var readMoreNum = 0
    var readCount = Int()
    
    
    //データ管理用
    var featureOnePosts = [Post]()
    var featureTwoPosts = [Post]()
    var featureThreePosts = [Post]()
    var readMorePosts = [Post]()
    
    var separateID = String()
    
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        print(readMoreNum)
        
        
        if readMoreNum == 1 {
            //データOne読み込み
            
            //メディアのデータ読み込み
            DataService.dataBase.REF_FIRST.observe(.value, with: { (snapshot) in
                
                self.readMorePosts = []
                
                print(snapshot.value)
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                                let key = snap.key
                                let post = Post(postKey: key, postData: postDict)
                            
                            /*
                            let postIdentification = postDict["postID"] as! String
                            self.separateID = postIdentification
                            
                            print(postDict["readCount"] as! Int)
                            let readNum = postDict["readCount"] as! Int
                            self.readCount = readNum
                            */
                            
                            
                                self.readMorePosts.append(post)
                                
                                
                            
                        }
                    }
                    
                    
                }
                
                
                self.readMorePosts.reverse()
                self.featureTable.reloadData()
                
            })
            
        } else if readMoreNum == 2 {
            
            
            //データOne読み込み
            
            //メディアのデータ読み込み
            DataService.dataBase.REF_SECOND.observe(.value, with: { (snapshot) in
                
                self.readMorePosts = []
                
                print(snapshot.value)
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.readMorePosts.append(post)
                            
                            
                            
                        }
                    }
                    
                    
                }
                
                
                self.readMorePosts.reverse()
                self.featureTable.reloadData()
                
            })
            
            
            
            
            
        } else if readMoreNum == 3 {
            
            DataService.dataBase.REF_THIRD.observe(.value, with: { (snapshot) in
                
                self.readMorePosts = []
                
                print(snapshot.value)
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.readMorePosts.append(post)
                            
                            
                            
                        }
                    }
                    
                    
                }
                
                
                self.readMorePosts.reverse()
                self.featureTable.reloadData()
                
            })

            
            
            
            
            
            
            
        } else if readMoreNum == 4 {
            
            DataService.dataBase.REF_FOURTH.observe(.value, with: { (snapshot) in
                
                self.readMorePosts = []
                
                print(snapshot.value)
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.readMorePosts.append(post)
                            
                            
                            
                        }
                    }
                    
                    
                }
                
                
                self.readMorePosts.reverse()
                self.featureTable.reloadData()
                
            })
            
            
            
            
            
        } else if readMoreNum == 5 {
            
            
            DataService.dataBase.REF_FIFTH.observe(.value, with: { (snapshot) in
                
                self.readMorePosts = []
                
                print(snapshot.value)
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.readMorePosts.append(post)
                            
                            
                            
                        }
                    }
                    
                    
                }
                
                
                self.readMorePosts.reverse()
                self.featureTable.reloadData()
                
            })
            
            
            
            
            
            
            
        }
        
        
        else if selectedNum == 0 {
            //特集一つ目の記事を読み込み
            
            DataService.dataBase.REF_FEATUREONE.observe(.value, with: { (snapshot) in
                
                self.featureOnePosts = []
                
                print(snapshot.value)
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                                let key = snap.key
                                let post = Post(postKey: key, postData: postDict)
                                
                                self.featureOnePosts.append(post)
                                self.featureTable.reloadData()
                                
                           
                            
                        }
                    }
                    
                    
                }
                
                
                
                self.featureTable.reloadData()
                
            })
            
            
        } else if selectedNum == 1 {
            //二つ目の記事を読み込み
            
            DataService.dataBase.REF_FEATURETWO.observe(.value, with: { (snapshot) in
                
                self.featureTwoPosts = []
                
                print(snapshot.value)
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.featureTwoPosts.append(post)
                            self.featureTable.reloadData()
                            
                            
                            
                        }
                    }
                    
                    
                }
                
                
                
                self.featureTable.reloadData()
                
            })

            
            
            
            
            
            
        } else if selectedNum == 2 {
            //三つ目の記事を読み込み
            
            DataService.dataBase.REF_FEATURETHREE.observe(.value, with: { (snapshot) in
                
                self.featureThreePosts = []
                
                print(snapshot.value)
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.featureThreePosts.append(post)
                            self.featureTable.reloadData()
                            
                            
                            
                        }
                    }
                    
                    
                }
                
                
                
                self.featureTable.reloadData()
                
            })
            
            
            
            
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        featureTable.delegate = self
        featureTable.dataSource = self
        
        featureNavbar.delegate = self
        
        //バーの高さ
        self.featureNavbar.frame = CGRect(x: 0,y: 0, width: UIScreen.main.bounds.size.width, height: 60)
        
        self.featureTable.refreshControl = UIRefreshControl()
        self.featureTable.refreshControl?.addTarget(self, action: #selector(FeatureViewController.refresh), for: .valueChanged)
        
        
    }
    
    func refresh() {
        
        
        
        self.featureTable.refreshControl?.endRefreshing()
        
        
    }
    
    
    var detailPosts: Post?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "DetailsWin" {
            
            let detailVc = (segue.destination as? InDetailViewController)!
            
            detailVc.name = detailPosts?.name
            detailVc.numLikes = (detailPosts?.pvCount)!
            detailVc.whatContent = detailPosts?.whatContent
            detailVc.imageURL = detailPosts?.imageURL
            detailVc.linkURL = detailPosts?.linkURL
        }
        
        
        
        
        
    }
    
    //
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.readMoreNum == 1 {
            
            detailPosts = self.readMorePosts[indexPath.row]
            
            //IDの設定、pv数
            self.separateID = self.readMorePosts[indexPath.row].postID
            self.readCount = self.readMorePosts[indexPath.row].readCount

            
            print("ああああああああああああああああ")
            print(self.separateID)
            print(self.readCount)
            
            self.readCount += 1
            
            let readAmount = ["readCount": self.readCount]
            DataService.dataBase.REF_BASE.child("first/\(separateID)").updateChildValues(readAmount)
            
            
            performSegue(withIdentifier: "DetailsWin", sender: nil)
            
            
            
        } else if self.readMoreNum == 2 {
            
            
            detailPosts = self.readMorePosts[indexPath.row]
            performSegue(withIdentifier: "DetailsWin", sender: nil)
            
            
        } else if self.readMoreNum == 3 {
            
            detailPosts = self.readMorePosts[indexPath.row]
            performSegue(withIdentifier: "DetailsWin", sender: nil)
            
        } else if self.readMoreNum == 4 {
            
            detailPosts = self.readMorePosts[indexPath.row]
            performSegue(withIdentifier: "DetailsWin", sender: nil)
            
        } else if self.readMoreNum == 5 {
            
            detailPosts = self.readMorePosts[indexPath.row]
            performSegue(withIdentifier: "DetailsWin", sender: nil)
            
        }
            
            
            
        else if self.selectedNum == 0 {
            detailPosts = self.featureOnePosts[indexPath.row]
            performSegue(withIdentifier: "DetailsWin", sender: nil)
        } else if self.selectedNum == 1 {
            detailPosts = self.featureTwoPosts[indexPath.row]
            performSegue(withIdentifier: "DetailsWin", sender: nil)
        } else if self.selectedNum == 2 {
            detailPosts = self.featureThreePosts[indexPath.row]
            performSegue(withIdentifier: "DetailsWin", sender: nil)
        }
        
        
        
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        
        
        
        if readMoreNum == 1 {
            
            
            //PostID-PV数用
            //let postIdentification = self.readMorePosts[indexPath.row].postID
            //self.separateID = postIdentification
            
            //PostID-PV数用
            //let readNum = self.readMorePosts[indexPath.row].readCount
            //self.readCount = readNum
            
            
            
            let currentUserName = FIRAuth.auth()?.currentUser?.displayName
            
            
            let readMoreCell = featureTable.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as? FeatureTableViewCell
            
            
            
            readMoreCell?.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
            readMoreCell?.layer.borderWidth = 10
            readMoreCell?.clipsToBounds = true
            
            
            readMoreCell?.cellType = 1
            
            readMoreCell?.linkURL = self.readMorePosts[indexPath.row].linkURL
            readMoreCell?.imageURL = self.readMorePosts[indexPath.row].imageURL
            readMoreCell?.pvCount = self.readMorePosts[indexPath.row].pvCount
            readMoreCell?.postID = self.readMorePosts[indexPath.row].postID
            
            let post = readMorePosts[indexPath.row]
            
            //
            readMoreCell?.featureImage.af_setImage(withURL: URL(string: readMorePosts[indexPath.row].imageURL)!)
            
            
            
            if let img = FeatureViewController.imageCache.object(forKey: post.imageURL as! NSString) {
                
                
                
                readMoreCell?.configureCell(post: post, img: img)
                
            }
            else {
                
                readMoreCell?.configureCell(post: post)
                
            }
            
            
            
            
            
            
            
            if self.readMorePosts[indexPath.row].peopleWhoLike != nil {
                readMoreCell?.peopleWhoLike = self.readMorePosts[indexPath.row].peopleWhoLike as Dictionary<String, AnyObject>
            }
            
            
            
            
            print(readMorePosts[indexPath.row].peopleWhoLike)
            
            let likingDictionary = readMorePosts[indexPath.row].peopleWhoLike
            
            for (nameKey,namevalue) in likingDictionary {
                
                print("キーは\(nameKey)、値は\(namevalue)")
                
                
                if nameKey == currentUserName {
                    
                    
                    readMoreCell?.likesButton.isHidden = true
                    readMoreCell?.likesButton.isEnabled = false
                    
                    readMoreCell?.unLikeButton.isHidden = false
                    readMoreCell?.unLikeButton.isEnabled = true
                    
                    
                    
                    
                }
                
                
            }
            
            
            
            
            return readMoreCell!
            
            
            
        } else if readMoreNum == 2 {
            
            
            let currentUserName = FIRAuth.auth()?.currentUser?.displayName
            
            
            let readMoreCell = featureTable.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as? FeatureTableViewCell
            
            
            
            readMoreCell?.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
            readMoreCell?.layer.borderWidth = 10
            readMoreCell?.clipsToBounds = true
            
            
            
            
            readMoreCell?.linkURL = self.readMorePosts[indexPath.row].linkURL
            readMoreCell?.imageURL = self.readMorePosts[indexPath.row].imageURL
            readMoreCell?.pvCount = self.readMorePosts[indexPath.row].pvCount
            readMoreCell?.postID = self.readMorePosts[indexPath.row].postID
            
            let post = readMorePosts[indexPath.row]
            
            //
            readMoreCell?.featureImage.af_setImage(withURL: URL(string: readMorePosts[indexPath.row].imageURL)!)
            
            
            
            if let img = FeatureViewController.imageCache.object(forKey: post.imageURL as! NSString) {
                
                
                
                readMoreCell?.configureCell(post: post, img: img)
                
            }
            else {
                
                readMoreCell?.configureCell(post: post)
                
            }
            
            
            
            
            if self.readMorePosts[indexPath.row].peopleWhoLike != nil {
                readMoreCell?.peopleWhoLike = self.readMorePosts[indexPath.row].peopleWhoLike as Dictionary<String, AnyObject>
            }
            
            
            
            
            print(readMorePosts[indexPath.row].peopleWhoLike)
            
            let likingDictionary = readMorePosts[indexPath.row].peopleWhoLike
            
            for (nameKey,namevalue) in likingDictionary {
                
                print("キーは\(nameKey)、値は\(namevalue)")
                
                
                if nameKey == currentUserName {
                    
                    
                    readMoreCell?.likesButton.isHidden = true
                    readMoreCell?.likesButton.isEnabled = false
                    
                    readMoreCell?.unLikeButton.isHidden = false
                    readMoreCell?.unLikeButton.isEnabled = true
                    
                    
                    
                    
                    
                }
                
                
            }
            
            
            
            return readMoreCell!
            
            
        } else if readMoreNum == 3 {
            
            let currentUserName = FIRAuth.auth()?.currentUser?.displayName
            
            
            let readMoreCell = featureTable.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as? FeatureTableViewCell
            
            
            
            readMoreCell?.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
            readMoreCell?.layer.borderWidth = 10
            readMoreCell?.clipsToBounds = true
            
            
            
            
            readMoreCell?.linkURL = self.readMorePosts[indexPath.row].linkURL
            readMoreCell?.imageURL = self.readMorePosts[indexPath.row].imageURL
            readMoreCell?.pvCount = self.readMorePosts[indexPath.row].pvCount
            readMoreCell?.postID = self.readMorePosts[indexPath.row].postID
            
            let post = readMorePosts[indexPath.row]
            
            //
            readMoreCell?.featureImage.af_setImage(withURL: URL(string: readMorePosts[indexPath.row].imageURL)!)
            
            
            
            if let img = FeatureViewController.imageCache.object(forKey: post.imageURL as! NSString) {
                
                
                
                readMoreCell?.configureCell(post: post, img: img)
                
            }
            else {
                
                readMoreCell?.configureCell(post: post)
                
            }
            
            if self.readMorePosts[indexPath.row].peopleWhoLike != nil {
                readMoreCell?.peopleWhoLike = self.readMorePosts[indexPath.row].peopleWhoLike as Dictionary<String, AnyObject>
            }
            
            
            
            
            print(readMorePosts[indexPath.row].peopleWhoLike)
            
            let likingDictionary = readMorePosts[indexPath.row].peopleWhoLike
            
            for (nameKey,namevalue) in likingDictionary {
                
                print("キーは\(nameKey)、値は\(namevalue)")
                
                
                if nameKey == currentUserName {
                    
                    
                    readMoreCell?.likesButton.isHidden = true
                    readMoreCell?.likesButton.isEnabled = false
                    
                    readMoreCell?.unLikeButton.isHidden = false
                    readMoreCell?.unLikeButton.isEnabled = true
                    
                    
                    
                    
                }
                
                
            }
            
            
            return readMoreCell!
            
        } else if readMoreNum == 4 {
            
            
            let currentUserName = FIRAuth.auth()?.currentUser?.displayName
            
            
            let readMoreCell = featureTable.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as? FeatureTableViewCell
            
            
            
            readMoreCell?.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
            readMoreCell?.layer.borderWidth = 10
            readMoreCell?.clipsToBounds = true
            
            
            
            
            readMoreCell?.linkURL = self.readMorePosts[indexPath.row].linkURL
            readMoreCell?.imageURL = self.readMorePosts[indexPath.row].imageURL
            readMoreCell?.pvCount = self.readMorePosts[indexPath.row].pvCount
            readMoreCell?.postID = self.readMorePosts[indexPath.row].postID
            
            let post = readMorePosts[indexPath.row]
            
            //
            readMoreCell?.featureImage.af_setImage(withURL: URL(string: readMorePosts[indexPath.row].imageURL)!)
            
            
            
            if let img = FeatureViewController.imageCache.object(forKey: post.imageURL as! NSString) {
                
                
                
                readMoreCell?.configureCell(post: post, img: img)
                
            }
            else {
                
                readMoreCell?.configureCell(post: post)
                
            }
            
            
            if self.readMorePosts[indexPath.row].peopleWhoLike != nil {
                readMoreCell?.peopleWhoLike = self.readMorePosts[indexPath.row].peopleWhoLike as Dictionary<String, AnyObject>
            }
            
            
            
            
            print(readMorePosts[indexPath.row].peopleWhoLike)
            
            let likingDictionary = readMorePosts[indexPath.row].peopleWhoLike
            
            for (nameKey,namevalue) in likingDictionary {
                
                print("キーは\(nameKey)、値は\(namevalue)")
                
                
                if nameKey == currentUserName {
                    
                    
                    readMoreCell?.likesButton.isHidden = true
                    readMoreCell?.likesButton.isEnabled = false
                    
                    readMoreCell?.unLikeButton.isHidden = false
                    readMoreCell?.unLikeButton.isEnabled = true
                    
                    
                    
                    
                }
                
                
            }
            
            return readMoreCell!
            
        } else if readMoreNum == 5 {
            
            let currentUserName = FIRAuth.auth()?.currentUser?.displayName
            
            
            let readMoreCell = featureTable.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as? FeatureTableViewCell
            
            
            
            readMoreCell?.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
            readMoreCell?.layer.borderWidth = 10
            readMoreCell?.clipsToBounds = true
            
            
            
            
            readMoreCell?.linkURL = self.readMorePosts[indexPath.row].linkURL
            readMoreCell?.imageURL = self.readMorePosts[indexPath.row].imageURL
            readMoreCell?.pvCount = self.readMorePosts[indexPath.row].pvCount
            readMoreCell?.postID = self.readMorePosts[indexPath.row].postID
            
            let post = readMorePosts[indexPath.row]
            
            //
            readMoreCell?.featureImage.af_setImage(withURL: URL(string: readMorePosts[indexPath.row].imageURL)!)
            
            
            
            if let img = FeatureViewController.imageCache.object(forKey: post.imageURL as! NSString) {
                
                
                
                readMoreCell?.configureCell(post: post, img: img)
                
            }
            else {
                
                readMoreCell?.configureCell(post: post)
                
            }
            
            if self.readMorePosts[indexPath.row].peopleWhoLike != nil {
                readMoreCell?.peopleWhoLike = self.readMorePosts[indexPath.row].peopleWhoLike as Dictionary<String, AnyObject>
            }
            
            
            
            
            print(readMorePosts[indexPath.row].peopleWhoLike)
            
            let likingDictionary = readMorePosts[indexPath.row].peopleWhoLike
            
            for (nameKey,namevalue) in likingDictionary {
                
                print("キーは\(nameKey)、値は\(namevalue)")
                
                
                if nameKey == currentUserName {
                    
                    
                    readMoreCell?.likesButton.isHidden = true
                    readMoreCell?.likesButton.isEnabled = false
                    
                    readMoreCell?.unLikeButton.isHidden = false
                    readMoreCell?.unLikeButton.isEnabled = true
                    
                    
                    
                    
                }
                
                
            }
            
            
            return readMoreCell!
            
        }
        
        
        
        
        if selectedNum == 0 {
            
            let currentUserName = FIRAuth.auth()?.currentUser?.displayName
            
            
            let featureOneCell = featureTable.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as? FeatureTableViewCell
            
            
            
            featureOneCell?.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
            featureOneCell?.layer.borderWidth = 10
            featureOneCell?.clipsToBounds = true
            
            
            
            
           featureOneCell?.linkURL = self.featureOnePosts[indexPath.row].linkURL
           featureOneCell?.imageURL = self.featureOnePosts[indexPath.row].imageURL
            featureOneCell?.pvCount = self.featureOnePosts[indexPath.row].pvCount
            featureOneCell?.postID = "featureOneOne"
            
            let post = featureOnePosts[indexPath.row]
            
            //
            featureOneCell?.featureImage.af_setImage(withURL: URL(string: featureOnePosts[indexPath.row].imageURL)!)
            
            
            
            if let img = FeatureViewController.imageCache.object(forKey: post.imageURL as! NSString) {
                
                
                
                featureOneCell?.configureCell(post: post, img: img)
                
            }
            else {
                
                featureOneCell?.configureCell(post: post)
                
            }
            
            
            if self.featureOnePosts[indexPath.row].peopleWhoLike != nil {
                featureOneCell?.peopleWhoLike = self.featureOnePosts[indexPath.row].peopleWhoLike as Dictionary<String, AnyObject>
            }
            
            
            
            
            
            let likingDictionary = featureOnePosts[indexPath.row].peopleWhoLike
            
            for (nameKey,namevalue) in likingDictionary {
                
                print("キーは\(nameKey)、値は\(namevalue)")
                
                
                if nameKey == currentUserName {
                    
                    
                    featureOneCell?.likesButton.isHidden = true
                    featureOneCell?.likesButton.isEnabled = false
                    
                    featureOneCell?.unLikeButton.isHidden = false
                    featureOneCell?.unLikeButton.isEnabled = true
                    
                    
                    
                    
                }
                
                
            }
            
            
            
            return featureOneCell!
            
            
            
            
            
            
        }
        
        
        else if selectedNum == 1 {
            
            
            let currentUserName = FIRAuth.auth()?.currentUser?.displayName
            
            
            let featureTwoeCell = featureTable.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as? FeatureTableViewCell
            
            
            
            featureTwoeCell?.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
            featureTwoeCell?.layer.borderWidth = 10
            featureTwoeCell?.clipsToBounds = true
            
            
            
            
            featureTwoeCell?.linkURL = self.featureTwoPosts[indexPath.row].linkURL
            featureTwoeCell?.imageURL = self.featureTwoPosts[indexPath.row].imageURL
            featureTwoeCell?.pvCount = self.featureTwoPosts[indexPath.row].pvCount
            featureTwoeCell?.postID = self.featureTwoPosts[indexPath.row].postID
            
            let post = featureTwoPosts[indexPath.row]
            
            //
            featureTwoeCell?.featureImage.af_setImage(withURL: URL(string: featureTwoPosts[indexPath.row].imageURL)!)
            
            
            
            if let img = FeatureViewController.imageCache.object(forKey: post.imageURL as! NSString) {
                
                
                
                featureTwoeCell?.configureCell(post: post, img: img)
                
            }
            else {
                
                featureTwoeCell?.configureCell(post: post)
                
            }
            
            
            
            if self.featureTwoPosts[indexPath.row].peopleWhoLike != nil {
                featureTwoeCell?.peopleWhoLike = self.featureTwoPosts[indexPath.row].peopleWhoLike as Dictionary<String, AnyObject>
            }
            
            
            
            
            print(featureTwoPosts[indexPath.row].peopleWhoLike)
            
            let likingDictionary = featureTwoPosts[indexPath.row].peopleWhoLike
            
            for (nameKey,namevalue) in likingDictionary {
                
                print("キーは\(nameKey)、値は\(namevalue)")
                
                
                if nameKey == currentUserName {
                    
                    
                    featureTwoeCell?.likesButton.isHidden = true
                    featureTwoeCell?.likesButton.isEnabled = false
                    
                    featureTwoeCell?.unLikeButton.isHidden = false
                    featureTwoeCell?.unLikeButton.isEnabled = true
                    
                    
                    
                    
                }
                
                
            }
            
            
            return featureTwoeCell!
            

            
            
            
         
            
            
            
            
            
        }
        
        
        else if self.selectedNum == 2 {
            
            
            let currentUserName = FIRAuth.auth()?.currentUser?.displayName
            
            
            let featureThreeCell = featureTable.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as? FeatureTableViewCell
            
            
            
            featureThreeCell?.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
            featureThreeCell?.layer.borderWidth = 10
            featureThreeCell?.clipsToBounds = true
            
            
            
            
            featureThreeCell?.linkURL = self.featureThreePosts[indexPath.row].linkURL
            featureThreeCell?.imageURL = self.featureThreePosts[indexPath.row].imageURL
            featureThreeCell?.pvCount = self.featureThreePosts[indexPath.row].pvCount
            featureThreeCell?.postID = self.featureThreePosts[indexPath.row].postID
            
            let post = featureThreePosts[indexPath.row]
            
            //
            featureThreeCell?.featureImage.af_setImage(withURL: URL(string: featureThreePosts[indexPath.row].imageURL)!)
            
            
            
            if let img = FeatureViewController.imageCache.object(forKey: post.imageURL as! NSString) {
                
                
                
                featureThreeCell?.configureCell(post: post, img: img)
                
            }
            else {
                
                featureThreeCell?.configureCell(post: post)
                
            }
            
            
            
            
            
            
            
            
            if self.featureThreePosts[indexPath.row].peopleWhoLike != nil {
                featureThreeCell?.peopleWhoLike = self.featureThreePosts[indexPath.row].peopleWhoLike as Dictionary<String, AnyObject>
            }
            
            
            
            
            print(featureThreePosts[indexPath.row].peopleWhoLike)
            
            let likingDictionary = featureThreePosts[indexPath.row].peopleWhoLike
            
            for (nameKey,namevalue) in likingDictionary {
                
                print("キーは\(nameKey)、値は\(namevalue)")
                
                
                if nameKey == currentUserName {
                    
                    
                    featureThreeCell?.likesButton.isHidden = true
                    featureThreeCell?.likesButton.isEnabled = false
                    
                    featureThreeCell?.unLikeButton.isHidden = false
                    featureThreeCell?.unLikeButton.isEnabled = true
                    
                    
                    
                    
                }
                
                
            }
            
            
            
            return featureThreeCell!

            
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if readMoreNum == 1 {
            return self.readMorePosts.count
        }
        
        else if readMoreNum == 2 {
            return self.readMorePosts.count
        }
            
        else if readMoreNum == 3 {
            return self.readMorePosts.count
        }
        
        else if readMoreNum == 4 {
            return self.readMorePosts.count
        }
            
        else if readMoreNum == 5 {
            return self.readMorePosts.count
        }
        
        else if selectedNum == 0 {
            
            return self.featureOnePosts.count
            
        } else if selectedNum == 1 {
            
           return self.featureTwoPosts.count
            
        } else if selectedNum == 2 {
         
            return self.featureThreePosts.count
            
        }
        
        
        
        return 0
        
        
        
        
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        
        
        self.dismiss(animated: true, completion: nil)
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

 

}
