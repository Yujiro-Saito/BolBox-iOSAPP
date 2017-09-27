//
//  YoutubePostViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/27.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import AlamofireImage
import Firebase

class YoutubePostViewController: UIViewController {

    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var imageURL = String()
    var titleString = String()
    var videoCode = String()
    var folderName = String()
    
    var folderInfo = Dictionary<String,String>()
    let uid = FIRAuth.auth()?.currentUser?.uid
    let userName = FIRAuth.auth()?.currentUser?.displayName
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(imageURL)
        print(titleString)
        print(videoCode)
        let url = URL(string: imageURL)
        
        self.titleLabel.text = titleString
        self.bgImage.af_setImage(withURL: url!)
        self.mainImage.af_setImage(withURL: url!)
        
        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(YoutubePostViewController.postButtonDidTap))
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        

    }
    
    
    func postButtonDidTap () {
        
        self.folderInfo = ["imageURL" : self.imageURL, "name" : self.folderName]
        
        let folderNameDictionary: Dictionary<String, Dictionary<String, String?>> = [self.folderName : folderInfo]
        
        let firebasePost = DataService.dataBase.REF_USER.child(uid!).child("posts").childByAutoId()
        let key = firebasePost.key
        let keyvalue = ("\(key)")

        let post: Dictionary<String, AnyObject> = [
            "bgType" : 0 as AnyObject,
            "folderName" :  self.folderName as AnyObject,
            "linkURL" : "" as AnyObject,
            "pvCount" : 0 as AnyObject,
            "userID" : uid as AnyObject,
            "userName" : userName as AnyObject,
            "name" :  self.titleString as AnyObject,
            "imageURL" : imageURL as AnyObject,
            "postID" : keyvalue as AnyObject,
            "videoKey" : self.videoCode as AnyObject
        ]
        
        firebasePost.setValue(post)
        DataService.dataBase.REF_BASE.child("users/\(self.uid!)/folderName").updateChildValues(folderNameDictionary)
        
        performSegue(withIdentifier: "VideoDone", sender: nil)
        
    }

   

}
