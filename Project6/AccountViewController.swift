//
//  AccountViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/27.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage


class AccountViewController: UIViewController,UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var profilePostTable: UITableView!
    @IBOutlet weak var profileNavBar: UINavigationBar!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileImage: ProfileImage!
    
    var userPosts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePostTable.delegate = self
        profilePostTable.dataSource = self
        profileNavBar.delegate = self
        
        self.profileNavBar.frame = CGRect(x: 0,y: 0, width: UIScreen.main.bounds.size.width, height: 55)
        
        
        
        self.profilePostTable.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)

    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if FIRAuth.auth()?.currentUser != nil {
            print("ユーザーあり")
            
            let user = FIRAuth.auth()?.currentUser
            
            let userName = user?.displayName
            let photoURL = user?.photoURL
            let uid = user?.uid
            
            self.profileName.text = userName

            if photoURL == nil {
                profileImage.image = UIImage(named: "drop")
            } else {
                profileImage.af_setImage(withURL: photoURL!)
            }
            
            
            
            
            
            
            
            DataService.dataBase.REF_BASE.child("posts").queryOrdered(byChild: "userID").queryEqual(toValue: FIRAuth.auth()?.currentUser?.uid).observe(.value, with: { (snapshot) in
                
                self.userPosts = []
                print(snapshot.value)
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.userPosts.append(post)
                            self.profilePostTable.reloadData()
                            

                        }
                        
                        
                    }
                    
                    
                }
                
                
                
                
                
                
                
                
            })
            
            
            
            
            
            
        } else {
            print("ユーザーなし")
        }
        
        
        
        
           }
    
    
    
    
   
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = profilePostTable.dequeueReusableCell(withIdentifier: "profilePosts", for: indexPath) as! ProfilePostsTableViewCell
        
        cell.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
        cell.layer.borderWidth = 10
        cell.clipsToBounds = true
        
        let post = userPosts[indexPath.row]
        
        if let img = AccountViewController.imageCache.object(forKey: post.imageURL as NSString) {
            
            cell.configureCell(post: post, img: img)
            
        } else {
            cell.configureCell(post: post)
        }
        
        
        return cell
    }
    
    
    @IBAction func actionButtonDidTap(_ sender: Any) {
        
        
        let actionSheet = UIAlertController(title: "選択", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.view.tintColor = UIColor.darkGray
        
        
        let edit = UIAlertAction(title: "プロフィールを編集", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            
            self.performSegue(withIdentifier: "goEdit", sender: nil)
            
            
        })
        
        let logout = UIAlertAction(title: "ログアウト", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            do {
                try FIRAuth.auth()?.signOut()
                
                
                let appDomain = Bundle.main.bundleIdentifier
                UserDefaults.standard.removePersistentDomain(forName: appDomain!)
                
                self.performSegue(withIdentifier: "logout", sender: nil)
            } catch let error as NSError {
                print("\(error.localizedDescription)")
            }
            
            
            
        })
        
        
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
        })
        
        actionSheet.addAction(edit)
        actionSheet.addAction(logout)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
        
        
        
        
    }
    
    
    
    
    

}


