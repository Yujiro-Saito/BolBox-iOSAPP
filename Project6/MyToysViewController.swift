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

class MyToysViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet weak var toysCollection: UICollectionView!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBAction func pageIndexTapped(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            self.toysTable.isHidden = true
            self.toysCollection.isHidden = false
            
        } else if sender.selectedSegmentIndex == 1 {
            self.toysTable.isHidden = false
            self.toysCollection.isHidden = true
            
        }
        
        
        
    }
    
    @IBOutlet weak var toysTable: UITableView!
    var folderName = String()
    var linkPosts = [Post]()
    var photoPosts = [Post]()
    
    var smallURL = String()
    var smallCaption = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        toysTable.delegate = self
        toysTable.dataSource = self
        // ナビゲーションを透明にする処理
        
        toysCollection.delegate = self
        toysCollection.dataSource = self
        
        self.toysTable.isHidden = true
        self.toysCollection.isHidden = false
        
        
        segment.setTitle("写真", forSegmentAt: 0)
        segment.setTitle("リンク", forSegmentAt: 1)
        segment.backgroundColor = UIColor.clear
        segment.tintColor = UIColor.white
        
        self.title = self.folderName
       
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.hidesBarsOnSwipe = true
    
        
        let uids = FIRAuth.auth()?.currentUser?.uid
        
        DataService.dataBase.REF_BASE.child("users").child(uids!).child("posts").queryOrdered(byChild: "folderName").queryEqual(toValue: folderName).observe(.value, with: { (snapshot) in
            
            self.linkPosts = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        //imageURLがない場合配列に追加
                        if postDict["imageURL"] as? String == "" {
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.linkPosts.append(post)
                        } else if postDict["imageURL"] as? String != "" {
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.photoPosts.append(post)
                            
                            
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                }
                
                
            }
            
            
            self.linkPosts.reverse()
            self.photoPosts.reverse()
            self.toysTable.reloadData()
            self.toysCollection.reloadData()
            
            
        })
        

        
        
        
    }
    
    
       
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return linkPosts.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == toysTable {
            
            let cell = toysTable.dequeueReusableCell(withIdentifier: "toys", for: indexPath) as? ToysTableViewCell
            //最初は何も入れない
            cell?.clipsToBounds = true
            
            let post = linkPosts[indexPath.row]
            
            if post.name == "" {
                cell?.singleURL.isHidden = false
                cell?.coverView.isHidden = false
                cell?.smallCaption.isHidden = true
                cell?.smallURL.isHidden = true
                
                //cell?.smallCaption.text = post.name
                //cell?.smallURL.text = post.linkURL
                cell?.singleURL.text = post.linkURL
                
                return cell!
            } else if post.name != "" {
                cell?.singleURL.isHidden = true
                cell?.coverView.isHidden = false
                cell?.smallCaption.isHidden = false
                cell?.smallURL.isHidden = false
                
                cell?.smallCaption.text = post.name
                cell?.smallURL.text = post.linkURL
                
                return cell!
            }
            
            
            

            
            
        }
        
        
           return UITableViewCell()
        
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let post = linkPosts[indexPath.row]
        
        if post.name == "" {
            return 80
        } else if post.name != "" {
            return 120
        }
        
        
        
        
        return 900
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoPosts.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = toysCollection.dequeueReusableCell(withReuseIdentifier: "toyman", for: indexPath) as? ToyCollectionViewCell
        let post = photoPosts[indexPath.row]
        
        
        //読み込むまで画像は非表示
        cell?.itemImage.image = nil
        
        cell?.itemImage.layer.cornerRadius = 10.0
        
        
        
        let url = URL(string: post.imageURL)
        
        cell?.itemImage.af_setImage(withURL: url!)
        
        
        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //let cellSize:CGFloat = self.view.frame.size.width/3
        
        //return CGSize(width: cellSize, height: cellSize)
        
        let cellSize:CGFloat = self.view.frame.size.width/2-2
        
        return CGSize(width: cellSize, height: 200)
    }
    
    //縦の間隔を決定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    //横の間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

  
    
}
