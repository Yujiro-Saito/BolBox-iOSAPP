//
//  FeedViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/08/30.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import AlamofireImage



class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    var userID = String()
    var imagesURL = String()
    var userName = String()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        userName = userNameBox[indexPath.row]
        userID = userIDBox[indexPath.row]
        imagesURL = userProfileImageBox[indexPath.row]
        
        performSegue(withIdentifier: "UserHome", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserHome" {
            
            let userVC = (segue.destination as? UserViewController)!
            
            userVC.userName = userName
            userVC.userImageURL = imagesURL
            userVC.userID = userID
            print(imagesURL)
            
            
        }
    }
    
    
    
    var newPosts = [Post]()
    var detailPosts: Post?
    
    @IBOutlet weak var tableFeed: UITableView!
    @IBOutlet weak var searchTable: UITableView!
    
    var filteredNames = [String]()
    var filteredImages = [String]()
    
    
    //data
    
    var folderNameBox = [String]()
    var imageURLBox = [String]()
    var linkURLBox = [String]()
    var nameBox = [String]()
    //var postIDBox = [String]()
    var userIDBox = [String]()
    var userNameBox = [String]()
    var userProfileImageBox = [String]()
    //var pvCountBox = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableFeed.delegate = self
        tableFeed.dataSource = self
        searchTable.delegate = self
        searchTable.dataSource = self
        
        searchTable.isHidden = true
        
        
        self.navigationItem.title = "Port"
        
        // フォント種をTime New Roman、サイズを10に指定
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSFontAttributeName: UIFont(name: "Times New Roman", size: 18)!]
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        
        DataService.dataBase.REF_USER.observe(.value, with: { (snapshot) in
            
            self.filteredNames = []
            self.filteredImages = []
            
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let userName = postDict["userName"] as! String
                        let userImage = postDict["userImageURL"] as! String
                        
                        self.filteredNames.append(userName)
                        self.filteredImages.append(userImage)
                        
                        
                        
                    }
                }
                
                
            }
            
            print(self.filteredNames)
            self.filteredNames.reverse()
            self.filteredImages.reverse()
            
        })
        
 
        
    }
    
   
    
    
    let selfUID = FIRAuth.auth()?.currentUser?.uid
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        //Followのチェック follower数のチェック
        DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: selfUID!).observe(.value, with: { (snapshot) in
            
            //self.newPosts = []
            self.folderNameBox = []
            self.imageURLBox = []
            self.linkURLBox = []
            self.nameBox = []
            self.userNameBox = []
            self.userProfileImageBox = []
            self.userIDBox = []
            
            
            
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        
                        if postDict["following"] as? Dictionary<String, AnyObject?> != nil {
                            
                            let followingDictionary = postDict["following"] as? Dictionary<String, AnyObject?>
                            for (followKey,followValue) in followingDictionary! {
                                
                                print("キーは\(followKey)、値は\(followValue)")
                                let followingKey = followKey
                                
                                
                            ///

                                //ユーザーのコレクションの読み込み
                                DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: followingKey).observe(.value, with: { (snapshot) in
                                    
                                    self.newPosts = []
                                    
                                    if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                        
                                        for snap in snapshot {
                                            
                                            if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                                
                                                
                                                
                                                if postDict["posts"] as? Dictionary<String, Dictionary<String, AnyObject?>> != nil {
                                                    
                                                    
                                                    let posts = postDict["posts"] as? Dictionary<String, Dictionary<String, AnyObject>>
                                                    
                                                    for (key,value) in posts! {
                                                        
                                                        let folderName = value["folderName"] as! String
                                                        
                                                        let imageURL = value["imageURL"] as! String
                                                        
                                                        let linkURL = value["linkURL"] as! String
                                                        
                                                        let name = value["name"] as! String
                                                        
                                                        //let postID = value["postID"] as! String
                                                        
                                                        //let pvCount = value["pvCount"] as! Int
                                                        
                                                        let userID = value["userID"] as! String
                                                        
                                                        let userName = value["userName"] as! String
                                                        
                                                        let userProfileImage = value["userProfileImage"] as! String
                                                        
                                                        
                                                        self.folderNameBox.append(folderName)
                                                        self.imageURLBox.append(imageURL)
                                                        self.linkURLBox.append(linkURL)
                                                        self.nameBox.append(name)
                                                        //self.postIDBox.append(postID)
                                                        //self.pvCountBox.append(pvCount)
                                                        //self.userIDBox.append(userID)
                                                        self.userNameBox.append(userName)
                                                        self.userProfileImageBox.append(userProfileImage)
                                                        self.userIDBox.append(userID)
                                                        
                                            
                                                        
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                }
                                                
                                                
                                                
                                                
                                                
                                            }
                                            
                                            
                                            
                                        }
                                        
                                        
                                        
                                        
                                        
                                    }
                                    
                                
                                    self.folderNameBox.reverse()
                                    self.imageURLBox.reverse()
                                    self.linkURLBox.reverse()
                                    self.nameBox.reverse()
                                    self.userIDBox.reverse()
                                    self.userNameBox.reverse()
                                    self.userProfileImageBox.reverse()
                                    
                                    self.tableFeed.reloadData()
                                    
                                    
                                    print(self.userProfileImageBox)
                                    
                                    
                                })

                                
                                
                            }
                            
                        }
                        
                    }
                    
                }
            }
            
            //
        })
        
        
        
        
        
        
          }
    
    let photoURLUser = FIRAuth.auth()?.currentUser?.photoURL
    var resNames = [String]()
    var resImagess = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return folderNameBox.count
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableFeed.dequeueReusableCell(withIdentifier: "Feeder", for: indexPath) as? FeedTableViewCell
        
        
        
        //読み込むまで画像は非表示
        cell?.clipsToBounds = true
        cell?.cardDesi.isHidden = true
        
        cell?.oneLoveButton.isHidden = true
        cell?.oneCloseButton.isHidden = true
        cell?.itemImage.image = nil
        cell?.userImage.image = nil
        cell?.userName.isHidden = true
        
        
        cell?.linkButton.isHidden = true
        cell?.linkFirstLabel.isHidden = true
        cell?.linkSecondLabel.isHidden = true
        cell?.linkImage.image = nil
        cell?.linkName.isHidden = true
        cell?.linkLoveButton.isHidden = true
        
        
        //現在のCell
        
        //画像ありのセル
        if self.imageURLBox[indexPath.row] != "" {
            
            if self.folderNameBox[indexPath.row] == "App" || self.folderNameBox[indexPath.row] == "Music" || self.folderNameBox[indexPath.row] == "Movie" || self.folderNameBox[indexPath.row] == "Book" {
                
                cell?.cardDesi.isHidden = false
                
                cell?.linkButton.isHidden = true
                cell?.linkFirstLabel.isHidden = true
                cell?.linkSecondLabel.isHidden = true
                cell?.linkImage.image = nil
                cell?.linkName.isHidden = true
                cell?.linkLoveButton.isHidden = true
                
                cell?.oneLoveButton.isHidden = true
                cell?.userName.isHidden = true
                cell?.oneCloseButton.isHidden = true
                cell?.itemImage.image = nil
                cell?.userImage.image = nil
                cell?.userName.isHidden = true
                
                
                
                
                //
                cell?.fourView.isHidden = false
                
                cell?.fourLoveButton.isHidden = false
                cell?.fouruserName.isHidden = false
                cell?.fourCloseButton.isHidden = false
                
                cell?.fourImage.af_setImage(withURL:  URL(string: self.imageURLBox[indexPath.row])!)
                cell?.fourProfileImage.af_setImage(withURL:  URL(string: self.userProfileImageBox[indexPath.row])!)
                
                
                cell?.fouruserName.text = self.userNameBox[indexPath.row]
                cell?.folderName.text = self.folderNameBox[indexPath.row]
                cell?.fourItemLabel.text = self.nameBox[indexPath.row]
                

                
            } else {
                
                
                 cell?.fourView.isHidden = true
                
                cell?.cardDesi.isHidden = true
                
                cell?.linkButton.isHidden = true
                cell?.linkFirstLabel.isHidden = true
                cell?.linkSecondLabel.isHidden = true
                cell?.linkImage.image = nil
                cell?.linkName.isHidden = true
                cell?.linkLoveButton.isHidden = true
                
                cell?.oneLoveButton.isHidden = false
                cell?.userName.isHidden = false
                cell?.oneCloseButton.isHidden = false
                
                cell?.itemImage.af_setImage(withURL:  URL(string: self.imageURLBox[indexPath.row])!)
                cell?.userImage.af_setImage(withURL:  URL(string: self.userProfileImageBox[indexPath.row])!)
                
                
                cell?.userName.text = self.userNameBox[indexPath.row]
                
                
            }
            
            
            
            return cell!
            
            
            
        } else if self.imageURLBox[indexPath.row] == "" {
            
            cell?.cardDesi.isHidden = false
            cell?.fourView.isHidden = true
            
            cell?.oneLoveButton.isHidden = true
            cell?.itemImage.image = nil
            cell?.userImage.image = nil
            cell?.userName.isHidden = true
            cell?.oneCloseButton.isHidden = true
            
            
            //なしのせる
            cell?.linkButton.isHidden = false
            cell?.linkFirstLabel.isHidden = false
            cell?.linkSecondLabel.isHidden = false
            cell?.userImage.af_setImage(withURL:  URL(string: self.userProfileImageBox[indexPath.row])!)
            cell?.linkName.isHidden = false
            cell?.linkLoveButton.isHidden = false
            
            
            cell?.linkFirstLabel.text = self.folderNameBox[indexPath.row]
            cell?.linkSecondLabel.text = self.linkURLBox[indexPath.row]
            cell?.linkName.text = self.userNameBox[indexPath.row]
            
            return cell!
            
        }
        
       
return cell!
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.tableFeed {
            //画像ありのセル
            if self.imageURLBox[indexPath.row] != "" {
                
                if self.folderNameBox[indexPath.row] == "App" || self.folderNameBox[indexPath.row] == "Music" || self.folderNameBox[indexPath.row] == "Movie" || self.folderNameBox[indexPath.row] == "Book" {
                
                return 181
                
            } else {
                return 500
            }
            
                
            
                
                
            } else {
                //なしのせる
                return 120
                
                
            }
        }
        
        return 80
    }
    
        
    
        
        
        
        
    
    
    
    
    
    
    
   

}





