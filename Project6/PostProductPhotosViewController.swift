//
//  PostProductPhotosViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/21.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import DKImagePickerController

class PostProductPhotosViewController: UIViewController, UIImagePickerControllerDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var mainImagePhoto: ImageDesign!
    @IBOutlet weak var detailImageCollection: UICollectionView!
    var myImagePicker: UIImagePickerController!
    var mainImageBox = UIImage()
    
    let pickerController = DKImagePickerController()
    var detailImageBox = [UIImage]()
    var detailImage = UIImage()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        print(detailImageBox)
        self.detailImageCollection.reloadData()
        
        print(mainImageBox)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailImageCollection.delegate = self
        detailImageCollection.dataSource = self
        
        
        
    }

    @IBAction func buttonDIdTap(_ sender: Any) {
        
        
        pickerController.maxSelectableCount = 3
        
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            
            self.detailImageBox = []
            
            //選択された画像の取り出し
            for asset in assets {
                asset.fetchFullScreenImage(true, completeBlock: { (image, info) in
                    
                    
                    var imageBox = self.detailImage
                    
                    imageBox = image!
                    
                    self.detailImageBox.append(imageBox)
                    
                    
                })
                
            }
            
            
        }
        
        self.present(pickerController, animated: true) {}
        
        self.detailImageCollection.reloadData()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return detailImageBox.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellItem = detailImageCollection.dequeueReusableCell(withReuseIdentifier: "detailImagesAye", for: indexPath) as? PostDetailPhotosCollectionViewCell
        
        cellItem?.detailImage.image = detailImageBox[indexPath.row]
        
        return cellItem!
        
        
    }
    
    
    
    @IBAction func mainPhotoPick(_ sender: Any) {
       
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラロール許可をしていない時の処理")
        }
    }
    
   
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                self.mainImageBox = image
                
                self.mainImagePhoto.image = self.mainImageBox
                
               // self.mainImagePhoto.image = image
                
                
            }
            
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func ToKeepOn(_ sender: Any) {
        performSegue(withIdentifier: "Story", sender: nil)
        
        
    }
    





}
