//
//  PostProductPhotosViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/21.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import DKImagePickerController

class PostProductPhotosViewController: UIViewController, UIImagePickerControllerDelegate,UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var detailImageCollection: UICollectionView!
    let pickerController = DKImagePickerController()
    var detailImageBox = [UIImage]()
    var detailImage = UIImage()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailImageCollection.delegate = self
        detailImageCollection.dataSource = self
    }

    @IBAction func buttonDIdTap(_ sender: Any) {
        
        pickerController.maxSelectableCount = 3
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            
            // 選択された画像はassetsに入れて返却されますのでfetchして取り出すとよいでしょう
            for asset in assets {
                asset.fetchFullScreenImage(true, completeBlock: { (image, info) in
                    
                    self.detailImage = image!
                    
                    self.detailImageBox.append(self.detailImage)
                    
                    
                })
                
            }
            
            
        }
        
        self.present(pickerController, animated: true) {}
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return detailImageBox.count
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellItem = detailImageCollection.dequeueReusableCell(withReuseIdentifier: "", for: indexPath) as? PostDetailPhotosCollectionViewCell
        
        cellItem?.detailImage.image = detailImageBox[indexPath.row]
        
        return cellItem!
        
        
    }
    
    

   
}
