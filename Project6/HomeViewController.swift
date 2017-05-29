//
//  HomeViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/13.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    //Properties
    @IBOutlet weak var menuItem: UIBarButtonItem!
    @IBOutlet weak var newCollection: UICollectionView!
    @IBOutlet weak var popularCollection: UICollectionView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var slideMenu: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
    
    var posts = [Post]()
    var detailNewPosts: Post?
    var detailPopularPosts: Post?
    var popularPosts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var menuOpened = false
    
    let categoryImages = ["game1","news","shopping","tech","travel2","food","entertainment"]
    
    let categoryNames = ["ゲーム","メディア","ショッピング","テクノロジー","旅","食","エンターテイメント"]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //新着投稿
        DataService.dataBase.REF_POST.queryLimited(toLast: 10).observe(.value, with: { (snapshot) in
            
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
            self.newCollection.reloadData()
            
        })
        
        
        
        
        //人気投稿
        
        
        DataService.dataBase.REF_POST.queryOrdered(byChild: "pvCount").queryLimited(toLast: 5).observe(.value, with: { (snapshot) in
            
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
            
            
            self.popularCollection.reloadData()
            
        })
        
        
        
        
        
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        
        if (touch.view?.isDescendant(of: slideMenu))! {
            return false
            
        }
        
        
        return true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
    
        
        let trailingTapped = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tapTrailing(sender:)))
        trailingTapped.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(trailingTapped)
        
        let backgroundView = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.backgroundView(sender:)))
        backgroundView.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(backgroundView)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(HomeViewController.swipes(sender:)))
        
        swipe.direction = .left
        self.view.addGestureRecognizer(swipe)
        
    
        
        newCollection.dataSource = self
        newCollection.delegate = self
        trailingTapped.delegate = self
        popularCollection.dataSource = self
        popularCollection.delegate = self
        slideMenu.layer.shadowOpacity = 1
        slideMenu.layer.shadowRadius = 6
        trailingTapped.cancelsTouchesInView = false
        
        FIRAuth.auth()!.signInAnonymously { (firUser, error) in
            if error == nil {
                print("LoginOKKKK")
            } else {
                print(error?.localizedDescription)
            }
        }
        
        
        
 

    }
    
    
    func swipes(sender: UISwipeGestureRecognizer) {
        print("right Swipe")
        
        leadingConstraint.constant = -240
        trailingConstraint.constant = -375
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    
    func tapTrailing(sender: UITapGestureRecognizer) {
        print("single")
        
        
        leadingConstraint.constant = -240
        trailingConstraint.constant = -375
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
        
        
    }
    
    func backgroundView(sender: UITapGestureRecognizer) {
        print("single")
        
        leadingConstraint.constant = -240
        trailingConstraint.constant = -375
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    
    
    
    
    
    
    @IBAction func openSlide(_ sender: Any) {
        
        if (menuOpened) {
            leadingConstraint.constant = -240
            trailingConstraint.constant = -375
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            slideMenu.frame.size.height = self.view.frame.size.height
            leadingConstraint.constant = 0
            trailingConstraint.constant = 0
            
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                
                
                
                
            })
            
            
        }
        
        menuOpened = !menuOpened
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == newCollection {
            
            if let newCell = newCollection.dequeueReusableCell(withReuseIdentifier: "newCell", for: indexPath) as? newCollectionViewCell  {
                
                let post = posts[indexPath.row]

                
                if let img = HomeViewController.imageCache.object(forKey: post.imageURL as NSString) {
                    newCell.configureCell(post: post, img: img)
                } else {
                    newCell.configureCell(post: post)
                }
                
                return newCell
                
            }

        } else if collectionView == popularCollection {
            
            if let popularCell = popularCollection.dequeueReusableCell(withReuseIdentifier: "PopularCell", for: indexPath) as? popularCollectionViewCell {
                
                let post = popularPosts[indexPath.row]
                
                if let img = HomeViewController.imageCache.object(forKey: post.imageURL as NSString) {
                    
                    popularCell.configureCell(post: post, img: img)
                    
                } else {
                    
                    popularCell.configureCell(post: post)
                    
                }
                
                self.popularPosts.sort(by: {$0.pvCount > $1.pvCount})
                
                return popularCell
            }
            
        }
        
             return newCollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == newCollection {
            
            
            return posts.count
            
        }
        
        else if collectionView == popularCollection {
            
            
            return popularPosts.count
            
        }
        
               
        
        return categoryImages.count
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (segue.identifier == "detailPosts") {
            
            let detailVc = (segue.destination as? DetailViewController)!
        
            
            detailVc.name = detailNewPosts!.name
            detailVc.categoryName = detailNewPosts!.category
            detailVc.starNum = "\(detailNewPosts!.pvCount)"
            detailVc.whatContent = detailNewPosts!.whatContent
            detailVc.imageURL = detailNewPosts!.imageURL
            
        } else if (segue.identifier == "detailPopularPosts") {
            
            let detailPopVc = (segue.destination as? DetailViewController)!
            
            detailPopVc.name = detailPopularPosts!.name
            detailPopVc.categoryName = detailPopularPosts!.category
            detailPopVc.starNum = "\(detailPopularPosts!.pvCount)"
            detailPopVc.whatContent = detailPopularPosts!.whatContent
            detailPopVc.imageURL = detailPopularPosts!.imageURL
            
            
        }
        
        
        
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if collectionView == newCollection {
           
             detailNewPosts = self.posts[indexPath.row]
            
            if detailNewPosts != nil {
                print("New")
                performSegue(withIdentifier: "detailPosts", sender: nil)
            }
            
            
        
        }
            
            
            
        else if collectionView == popularCollection {
            
            
            detailPopularPosts = self.popularPosts[indexPath.row]
            
            if detailPopularPosts != nil {
                
                print("Pop")
                performSegue(withIdentifier: "detailPopularPosts", sender: nil)
                
            }
            
            
            
        }
            
            }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    @IBAction func readNewAll(_ sender: Any) {
        
        performSegue(withIdentifier: "readAll", sender: nil)
        
    }
    
    
    @IBAction func readPopularAll(_ sender: Any) {
        
        performSegue(withIdentifier: "readAll1", sender: nil)
        
        
        
    }
    
    
    
    
    
    
    
    

}
