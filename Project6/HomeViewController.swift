//
//  HomeViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/13.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //Properties
    @IBOutlet weak var menuItem: UIBarButtonItem!
    @IBOutlet weak var newCollection: UICollectionView!
    @IBOutlet weak var popularCollection: UICollectionView!
    
    var images = ["sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample","sample"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        newCollection.dataSource = self
        newCollection.delegate = self
        popularCollection.dataSource = self
        popularCollection.delegate = self
        
        
        sideMenu()

    }

   //Functions
    
    func sideMenu() {
        
        if revealViewController() != nil {
            
            menuItem.target = revealViewController()
            menuItem.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if let newCell = newCollection?.dequeueReusableCell(withReuseIdentifier: "newCell", for: indexPath) as? newCollectionViewCell  {
            
            newCell.celImage.image = UIImage(named: images[indexPath.row])
            newCell.cellTitle.text = "SmartMenu"
            return newCell
            
        } else if let popularCell = popularCollection?.dequeueReusableCell(withReuseIdentifier: "PopularCell", for: indexPath) as? popularCollectionViewCell {
            
            
            popularCell.cellImage.image = UIImage(named: images[indexPath.row])
            popularCell.cellTitle.text = "SmartMenu"
            return popularCell
        }
        
       
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == newCollection {
            return images.count
            
        } else if collectionView == popularCollection {
            return images.count
        }
        
        return 3
        
    }
    
    
    
    
    

}
