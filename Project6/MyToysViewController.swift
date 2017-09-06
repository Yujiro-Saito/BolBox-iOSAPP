//
//  MyToysViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/04.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import AlamofireImage

class MyToysViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var toysTable: UITableView!
    var folderName = String()
    var userPosts = [Post]()
    
    var smallURL = String()
    var smallCaption = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(folderName)
        toysTable.delegate = self
        toysTable.dataSource = self
        // ナビゲーションを透明にする処理
        self.navigationItem.title = folderName
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.hidesBarsOnSwipe = true
    
        
        let uids = FIRAuth.auth()?.currentUser?.uid
        
        DataService.dataBase.REF_BASE.child("users").child(uids!).child("posts").queryOrdered(byChild: "folderName").queryEqual(toValue: folderName).observe(.value, with: { (snapshot) in
            
            self.userPosts = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        
                        
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        
                        self.userPosts.append(post)
                        
                    }
                    
                    
                }
                
                
            }
            
            
            self.userPosts.reverse()
            self.toysTable.reloadData()
            
            
            
        })
        

        
        
        
    }
    
    
    
    
    
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = toysTable.dequeueReusableCell(withIdentifier: "toys", for: indexPath) as? ToysTableViewCell
        //最初は何も入れない
        cell?.toyItem.image = nil
        cell?.clipsToBounds = true
        cell?.toyCaption.text = ""
        cell?.toyURL.text = ""
        
        
        
        
        let post = userPosts[indexPath.row]
        
        //画像ありのセル
        if post.imageURL != "" {
            cell?.toyItem.af_setImage(withURL:  URL(string: post.imageURL)!)
            
            cell?.toyCaption.text = post.name
            cell?.toyURL.text = post.linkURL
            
            return cell!

            
            
        } else {
            //なしのせる
            cell?.coverView.isHidden = false
            cell?.toyItem.isHidden = true
            cell?.toyCaption.isHidden = true
            cell?.toyURL.isHidden = true
            
            
            cell?.smallCaption.isHidden = false
            cell?.smallURL.isHidden = false
            
            cell?.smallCaption.text = post.name
            cell?.smallURL.text = post.linkURL
            
            return cell!
            
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let post = userPosts[indexPath.row]
        
        
        //画像ありのセル
        if post.imageURL != "" {
            return 500
            
            
        } else {
            //なしのせる
            return 100
            
            
        }
        
        
        
        
        
        
    }
  
    
}
