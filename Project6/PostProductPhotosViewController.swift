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
    var detailImage: UIImage? = UIImage()
    
    
    //データ引き継ぎ用
    
    var productName = String()
    var productURL = String()
    var productCategory = String()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        self.detailImageCollection.reloadData()
        
        print(detailImage!)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        detailImageCollection.delegate = self
        detailImageCollection.dataSource = self
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Story") {
            
            let postStory = (segue.destination as? StoryViewController)!
            
            //detailImageBoxの引き継ぎ
            
            postStory.detailImages = self.detailImageBox
            
            //detailImageの引き継ぎ
            
            //postStory.detailOne = self.detailImage!
            postStory.detailOne = self.mainImagePhoto.image!
            
            
            
            //名前、URL、カテゴリーの引き継ぎ
            postStory.name = self.productName
            postStory.url = self.productURL
            postStory.categoryTitle = self.productCategory
            
        }
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
    
    
   
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                self.mainImageBox = image
                
                self.mainImagePhoto.image = self.mainImageBox
                
                
            }
            
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func ToKeepOn(_ sender: Any) {
        
        
        if detailImageBox != [] {
            
            performSegue(withIdentifier: "Story", sender: nil)
            
        } else {
            
            let alertViewControler = UIAlertController(title: "エラーがあります", message: "写真を登録して下さい", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertViewControler.addAction(okAction)
            self.present(alertViewControler, animated: true, completion: nil)
            
        }
        
        
        
        
    }
    
    
    @IBAction func mainPhotoDidTap(_ sender: Any) {
        
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
    
    @IBAction func detailPhotoDidTap(_ sender: Any) {
        
        
        pickerController.maxSelectableCount = 3
        
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            
            self.detailImageBox = []
            
            //選択された画像の取り出し
            for asset in assets {
                asset.fetchFullScreenImage(true, completeBlock: { (image, info) in
                    
                    
                    var imageBox = self.detailImage
                    
                    imageBox = image!
                    
                    self.detailImageBox.append(imageBox!)
                    
                    
                })
                
            }
            
            
        }
        
        self.present(pickerController, animated: true) {}
        
        self.detailImageCollection.reloadData()
        
        
    }
    





}
