//
//  BasicPostViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/22.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Firebase

class BasicPostViewController: UIViewController {
    
    var trackName: String!
    var previewUrl: String?
    var imageURL: String!
    var accessLink: String?
    var folderName: String!
    var artistName: String?
    var trackDesc: String?
    
    
    var folderInfo = Dictionary<String,String>()
    let uid = FIRAuth.auth()?.currentUser?.uid
    let userName = FIRAuth.auth()?.currentUser?.displayName
    
    var postingSitu: Int!
    
    
    @IBOutlet weak var desc: UILabel!
    
    
    @IBOutlet weak var itemImage: UIImageView!

    @IBOutlet weak var itemName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(BasicPostViewController.postButtonDidTap))
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.hidesBarsOnSwipe = true
        
        let imageDefURL = URL(string: imageURL)
        self.itemImage.af_setImage(withURL: imageDefURL!)
        self.itemName.text = trackName
        
        self.itemImage.layer.masksToBounds = true
        self.itemImage.layer.cornerRadius = 20
        
        if self.trackDesc != nil {
            self.desc.text = trackDesc
        }
        
        
        
        
        
        
        //
        print("かくにん")
        print(postingSitu)
        print(trackName)
        print(previewUrl)
        print(accessLink)
        print(trackDesc)
        print(folderName)
        print(artistName)
        print(trackName)
        
        
        
        
    }
    
    func postButtonDidTap() {
        
        
        if self.postingSitu == 0 {
            
            self.folderInfo = ["imageURL" : self.imageURL, "name" : "App"]
            
            let folderNameDictionary: Dictionary<String, Dictionary<String, String?>> = [self.folderName : folderInfo]
            
            
            let firebasePost = DataService.dataBase.REF_USER.child(uid!).child("posts").childByAutoId()
            let key = firebasePost.key
            let keyvalue = ("\(key)")
            
            let post: Dictionary<String, AnyObject> = [
                "bgType" : 0 as AnyObject,
                "folderName" :  "App" as AnyObject,
                "linkURL" : accessLink! as AnyObject,
                "pvCount" : 0 as AnyObject,
                "userID" : uid as AnyObject,
                "userName" : userName as AnyObject,
                "name" :  trackName as AnyObject,
                "imageURL" : imageURL as AnyObject,
                "postID" : keyvalue as AnyObject,
                "desc" : trackDesc! as AnyObject
            ]
            
            firebasePost.setValue(post)
            DataService.dataBase.REF_BASE.child("users/\(self.uid!)/basics").updateChildValues(folderNameDictionary)
            
            
            performSegue(withIdentifier: "PenBen", sender: nil)

        } else if self.postingSitu == 1 {
            
            
            self.folderInfo = ["imageURL" : self.imageURL, "name" : "Music"]
            
            let folderNameDictionary: Dictionary<String, Dictionary<String, String?>> = [self.folderName : folderInfo]
            
            
            let firebasePost = DataService.dataBase.REF_USER.child(uid!).child("posts").childByAutoId()
            let key = firebasePost.key
            let keyvalue = ("\(key)")
            
            let post: Dictionary<String, AnyObject> = [
                "bgType" : 0 as AnyObject,
                "folderName" :  "Music" as AnyObject,
                "linkURL" : accessLink! as AnyObject,
                "pvCount" : 0 as AnyObject,
                "userID" : uid as AnyObject,
                "userName" : userName as AnyObject,
                "name" : trackName as AnyObject,
                "imageURL" : imageURL as AnyObject,
                "postID" : keyvalue as AnyObject,
                "preview" : previewUrl! as AnyObject,
                "artistName" : artistName! as AnyObject
            ]
            
            firebasePost.setValue(post)
            DataService.dataBase.REF_BASE.child("users/\(self.uid!)/basics").updateChildValues(folderNameDictionary)
            
            
            performSegue(withIdentifier: "PenBen", sender: nil)
            
            
        } else if self.postingSitu == 2 {
            
            
            self.folderInfo = ["imageURL" : self.imageURL, "name" : "Movie"]
            
            let folderNameDictionary: Dictionary<String, Dictionary<String, String?>> = [self.folderName : folderInfo]
            
            
            let firebasePost = DataService.dataBase.REF_USER.child(uid!).child("posts").childByAutoId()
            let key = firebasePost.key
            let keyvalue = ("\(key)")
            
            let post: Dictionary<String, AnyObject> = [
                "bgType" : 0 as AnyObject,
                "folderName" :  "Movie" as AnyObject,
                "linkURL" : accessLink! as AnyObject,
                "pvCount" : 0 as AnyObject,
                "userID" : uid as AnyObject,
                "userName" : userName as AnyObject,
                "name" : trackName as AnyObject,
                "imageURL" : imageURL as AnyObject,
                "postID" : keyvalue as AnyObject,
                "artistName" : artistName! as AnyObject,
                "desc" : trackDesc! as AnyObject
            ]
            
            firebasePost.setValue(post)
            DataService.dataBase.REF_BASE.child("users/\(self.uid!)/basics").updateChildValues(folderNameDictionary)
            
            
            performSegue(withIdentifier: "PenBen", sender: nil)
            
            
            
            
            
            
            
            
            
        } else if self.postingSitu == 3 {
            
            self.folderInfo = ["imageURL" : self.imageURL, "name" : "Book"]
            
            let folderNameDictionary: Dictionary<String, Dictionary<String, String?>> = [self.folderName : folderInfo]
            
            
            let firebasePost = DataService.dataBase.REF_USER.child(uid!).child("posts").childByAutoId()
            let key = firebasePost.key
            let keyvalue = ("\(key)")
            
            let post: Dictionary<String, AnyObject> = [
                "bgType" : 0 as AnyObject,
                "folderName" :  "Book" as AnyObject,
                "pvCount" : 0 as AnyObject,
                "userID" : uid as AnyObject,
                "userName" : userName as AnyObject,
                "name" : trackName as AnyObject,
                "imageURL" : imageURL as AnyObject,
                "postID" : keyvalue as AnyObject,
                "artistName" : artistName! as AnyObject,
                "linkURL" : "" as AnyObject
             ]
            
            firebasePost.setValue(post)
            DataService.dataBase.REF_BASE.child("users/\(self.uid!)/basics").updateChildValues(folderNameDictionary)
            
            
            performSegue(withIdentifier: "PenBen", sender: nil)
            
            
            
            
        }
        
        
        
        
        
        
    }

    

}
