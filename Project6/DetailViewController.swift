//
//  DetailViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/24.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

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
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        
        
        
        
        
        
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let detailImage = detailCollectionView.dequeueReusableCell(withReuseIdentifier: "DetailItems", for: indexPath) as? DetailCollectionViewCell
        
        detailImage?.detailItemImage.image = UIImage(named: "wantedly")
        
        
        
        
        
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
        
        let url = URL(string: imageURL!)
        
        DetailViewController.imageCache.object(forKey: "DetailNewImage")
        
        DispatchQueue.main.async {
            do {
                
                let imgData: Data = try  NSData(contentsOf:url!,options: NSData.ReadingOptions.mappedIfSafe) as Data
                
                let img = UIImage(data: imgData)
                self.detailImage.image = img
                DetailViewController.imageCache.setObject(img!, forKey: "DetailNewImage")
                
            } catch {
                
                print(error.localizedDescription)
            }
            
        }
        
        
        
        detailName.text = name
        detailStarNum.text = starNum
        detailCategoryName.text = categoryName
        detailWhatContent.text = whatContent
        
        
        
        
        
    }
    
   

}
