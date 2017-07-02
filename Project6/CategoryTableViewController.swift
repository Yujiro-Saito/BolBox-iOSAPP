//
//  CategoryTableViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/03.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase

class CategoryTableViewController: UIViewController/*, UITableViewDataSource, UITableViewDelegate*/ {
    /*
    
    @IBOutlet weak var segmentedThree: UISegmentedControl!
    
    
    @IBOutlet weak var categoryTable: UITableView!
    var posts = [Post]()
    var popularPosts = [Post]()
    var recommenedPosts = [Post]()
    var selectedSegment = 0
    var indexValue = Int()
    var detailPosts: Post?
    
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        categoryTable.delegate = self
        categoryTable.dataSource = self
        
        
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
        if indexValue == 1 {
            
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : barColor]
            
            self.title = "ゲーム"
            
            //人気投稿
            
            DataService.dataBase.REF_GAME.queryOrdered(byChild: "pvCount").observe(.value, with: { (snapshot) in
                
                self.popularPosts = []
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            
                            
                            
                            self.popularPosts.append(post)
                            
                            self.popularPosts.sort(by: {$0.pvCount > $1.pvCount})
                            
                        }
                    }
                    
                    
                }
                
                
                self.categoryTable.reloadData()
                
            })
            
            //おすすめ
            DataService.dataBase.REF_GAME.observe(.value, with: { (snapshot) in
                
                self.recommenedPosts = []
                
                print(snapshot.value)
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            
                            self.recommenedPosts.append(post)
                        }
                    }
                    
                    
                }
                self.recommenedPosts.reverse()
                self.recommenedPosts.shuffle()
                self.categoryTable.reloadData()
                
            })
            
            
            
            
            
        } else if indexValue == 2 {
            
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : barColor]
            
            self.title = "ガジェット"
            
            //人気投稿
            
            DataService.dataBase.REF_GADGET.queryOrdered(byChild: "pvCount").observe(.value, with: { (snapshot) in
                
                self.popularPosts = []
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            
                            
                            
                            self.popularPosts.append(post)
                            
                            self.popularPosts.sort(by: {$0.pvCount > $1.pvCount})
                            
                        }
                    }
                    
                    
                }
                
                
                self.categoryTable.reloadData()
                
            })
            
            //おすすめ
            DataService.dataBase.REF_GADGET.observe(.value, with: { (snapshot) in
                
                self.recommenedPosts = []
                
                print(snapshot.value)
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            
                            self.recommenedPosts.append(post)
                        }
                    }
                    
                    
                }
                self.recommenedPosts.reverse()
                self.recommenedPosts.shuffle()
                self.categoryTable.reloadData()
                
            })
            

            
            
            
        } else if indexValue == 3 {
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : barColor]
            
            self.title = "メディア"
            
            
        } else if indexValue == 4 {
            
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : barColor]
            
            self.title = "エンターテインメント"
            
            
            //人気投稿
            
            DataService.dataBase.REF_ENTERTAINMENT.queryOrdered(byChild: "pvCount").observe(.value, with: { (snapshot) in
                
                self.popularPosts = []
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            
                            
                            
                            self.popularPosts.append(post)
                            
                            self.popularPosts.sort(by: {$0.pvCount > $1.pvCount})
                            
                        }
                    }
                    
                    
                }
                
                
                self.categoryTable.reloadData()
                
            })
            
            
            //おすすめ
            DataService.dataBase.REF_ENTERTAINMENT.observe(.value, with: { (snapshot) in
                
                self.recommenedPosts = []
                
                print(snapshot.value)
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            
                            self.recommenedPosts.append(post)
                        }
                    }
                    
                    
                }
                self.recommenedPosts.reverse()
                self.recommenedPosts.shuffle()
                self.categoryTable.reloadData()
                
            })
        } else if indexValue == 5 {
            
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : barColor]
            
            self.title = "教育・キャリア"
            
            
        }
        
        
        
        
       

        
    }
    
   

    @IBAction func segmentedTapped(_ sender: Any) {
        
        
        let segmentedNum = segmentedThree.selectedSegmentIndex
        
        switch segmentedNum {
        case 0:
            
            selectedSegment = 0
            
            //人気
            if indexValue == 1 {
                
                
                
                DataService.dataBase.REF_GAME.queryOrdered(byChild: "pvCount").observe(.value, with: { (snapshot) in
                    
                    self.popularPosts = []
                    
                    if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        
                        for snap in snapshot {
                            print("SNAP: \(snap)")
                            
                            
                            if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                
                                
                                let key = snap.key
                                let post = Post(postKey: key, postData: postDict)
                                
                                
                                
                                
                                self.popularPosts.append(post)
                                
                                self.popularPosts.sort(by: {$0.pvCount > $1.pvCount})
                                
                            }
                        }
                        
                        
                    }
                    
                    
                    self.categoryTable.reloadData()
                    
                })
                
            } else if indexValue == 2 {
                
                DataService.dataBase.REF_GADGET.queryOrdered(byChild: "pvCount").observe(.value, with: { (snapshot) in
                    
                    self.popularPosts = []
                    
                    if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        
                        for snap in snapshot {
                            print("SNAP: \(snap)")
                            
                            
                            if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                
                                
                                let key = snap.key
                                let post = Post(postKey: key, postData: postDict)
                                
                                
                                
                                
                                self.popularPosts.append(post)
                                
                                self.popularPosts.sort(by: {$0.pvCount > $1.pvCount})
                                
                            }
                        }
                        
                        
                    }
                    
                    
                    self.categoryTable.reloadData()
                    
                })
                
            } else if indexValue == 3 {
                
                
                
            } else if indexValue == 4 {
                DataService.dataBase.REF_ENTERTAINMENT.queryOrdered(byChild: "pvCount").observe(.value, with: { (snapshot) in
                    
                    self.popularPosts = []
                    
                    if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        
                        for snap in snapshot {
                            print("SNAP: \(snap)")
                            
                            
                            if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                
                                
                                let key = snap.key
                                let post = Post(postKey: key, postData: postDict)
                                
                                
                                
                                
                                self.popularPosts.append(post)
                                
                                self.popularPosts.sort(by: {$0.pvCount > $1.pvCount})
                                
                            }
                        }
                        
                        
                    }
                    
                    
                    self.categoryTable.reloadData()
                    
                })
                
                
            } else if indexValue == 5 {
                
                
                
            }
            
            
            
            
            
        case 1:
            
            selectedSegment = 1
            
            //新着
            
            if indexValue == 1 {
                
                DataService.dataBase.REF_GAME.observe(.value, with: { (snapshot) in
                    
                    self.posts = []
                    
                    print(snapshot.value)
                    
                    if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        
                        for snap in snapshot {
                            print("SNAP: \(snap)")
                            
                            if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                
                                let key = snap.key
                                let post = Post(postKey: key, postData: postDict)
                                
                                
                                self.posts.append(post)
                            }
                        }
                        
                        
                    }
                    self.posts.reverse()
                    self.categoryTable.reloadData()
                    
                })
                
            } else if indexValue == 2 {
                
                DataService.dataBase.REF_GADGET.observe(.value, with: { (snapshot) in
                    
                    self.posts = []
                    
                    print(snapshot.value)
                    
                    if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        
                        for snap in snapshot {
                            print("SNAP: \(snap)")
                            
                            if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                
                                let key = snap.key
                                let post = Post(postKey: key, postData: postDict)
                                
                                
                                self.posts.append(post)
                            }
                        }
                        
                        
                    }
                    self.posts.reverse()
                    self.categoryTable.reloadData()
                    
                })
                
            } else if indexValue == 3 {
                
                
                
            } else if indexValue == 4 {
                
                DataService.dataBase.REF_ENTERTAINMENT.observe(.value, with: { (snapshot) in
                    
                    self.posts = []
                    
                    print(snapshot.value)
                    
                    if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        
                        for snap in snapshot {
                            print("SNAP: \(snap)")
                            
                            if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                
                                let key = snap.key
                                let post = Post(postKey: key, postData: postDict)
                                
                                
                                self.posts.append(post)
                            }
                        }
                        
                        
                    }
                    self.posts.reverse()
                    self.categoryTable.reloadData()
                    
                })
                
            } else if indexValue == 5 {
                
            }
            
            
        case 2:
            
            selectedSegment = 2
            
            //おすすめ
            
            if indexValue == 1 {
                
                DataService.dataBase.REF_GAME.observe(.value, with: { (snapshot) in
                    
                    self.recommenedPosts = []
                    
                    print(snapshot.value)
                    
                    if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        
                        for snap in snapshot {
                            print("SNAP: \(snap)")
                            
                            if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                
                                let key = snap.key
                                let post = Post(postKey: key, postData: postDict)
                                
                                
                                self.recommenedPosts.append(post)
                            }
                        }
                        
                        
                    }
                    self.recommenedPosts.reverse()
                    self.recommenedPosts.shuffle()
                    self.categoryTable.reloadData()
                    
                })

                
            } else if indexValue == 2 {
                
                DataService.dataBase.REF_GADGET.observe(.value, with: { (snapshot) in
                    
                    self.recommenedPosts = []
                    
                    print(snapshot.value)
                    
                    if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        
                        for snap in snapshot {
                            print("SNAP: \(snap)")
                            
                            if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                
                                let key = snap.key
                                let post = Post(postKey: key, postData: postDict)
                                
                                
                                self.recommenedPosts.append(post)
                            }
                        }
                        
                        
                    }
                    self.recommenedPosts.reverse()
                    self.recommenedPosts.shuffle()
                    self.categoryTable.reloadData()
                    
                })

                
                
            } else if indexValue == 3 {
                
            } else if indexValue == 4 {
                
                DataService.dataBase.REF_ENTERTAINMENT.observe(.value, with: { (snapshot) in
                    
                    self.recommenedPosts = []
                    
                    print(snapshot.value)
                    
                    if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        
                        for snap in snapshot {
                            print("SNAP: \(snap)")
                            
                            if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                
                                let key = snap.key
                                let post = Post(postKey: key, postData: postDict)
                                
                                
                                self.recommenedPosts.append(post)
                            }
                        }
                        
                        
                    }
                    self.recommenedPosts.reverse()
                    self.recommenedPosts.shuffle()
                    self.categoryTable.reloadData()
                    
                })

                
            } else if indexValue == 5 {
                
            }
            
            
            
        default:
            print("ENDS")
        }
        
        
        
        
        
    }
    
    
    
            
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if selectedSegment == 0 {
            return popularPosts.count
        } else if selectedSegment == 1 {
            return posts.count
        } else if selectedSegment == 2 {
            return recommenedPosts.count
        }
        
        return 0

       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
            }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = categoryTable.dequeueReusableCell(withIdentifier: "CategoryItems", for: indexPath) as?  CategorysTableViewCell
        
        cell?.layer.borderColor = UIColor.black.cgColor
        cell?.layer.borderWidth = 5
        cell?.clipsToBounds = true
        
        
        
        if selectedSegment == 0 {
            
            cell?.layer.borderColor = UIColor.gray.cgColor
            cell?.layer.borderWidth = 5
            cell?.clipsToBounds = true
            
            let post = popularPosts[indexPath.row]
            
            if let img = CategoryTableViewController.imageCache.object(forKey: post.imageURL as NSString) {
                
                cell?.configureCell(post: post, img: img)
                
            }
            else {
                
                cell?.configureCell(post: post)
                
            }
            
            self.popularPosts.sort(by: {$0.pvCount > $1.pvCount})
            
            return cell!
        
        } else if selectedSegment == 1 {
            
            cell?.layer.borderColor = UIColor.gray.cgColor
            cell?.layer.borderWidth = 5
            cell?.clipsToBounds = true
            
            
            let post = posts[indexPath.row]
            
            
            if let img = CategoryTableViewController.imageCache.object(forKey: post.imageURL as NSString) {
                cell?.configureCell(post: post, img: img)
            } else {
                cell?.configureCell(post: post)
            }
            
            return cell!
            
        } else if selectedSegment == 2 {
            
            cell?.layer.borderColor = UIColor.gray.cgColor
            cell?.layer.borderWidth = 5
            cell?.clipsToBounds = true
            
            let post = recommenedPosts[indexPath.row]
            
            if let img = CategoryTableViewController.imageCache.object(forKey: post.imageURL as NSString) {
                cell?.configureCell(post: post, img: img)
            } else {
                cell?.configureCell(post: post)
            }
            
            return cell!
            
        }

    
    
        
        
        
        
        return cell!
        

        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
        switch selectedSegment {
        case 0:
            
            detailPosts = self.popularPosts[indexPath.row]
            performSegue(withIdentifier: "CategoryDetailGo", sender: nil)
            
        case 1:
            
            detailPosts = self.posts[indexPath.row]
            performSegue(withIdentifier: "CategoryDetailGo", sender: nil)
            
        case 2:
            
            detailPosts = self.recommenedPosts[indexPath.row]
            performSegue(withIdentifier: "CategoryDetailGo", sender: nil)
            
        default:
            print("error")
        }
        
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if (segue.identifier == "CategoryDetailGo") {
            
            let detailVc = (segue.destination as? DetailViewController)!
        
            
            detailVc.name = detailPosts?.name
            detailVc.categoryName = detailPosts?.category
            detailVc.starNum = detailPosts?.pvCount
            detailVc.whatContent = detailPosts?.whatContent
            detailVc.imageURL = detailPosts?.imageURL
            detailVc.detailImageOne = detailPosts?.detailImageOne
            detailVc.detailImageTwo = detailPosts?.detailImageTwo
            detailVc.detailImageThree = detailPosts?.detailImageThree
            detailVc.linkURL = detailPosts?.linkURL
            detailVc.numberOfKeep = detailPosts?.keepCount
            
            
        }
        else {
            print("error")
        }
    }
    
    
    
    

   

}
 */
}

extension UIColor {
    class func rgb(r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}


extension Array
{
    mutating func shuffle()
    {
        for _ in 0..<10
        {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}




