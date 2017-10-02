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
    
    var deleteCheck = false
    
    @IBAction func linkDelete(_ sender: Any) {
        
        var buttonS = sender as! UIButton
        var cellings = buttonS.superview?.superview as! ToysTableViewCell
        var rows = toysTable.indexPath(for: cellings)?.row
        
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        let postID = self.linkPosts[rows!].postID


        print("\(rows!)")
        
        let alert: UIAlertController = UIAlertController(title: "削除", message: "このアイテムを削除しますか", preferredStyle:  UIAlertControllerStyle.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("OK")
            
            //linkPosts削除
            
            DispatchQueue.main.async {
                self.linkPosts.remove(at: rows!)
                //self.linkPosts = []
                
                self.toysTable.reloadData()
                
                self.deleteCheck = true
            }
            
            
            self.wait( {self.deleteCheck == false} ) {
                
                DataService.dataBase.REF_BASE.child("users/\(userID!)/posts/\(postID)").removeValue()
                
                
                
                
                self.deleteCheck = false
                
                
                
            }
            
            
            
            
            
            
            
            
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func delte(_ sender: Any) {
        
        
        
        var btn = sender as! UIButton
        var cell = btn.superview?.superview as! ToyCollectionViewCell
        var row = toysCollection.indexPath(for: cell)?.row
        
        // 行数を表示
        print("\(row!)")
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        let postID = self.photoPosts[row!].postID
        
        print(postID)
        
        let alert: UIAlertController = UIAlertController(title: "削除", message: "このアイテムを削除しますか", preferredStyle:  UIAlertControllerStyle.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("OK")
            
       //PhotoPosts削除
            
            
            
            DispatchQueue.main.async {
                self.photoPosts.remove(at: row!)
                self.photoPosts = []
                
                 self.toysCollection.reloadData()
                
                self.deleteCheck = true
            }
            
            
            self.wait( {self.deleteCheck == false} ) {
                
                DataService.dataBase.REF_BASE.child("users/\(userID!)/posts/\(postID)").removeValue()
                
                
                
                
                self.deleteCheck = false
                
                
                
            }
            
            
            
            
           
            
            
            
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        self.present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    
    
    
    
    @IBOutlet weak var toysCollection: UICollectionView!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBAction func pageIndexTapped(_ sender: UISegmentedControl) {
        
        //写真
        if sender.selectedSegmentIndex == 0 {
            
            

                self.toysTable.isHidden = true
                self.toysCollection.isHidden = false
                self.photoTable.isHidden = true

            
            
            
            
            
            //リンク
        } else if sender.selectedSegmentIndex == 1 {
            
           
                self.toysTable.isHidden = false
                self.toysCollection.isHidden = true
                self.photoTable.isHidden = true

                
            
                
                self.toysTable.isHidden = false
                self.toysCollection.isHidden = true
                self.photoTable.isHidden = true

            
            
            
            
            
            
            
            
            
        }
        
        
        
    }
    
    @IBOutlet weak var toysTable: UITableView!
    
    var folderName = String()
    var linkPosts = [Post]()
    var linkingURL = String()
    
    var smallURL = String()
    var smallCaption = String()
    
    //common
    var names = [String]()
    var photoPosts = [Post]()
    
    var videoKeyBox = [String]()
    
    
    func editDidTap() {
        
       
        print(self.postIDSS)
        
        var firstCheck = false
        var secondCheck = false
        
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        
        
        let alert: UIAlertController = UIAlertController(title: "削除", message: "このフォルダを削除しますか", preferredStyle:  UIAlertControllerStyle.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("OK")
            
            self.showIndicator()
            
            //FolderName消す
            DispatchQueue.main.async {
                
                 DataService.dataBase.REF_BASE.child("users/\(userID!)/folderName/\(self.folderName)").removeValue()
                firstCheck = true
            }
            
            //FolderItem消す
            
            self.wait( {firstCheck == false} ) {
                
                
                
                DispatchQueue.main.async {
                    
                    
                    for postingID in self.postIDSS {
                        
                        //link
                        
                        DataService.dataBase.REF_BASE.child("users/\(userID!)/posts/\(postingID)").removeValue()
                        
                    }
                    
                    firstCheck = false
                    secondCheck = true
                    self.photoPosts = []
                    
                    self.toysCollection.reloadData()

                    self.indicator.stopAnimating()
                    
            }
            
           
                
                
                
                
                
                
            }
            
            
            self.wait( {secondCheck == false} ) {
                
                
                
                print("GOOOOOOOOOORU")
                
                self.performSegue(withIdentifier: "Armin", sender: nil)
                
                
                
                
                
            }
            
            
            
            
            
            
            
            
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBOutlet weak var photoTable: UITableView!
    
    var types = [String]()
    
    var postIDSS = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.videoKeyBox = []
        self.types = []
        self.postIDSS = []
        self.linkPosts = []
        self.photoPosts = []

        
        
        self.segment.isHidden = false

        
        photoTable.delegate = self
        photoTable.dataSource = self
        
        toysTable.delegate = self
        toysTable.dataSource = self
        // ナビゲーションを透明にする処理
        
        toysCollection.delegate = self
        toysCollection.dataSource = self
        
        
        
        segment.setTitle("写真・ビデオ", forSegmentAt: 0)
        segment.setTitle("リンク", forSegmentAt: 1)
        segment.backgroundColor = UIColor.clear
        segment.tintColor = UIColor.darkGray
        
        self.title = self.folderName
       
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.darkGray]
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        
        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash, target: self, action: #selector(MyToysViewController.editDidTap))
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        
        
       
            //Pinterest
            self.toysTable.isHidden = true
            self.toysCollection.isHidden = false
            self.photoTable.isHidden = true
            
        
        let uids = FIRAuth.auth()?.currentUser?.uid
        
        
            DataService.dataBase.REF_BASE.child("users").child(uids!).child("posts").queryOrdered(byChild: "folderName").queryEqual(toValue: folderName).observe(.value, with: { (snapshot) in
                
                self.linkPosts = []
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                            
                            if postDict["postID"] as? String != "" {
                                
                                let id = postDict["postID"] as? String
                                self.postIDSS.append(id!)
                                
                                
                            }
                            
                            //imageURLがない場合配列に追加
                            if postDict["imageURL"] as? String == "" {
                                let key = snap.key
                                let post = Post(postKey: key, postData: postDict)
                                
                                self.linkPosts.append(post)
                            } else if postDict["imageURL"] as? String != "" {
                                
                                if postDict["videoKey"] as? String != nil {
                                    
                                    let keyBox = postDict["videoKey"] as? String
                                    self.types.append("YES")
                                    self.videoKeyBox.append(keyBox!)
                                    let key = snap.key
                                    let post = Post(postKey: key, postData: postDict)
                                    
                                    
                                    
                                    self.photoPosts.append(post)
                                    
                                } else {
                                    
                                    self.videoKeyBox.append("")
                                    self.types.append("NO")
                                    let key = snap.key
                                    let post = Post(postKey: key, postData: postDict)
                                    
                                    
                                    
                                    self.photoPosts.append(post)
                                }
                                
                              
                                
                                
                                
                            }
                            
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                self.videoKeyBox.reverse()
                self.types.reverse()
                self.postIDSS.reverse()
                self.linkPosts.reverse()
                self.photoPosts.reverse()
                self.toysTable.reloadData()
                self.toysCollection.reloadData()
                self.photoTable.reloadData()
                
                
            })
            
            
        
        

        
        
        
    }
    
    
       
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == toysTable {
            return linkPosts.count
        } else if tableView == photoTable {
            return photoPosts.count
        }
        
        return 100
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
  
        
        
        if tableView == toysTable {
            
            let cell = toysTable.dequeueReusableCell(withIdentifier: "toys", for: indexPath) as? ToysTableViewCell
            //最初は何も入れない
            cell?.clipsToBounds = true
            
            let post = linkPosts[indexPath.row]
            
            
                cell?.coverView.isHidden = false
                cell?.smallCaption.isHidden = false
                cell?.smallURL.isHidden = false
                
                cell?.smallCaption.text = post.linkURL
                cell?.smallURL.text = post.name
                
                return cell!
        
            
            
            

            
            
        } else if tableView == photoTable {
            
            let photoCell = photoTable.dequeueReusableCell(withIdentifier: "Russia", for: indexPath) as? ToysPhotoTableViewCell
            
            
            let post = photoPosts[indexPath.row]
            
            
            //読み込むまで画像は非表示
            photoCell?.itemImage.image = nil
            
            
            
            
            let url = URL(string: post.imageURL)
            
            photoCell?.itemImage.af_setImage(withURL: url!)
            
            
            return photoCell!

            
            
            
            }
        
        
           return UITableViewCell()
        
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == toysTable {
            let post = linkPosts[indexPath.row]
            
           
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
        cell?.itemImage.layer.masksToBounds = true
        cell?.itemImage.layer.cornerRadius = 1.0
        
        
        
        cell?.itemImage.layer.borderWidth = 2.0 // 枠線の幅
        cell?.itemImage.layer.borderColor = UIColor.white.cgColor // 枠線の色
        cell?.itemImage.layer.cornerRadius = 10.0 // 角丸のサイズ
        
        
        
        let url = URL(string: post.imageURL)
        
        cell?.itemImage.af_setImage(withURL: url!)
        
        
        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //let cellSize:CGFloat = self.view.frame.size.width/4
        //let cellSize:CGFloat = self.view.frame.size.width/3-8
        let cellSize:CGFloat = self.view.frame.size.width/2-2
        //return CGSize(width: cellSize, height: cellSize)
        
        //let cellSize:CGFloat = self.view.frame.size.width/2-2
        
        //return CGSize(width: cellSize, height: 200)
        
        return CGSize(width: cellSize-8, height: cellSize-40)
    
    
    }
    
    
    
    //縦の間隔を決定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    //横の間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    var videoCheckKey = String()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "Armin" {
            
            
            
        } else {
            let detialVC = (segue.destination as? DetialContentViewController)!
            
            detialVC.videoKey = self.videoCheckKey
            
            detialVC.name = self.itemName
            detialVC.imageURL = self.itemIamgeURL
            detialVC.folderName = self.folderName
            
            
            if self.typeCheck == "YES" {
                detialVC.type = 2
            } else if self.typeCheck == "NO" {
                detialVC.type = 0
            } else {
                detialVC.type = self.typing
                detialVC.linkURL = self.itemLink!
            }

        }
        
        
        
        
        
        
        
    }
    
    var itemName = String()
    var itemIamgeURL = String()
    var itemDesc = String()
    var itemLink: String?
    var previewAccess: String?
    
    var typing = Int()
    var typeCheck = String()
    
    var isDoingEdit = false
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if self.isDoingEdit == false {
            itemName = self.photoPosts[indexPath.row].name
            itemIamgeURL = self.photoPosts[indexPath.row].imageURL
            itemLink = self.photoPosts[indexPath.row].linkURL
            
            self.videoCheckKey = self.videoKeyBox[indexPath.row]
            
            typeCheck = self.types[indexPath.row]
            
            
            performSegue(withIdentifier: "Dettil", sender: nil)
        } else {
            
            performSegue(withIdentifier: "Edit", sender: nil)
            
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemName = self.linkPosts[indexPath.row].name
        itemLink = self.linkPosts[indexPath.row].linkURL
        
        self.typing = 1
        
        self.videoCheckKey = "Fuck"
        
        performSegue(withIdentifier: "Dettil", sender: nil)
    }
    
    let indicator = UIActivityIndicatorView()
    
    func showIndicator() {
        
        indicator.activityIndicatorViewStyle = .whiteLarge
        
        indicator.center = self.view.center
        
        indicator.color = UIColor.darkGray
        
        indicator.hidesWhenStopped = true
        
        self.view.addSubview(indicator)
        
        self.view.bringSubview(toFront: indicator)
        
        indicator.startAnimating()
        
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
