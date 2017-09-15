//
//  DesignViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/14.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class DesignViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var designCollection: UICollectionView!
    
    let images = ["row2","row1","horirow"]
    let labels = ["縦2列","縦一列","横1列"]
    
    
    var folderName = String()
    var isSelected = false
    var selectedType = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.designCollection.delegate = self
        self.designCollection.dataSource = self
        
       
        
    }
    
   
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TOFirstPhoto" {
            //folderNameと雑誌タイプ
            let photoVC = (segue.destination as? PhotoPostViewController)!
            photoVC.folderName = self.folderName
            photoVC.type = self.selectedType
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.isSelected = true
        let num = indexPath.row
        print(num)
        print(self.folderName)
        self.selectedType = num
        
        if isSelected == true {
            
            self.isSelected = false
            performSegue(withIdentifier: "TOFirstPhoto", sender: nil)
            
        } else {
            
            //alert
            let alertViewControler = UIAlertController(title: "デザイン", message: "デザインを登録してください", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertViewControler.addAction(okAction)
            self.present(alertViewControler, animated: true, completion: nil)
        }

        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {


        //let cellSize:CGFloat = self.view.frame.size.width

        
        return CGSize(width: 300, height: 300)
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = designCollection.dequeueReusableCell(withReuseIdentifier: "Design", for: indexPath) as! DesignCollectionViewCell
        cell.designImage.image = UIImage(named: images[indexPath.row])
        cell.designLabel.text = labels[indexPath.row]
        cell.designImage.layer.cornerRadius = 10.0


        return cell
        
    }
    

}
