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
    @IBOutlet weak var profileDesc: UILabel!
    
    
    
    var userPosts = [Post]()
    var detailPosts: Post?
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var deleteCheck = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePostTable.delegate = self
        profilePostTable.dataSource = self
        profileNavBar.delegate = self
        
        //バーの高さ
        self.profileNavBar.frame = CGRect(x: 0,y: 0, width: UIScreen.main.bounds.size.width, height: 60)
        
        
        
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
            
            
            let userRef = DataService.dataBase.REF_BASE.child("users/\(FIRAuth.auth()!.currentUser!.uid)")
            
            
            userRef.observe(.value, with: { (snapshot) in
                
                //UserName取得
                let user = User(snapshot: snapshot)
                
                if user.userDesc == "" {
                    self.profileDesc.text = ""
                } else if user.userDesc == nil {
                    self.profileDesc.text = ""
                } else {
                    self.profileDesc.text = user.userDesc
                }
                
                
                
            })
            
            
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
                            
                            

                        }
                        
                        
                    }
                    
                    
                }
                
                
                self.userPosts.reverse()
                self.profilePostTable.reloadData()
                
                
                
                
                
            })
            
            
            
            
            
            
        } else {
            print("ユーザーなし")
        }
        
        
        
        
           }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        detailPosts = self.userPosts[indexPath.row]
        
        performSegue(withIdentifier: "ToDetail", sender: nil)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToDetail" {
            
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
            
            
            
            let postID = self.userPosts[indexPath.row].postID
            
            
            
            
            let alertViewControler = UIAlertController(title: "確認", message: "本当に削除しますか？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                
                
                self.deleteCheck = true
                
            })
            
            let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
                (action: UIAlertAction!) in
                
                self.profilePostTable.isEditing = false
            })

            
            
            alertViewControler.addAction(okAction)
            alertViewControler.addAction(cancel)
            
            
            self.present(alertViewControler, animated: true, completion: nil)
            
            
    
            
            self.wait( {self.deleteCheck == false} ) {
                
                //DBの削除
                DispatchQueue.global().async {
                    
                    DataService.dataBase.REF_BASE.child("posts/\(String(describing: postID))").removeValue()
                    
                }
                
                self.userPosts.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                
                
            }

                
                self.deleteCheck = false
                
            }
            
            deleteButton.backgroundColor = UIColor.rgb(r: 31, g: 158, b: 187, alpha: 1)
            
        
        
        return [deleteButton]
    }
    
   
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = profilePostTable.dequeueReusableCell(withIdentifier: "profilePosts", for: indexPath) as! ProfilePostsTableViewCell
        
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 10
        cell.clipsToBounds = true
        
        let post = userPosts[indexPath.row]
        
        if let img = AccountViewController.imageCache.object(forKey: post.imageURL as! NSString) {
            
            cell.configureCell(post: post, img: img)
            
        } else {
            cell.configureCell(post: post)
        }
        
        
        return cell
    }
    
    
    @IBAction func actionButtonDidTap(_ sender: Any) {
        
        
        let actionSheet = UIAlertController(title: "選択", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.view.tintColor = UIColor.rgb(r: 31, g: 158, b: 187, alpha: 1)
        
        
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
    
    
    func wait(_ waitContinuation: @escaping (()->Bool), compleation: @escaping (()->Void)) {
        var wait = waitContinuation()
        // 0.01秒周期で待機条件をクリアするまで待ちます。
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            while wait {
                DispatchQueue.main.async {
                    wait = waitContinuation()
                    semaphore.signal()
                }
                semaphore.wait()
                Thread.sleep(forTimeInterval: 0.01)
            }
            // 待機条件をクリアしたので通過後の処理を行います。
            DispatchQueue.main.async {
                compleation()
                
                
                
            }
        }
    }
    
    
    
    

}


