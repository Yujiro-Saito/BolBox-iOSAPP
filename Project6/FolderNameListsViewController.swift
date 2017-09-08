//
//  FolderNameListsViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/06.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FolderNameListsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var data = Bool()
    
    @IBOutlet weak var folderTable: UITableView!
    var folderListsBox = [String]()
    var selectedName = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.hidesBarsOnSwipe = true

        
        folderTable.delegate = self
        folderTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        let uids = FIRAuth.auth()?.currentUser?.uid
        
        //Folderame読み込み
        DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: FIRAuth.auth()?.currentUser?.uid).observe(.value, with: { (snapshot) in
            
            self.folderListsBox = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    
                    
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                      
                        
                         if postDict["folderName"] as? Dictionary<String, Dictionary<String, AnyObject?>> != nil {
                            
                            let folderName = postDict["folderName"] as? Dictionary<String, Dictionary<String, String>>
                            
                            for (key,value) in folderName! {
                                
                                //let valueImageURL = value["imageURL"] as! String
                                let valueText = value["name"] as! String
                                //self.folderImageURLBox.append(valueImageURL)
                                self.folderListsBox.append(valueText)
                                
                                
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                       
                    }
                    
                    
                }
            self.folderListsBox.reverse()
            self.folderTable.reloadData()
           
        })
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderListsBox.count
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   
    
    
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = folderTable.dequeueReusableCell(withIdentifier: "Folders", for: indexPath) as? FoldetListsTableViewCell
        print(self.folderListsBox[indexPath.row])
        cell?.folderName.text = self.folderListsBox[indexPath.row]
        cell?.layer.masksToBounds = true
        cell?.cardView.layer.cornerRadius = 5.0
        
        return cell!
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedName = self.folderListsBox[indexPath.row]
        if self.data == true {
            performSegue(withIdentifier: "PhotoPos", sender: nil)
        } else if self.data == false {
             performSegue(withIdentifier: "ToLinkPos", sender: nil)
        }
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PhotoPos" {
            
            let photoVC = (segue.destination as? PhotoPostViewController)!
            photoVC.folderName = selectedName
            
            
        } else if segue.identifier == "ToLinkPos" {
            
            let linkVC = (segue.destination as? LinkPostViewController)!
            linkVC.folderName = selectedName
                    
            
        }
        
        
        
        
    }
    
    
    
    
    
    
 
}
