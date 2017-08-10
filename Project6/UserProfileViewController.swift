//
//  UserProfileViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/16.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage


class UserProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate,UIScrollViewDelegate {
    
    
    @IBOutlet weak var userProfileImage: ProfileImage!
    @IBOutlet weak var userProfileName: UILabel!
    @IBOutlet weak var userDescription: UILabel!
    @IBOutlet weak var profileNavBar: UINavigationBar!
    
    @IBOutlet weak var scrollers: UIScrollView!
    
    
    
    
    @IBOutlet weak var userTable: UITableView!
    
    var userprofilePosts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    //データ受け継ぎ用
    
    var userName: String!
    var userImageURL: String!
    var userID: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(userID)
        scrollers.delegate = self
        userTable.delegate = self
        userTable.dataSource = self
        
        profileNavBar.delegate = self
        
        self.profileNavBar.frame = CGRect(x: 0,y: 0, width: UIScreen.main.bounds.size.width, height: 55)
        
        
        
        self.userTable.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        self.userTable.refreshControl = UIRefreshControl()
        self.userTable.refreshControl?.addTarget(self, action: #selector(UserProfileViewController.refresh), for: .valueChanged)

    }
    
    func refresh()  {
        self.userTable.refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //ユーザーデータ
        self.userProfileName.text = self.userName
        self.userProfileImage.af_setImage(withURL: URL(string: userImageURL)!)

        

        
        //ユーザー投稿を配列に取得
        
        DataService.dataBase.REF_BASE.child("posts").queryOrdered(byChild: "userID").queryEqual(toValue: userID).observe(.value, with: { (snapshot) in
        
            
            
            self.userprofilePosts = []
            
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        print(postDict)
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        
                        self.userprofilePosts.append(post)
                    }
                    
                    
                }
                
                
            }
            
            
        self.userprofilePosts.reverse()
        self.userTable.reloadData()
            
            
            
            
        })
        
        
        
        
        
        
        
        
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollers.isAtBottom == true {
            //テーブルビューのスクロール許可
            self.userTable.isScrollEnabled = true
            
            
            
        } else {
            //テーブルビューのスクロール許可しない
            if scrollers.isAtTop == false {
                self.userTable.isScrollEnabled = true
            } else {
                self.userTable.isScrollEnabled = false
            }
            
            
        }
        
    }

    
    
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userprofilePosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = userTable.dequeueReusableCell(withIdentifier: "userprofiletable", for: indexPath) as! UserProfileTableViewCell
        
        cell.postImage.image = nil
        
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 10
        cell.clipsToBounds = true
        
        
        let post = userprofilePosts[indexPath.row]
        
        if userprofilePosts[indexPath.row].imageURL != nil {
            cell.postImage.af_setImage(withURL: URL(string: userprofilePosts[indexPath.row].imageURL)!)
        }
        
        if let img = UserProfileViewController.imageCache.object(forKey: post.imageURL as! NSString) {
            
            cell.configureCell(post: post, img: img)
            
        } else {
            cell.configureCell(post: post)
        }

        
        return cell
    }
    
    
    
    var detailPosts: Post?
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        detailPosts = self.userprofilePosts[indexPath.row]
        
        performSegue(withIdentifier: "TotoDetail", sender: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TotoDetail" {
            
            let detailVc = (segue.destination as? InDetailViewController)!
            
            detailVc.name = detailPosts?.name
            detailVc.numLikes = (detailPosts?.pvCount)!
            detailVc.whatContent = detailPosts?.whatContent
            detailVc.imageURL = detailPosts?.imageURL
            detailVc.linkURL = detailPosts?.linkURL
            detailVc.userName = detailPosts?.userProfileName
            detailVc.userImageURL = detailPosts?.userProfileImage
            detailVc.userID = detailPosts?.userID
            
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    

   

}
