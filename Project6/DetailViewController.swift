//
//  DetailViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/24.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //Outlet
    
    @IBOutlet weak var detailCollectionView: UICollectionView!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailStarNum: UILabel!
    @IBOutlet weak var detailCategoryName: UILabel!
    @IBOutlet weak var detailWhatContent: UILabel!
    
    var name: String?
    var starNum: String?
    var categoryName: String?
    var whatContent: String?
    var imageURL: String?
    var detailImageOne: String?
    var detailImageTwo: String?
    var detailImageThree: String?
    
    var detailImageBox = [String]()
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    var posts = [Post]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        
        
        
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let detailImage = detailCollectionView.dequeueReusableCell(withReuseIdentifier: "DetailItems", for: indexPath) as? DetailCollectionViewCell
        
       
        
        detailImage?.detailItemImage.af_setImage(withURL: URL(string: self.detailImageOne!)!)
        detailImage?.detailItemImage.af_setImage(withURL: URL(string: self.detailImageTwo!)!)
        detailImage?.detailItemImage.af_setImage(withURL: URL(string: self.detailImageThree!)!)
        
        
        
       
        return detailImage!
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        
        detailImage.af_setImage(withURL: URL(string: imageURL!)!)
        
        detailName.text = name
        detailStarNum.text = starNum
        detailCategoryName.text = categoryName
        detailWhatContent.text = whatContent
        
        
        
        
        
    }
    
   

}
