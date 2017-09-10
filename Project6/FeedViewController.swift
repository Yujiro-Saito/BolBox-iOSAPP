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



class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var newPosts = [Post]()
    var detailPosts: Post?
    
    @IBOutlet weak var tableFeed: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableFeed.delegate = self
        tableFeed.dataSource = self
        
        self.navigationItem.title = "Port"
        
        // フォント種をTime New Roman、サイズを10に指定
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSFontAttributeName: UIFont(name: "Times New Roman", size: 18)!]
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        
        DataService.dataBase.REF_POST.observe(.value, with: { (snapshot) in
            
            self.newPosts = []
            
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        
                        
                        
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.newPosts.append(post)
                            
                            
                        
                    }
                }
                
                
            }
            
            
            self.newPosts.reverse()
            self.tableFeed.reloadData()
            
        })
        
        
        
    }
    
    let photoURLUser = FIRAuth.auth()?.currentUser?.photoURL
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newPosts.count
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
        cell?.oneLabel.isHidden = true
        cell?.twoLabel.isHidden = true
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
        let post = newPosts[indexPath.row]
        
        //画像ありのセル
        if post.imageURL != "" {
            
            
            cell?.cardDesi.isHidden = true
            
            cell?.linkButton.isHidden = true
            cell?.linkFirstLabel.isHidden = true
            cell?.linkSecondLabel.isHidden = true
            cell?.linkImage.image = nil
            cell?.linkName.isHidden = true
            cell?.linkLoveButton.isHidden = true
            
            cell?.oneLoveButton.isHidden = false
            cell?.oneLabel.isHidden = false
            cell?.twoLabel.isHidden = false
            cell?.userName.isHidden = false
            cell?.oneCloseButton.isHidden = false
            
            cell?.itemImage.af_setImage(withURL:  URL(string: post.imageURL)!)
            cell?.userImage.af_setImage(withURL:  URL(string: post.userProfileImage)!)
            
            
            cell?.oneLabel.text = "jjjj"
            cell?.twoLabel.text = "eeeee"
            cell?.userName.text = "ccece"
            
            return cell!
            
            
            
        } else if post.imageURL == "" {
            
            cell?.cardDesi.isHidden = false
            
            cell?.oneLoveButton.isHidden = true
            cell?.oneLabel.isHidden = true
            cell?.twoLabel.isHidden = true
            cell?.itemImage.image = nil
            cell?.userImage.image = nil
            cell?.userName.isHidden = true
            cell?.oneCloseButton.isHidden = true
            
            
            //なしのせる
            cell?.linkButton.isHidden = false
            cell?.linkFirstLabel.isHidden = false
            cell?.linkSecondLabel.isHidden = false
            cell?.userImage.af_setImage(withURL:  URL(string: post.userProfileImage)!)
            cell?.linkName.isHidden = false
            cell?.linkLoveButton.isHidden = false
            
            
            cell?.linkFirstLabel.text = "dekoed"
            cell?.linkSecondLabel.text = "deedede"
            cell?.linkName.text = "deedede"
            
            return cell!
            
        }
        
       return cell!

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let post = newPosts[indexPath.row]
        
        
        //画像ありのセル
        if post.imageURL != "" {
            return 500
            
            
        } else {
            //なしのせる
            return 120
            
            
        }
        
        
        
        
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

   

}
