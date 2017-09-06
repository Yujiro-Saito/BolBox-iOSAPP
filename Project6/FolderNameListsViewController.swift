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
    
    
    @IBOutlet weak var folderTable: UITableView!
    var folderListsBox = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        folderTable.delegate = self
        folderTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        let uids = FIRAuth.auth()?.currentUser?.uid
        
        //Folderame読み込み
        DataService.dataBase.REF_BASE.child("users").child(uids!).child("folderName").observe(.value, with: { (snapshot) in
            
            self.folderListsBox = []
            
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    print(snap.value!)
                   
                       let folderName = snap.value! as! String
                    
                    
                    self.folderListsBox.append(folderName)
                        
                        
                       
                    }
                    
                    
                }
            print(self.folderListsBox)
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
        
        
        return cell!
        
        
    }
    
 
}
