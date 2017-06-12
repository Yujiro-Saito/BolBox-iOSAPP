//
//  HomeViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/13.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //Properties
    @IBOutlet weak var menuItem: UIBarButtonItem!
    @IBOutlet weak var newCollection: UICollectionView!
    @IBOutlet weak var popularCollection: UICollectionView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var slideMenu: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var categoriesTable: UITableView!
    
    
    
    var posts = [Post]()
    var detailNewPosts: Post?
    var detailPopularPosts: Post?
    var popularPosts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var menuOpened = false
    var displayName = ["ホーム", "ゲーム"," ガジェット","メディア","エンターテイメント","教育・キャリア"]
    var displayImages: [UIImage] = [#imageLiteral(resourceName: "wantedly"),#imageLiteral(resourceName: "wantedly"),#imageLiteral(resourceName: "wantedly"),#imageLiteral(resourceName: "wantedly"),#imageLiteral(resourceName: "wantedly"),#imageLiteral(resourceName: "wantedly")]
    var selectedIndexNum = Int()
    var ref = FIRDatabaseReference()
    
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        do {
            
            DataService.dataBase.REF_GAME.queryLimited(toLast: 4).observe(.value, with: { (snapshot) in
                
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
                
                
                
                DataService.dataBase.REF_ENTERTAINMENT.queryLimited(toLast: 4).observe(.value, with: { (snapshot) in
                    
                    
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
                    
                    
                    
                    
                    DataService.dataBase.REF_GADGET.queryLimited(toLast: 4).observe(.value, with: { (snapshot) in
                        
                        
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
                        
                        
                        
                        
                        self.newCollection.reloadData()
                        
                        
                    })
                    
                    
                })
                
                
                
                
            })
            
            

            
        } catch {
            
            print("読み込みに失敗しました")
            
        }
        
        
        do {
            
            DataService.dataBase.REF_GAME.queryOrdered(byChild: "pvCount").queryLimited(toLast: 4).observe(.value, with: { (snapshot) in
                
                self.popularPosts = []
                
                print(snapshot.value)
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        print("SNAP: \(snap)")
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            let key = snap.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            
                            self.popularPosts.append(post)
                            
                            
                        }
                    }
                    
                    
                }
                
                
                
                DataService.dataBase.REF_ENTERTAINMENT.queryOrdered(byChild: "pvCount").queryLimited(toLast: 4).observe(.value, with: { (snapshot) in
                    
                    
                    if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        
                        for snap in snapshot {
                            print("SNAP: \(snap)")
                            
                            if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                
                                let key = snap.key
                                let post = Post(postKey: key, postData: postDict)
                                
                                
                                self.popularPosts.append(post)
                            }
                        }
                        
                        
                    }
                    
                    DataService.dataBase.REF_GADGET.queryOrdered(byChild: "pvCount").queryLimited(toLast: 4).observe(.value, with: { (snapshot) in
                        
                        
                        print(snapshot.value)
                        
                        if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            
                            for snap in snapshot {
                                print("SNAP: \(snap)")
                                
                                if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                    
                                    let key = snap.key
                                    let post = Post(postKey: key, postData: postDict)
                                    
                                    
                                    self.popularPosts.append(post)
                                }
                            }
                            
                            
                        }
                        
                        
                        
                        self.popularPosts.sort(by: {$0.pvCount > $1.pvCount})
                        self.popularCollection.reloadData()
                        
                    })
                    
                    
                })
                
                
                
                
            })

            
        } catch {
            print("読み込みに失敗しました")
        }
        
        
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
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : barColor]
        
        self.title = "Project6"
        
        
    
        
        let trailingTapped = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tapTrailing(sender:)))
        
        trailingTapped.numberOfTapsRequired = 1
        
        self.view.addGestureRecognizer(trailingTapped)
        
        let backgroundView = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.backgroundView(sender:)))
        backgroundView.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(backgroundView)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(HomeViewController.swipes(sender:)))
        
        swipe.direction = .left
        self.view.addGestureRecognizer(swipe)
        
    
        categoriesTable.delegate = self
        categoriesTable.dataSource = self
        newCollection.dataSource = self
        newCollection.delegate = self
        trailingTapped.delegate = self
        backgroundView.delegate = self
        popularCollection.dataSource = self
        popularCollection.delegate = self
        slideMenu.layer.shadowOpacity = 1
        slideMenu.layer.shadowRadius = 6
        trailingTapped.cancelsTouchesInView = false
        backgroundView.cancelsTouchesInView = false
        
        
        /*
        FIRAuth.auth()!.signInAnonymously { (firUser, error) in
            if error == nil {
                print("Login")
            } else {
                print(error?.localizedDescription)
            }
        }
        
       */
 

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
        
               
        
        return 0
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (segue.identifier == "detailPosts") {
            
            let detailVc = (segue.destination as? DetailViewController)!        
            
            detailVc.name = detailNewPosts!.name
            detailVc.categoryName = detailNewPosts!.category
            detailVc.starNum = detailNewPosts!.pvCount
            detailVc.whatContent = detailNewPosts!.whatContent
            detailVc.imageURL = detailNewPosts!.imageURL
            detailVc.detailImageOne = detailNewPosts!.detailImageOne
            detailVc.detailImageTwo = detailNewPosts!.detailImageTwo
            detailVc.detailImageThree = detailNewPosts!.detailImageThree
            detailVc.linkURL = detailNewPosts?.linkURL
            detailVc.numberOfKeep = detailNewPosts?.keepCount
            
            
        } else if (segue.identifier == "detailPopularPosts") {
            
            let detailPopVc = (segue.destination as? DetailViewController)!
            
            detailPopVc.name = detailPopularPosts!.name
            detailPopVc.categoryName = detailPopularPosts!.category
            detailPopVc.starNum = detailPopularPosts!.pvCount
            detailPopVc.whatContent = detailPopularPosts!.whatContent
            detailPopVc.imageURL = detailPopularPosts!.imageURL
            detailPopVc.detailImageOne = detailPopularPosts!.detailImageOne
            detailPopVc.detailImageTwo = detailPopularPosts!.detailImageTwo
            detailPopVc.detailImageThree = detailPopularPosts!.detailImageThree
            detailPopVc.linkURL = detailPopularPosts!.linkURL
            detailPopVc.numberOfKeep = detailPopularPosts?.keepCount
            
            
        } else if (segue.identifier == "ToCategoryVC") {
            
            let accessToCategoryVC = (segue.destination as? CategoryTableViewController)!
            
            accessToCategoryVC.indexValue = self.selectedIndexNum
            
            
        }
        
        
        
    }
    
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if collectionView == newCollection {
            
            
            detailNewPosts = self.posts[indexPath.row]
            
            var numberOfPageViews = detailNewPosts?.pvCount
            
            print("ページビューカウント\(numberOfPageViews!)")
            
            
            
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
        
        performSegue(withIdentifier: "readNewAll", sender: nil)
        
    }
    
    
    @IBAction func readPopularAll(_ sender: Any) {
        
        performSegue(withIdentifier: "readAll1", sender: nil)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayName.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categoryCell = categoriesTable.dequeueReusableCell(withIdentifier: "CategoryDisplay", for: indexPath) as? CategoryDisplayTableViewCell
        
        categoryCell?.displayName.text = displayName[indexPath.row]
        categoryCell?.displayImage.image = displayImages[indexPath.row]
        
        categoryCell?.selectionStyle = UITableViewCellSelectionStyle.gray
        
        
        return categoryCell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexNum = indexPath.row
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        switch indexNum {
        case 0:
            print("0")
            
        case 1:
            print("1")
            self.selectedIndexNum = 1
            performSegue(withIdentifier: "ToCategoryVC", sender: nil)
        case 2:
            print("2")
            self.selectedIndexNum = 2
            performSegue(withIdentifier: "ToCategoryVC", sender: nil)
        case 3:
            print("3")
            self.selectedIndexNum = 3
            performSegue(withIdentifier: "ToCategoryVC", sender: nil)
        case 4:
            print("4")
            self.selectedIndexNum = 4
            performSegue(withIdentifier: "ToCategoryVC", sender: nil)
        case 5:
            print("5")
            self.selectedIndexNum = 5
            performSegue(withIdentifier: "ToCategoryVC", sender: nil)
        default:
            print("END")
        }
        
        
    }
    
    }



extension HomeViewController {
    
    func pageView() {
        
        
        
        
    }
    
    
    
}






