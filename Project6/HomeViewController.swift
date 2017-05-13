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
    var tableImagesOne: [String] = ["1", "2", "3", "4", "5", "6", "7", "8"]
    var tableImagesTwo: [String] = ["1", "2", "3", "4", "5", "6", "7", "8"]
    
    
    

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
        
        
        if let newCelly = newCollection?.dequeueReusableCell(withReuseIdentifier: "newCell", for: indexPath) {
            newCelly.backgroundColor = UIColor.blue
            return newCelly
        } else if let popuCelly = popularCollection?.dequeueReusableCell(withReuseIdentifier: "PopularCell", for: indexPath) {
            popuCelly.backgroundColor = UIColor.green
            return popuCelly
        }
        
        /*
        
        let newCell = newCollection.dequeueReusableCell(withReuseIdentifier: "newCell", for: indexPath)
        let popularCell = popularCollection.dequeueReusableCell(withReuseIdentifier: "PopularCell", for: indexPath)
        
        
        
        newCell.backgroundColor = UIColor.blue
        popularCell.backgroundColor = UIColor.green
        
        return newCell,popularCell
        */
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == newCollection {
            return 10
            
        } else if collectionView == popularCollection {
            return 5
        }
        
        return 3
        
    }
    
    
    
    
    

}
