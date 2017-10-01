//
//  UserFIndViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/10/01.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage


class UserFIndViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let userVC = (segue.destination as? UserViewController)!
        
        userVC.userName = self.userName
        userVC.userID = self.userID
        userVC.userImageURL = self.userImage
    }
    
    var userID = String()
    var userName = String()
    var userImage = String()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.userName = self.names[indexPath.row]
        self.userID = self.ids[indexPath.row]
        self.userImage = self.images[indexPath.row]
        
        performSegue(withIdentifier: "YesUser", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.findTable.delegate = self
        self.findTable.dataSource = self
        
        userFindField.delegate = self
        
        userFindField.enablesReturnKeyAutomatically = false
        
        userFindField.placeholder = "ユーザーを検索"
        
        userFindField.disableBlur()
        userFindField.backgroundColor = UIColor.clear
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    @IBOutlet weak var findTable: UITableView!
    
    @IBOutlet weak var userFindField: UISearchBar!
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = findTable.dequeueReusableCell(withIdentifier: "Finder", for: indexPath) as? FindTableViewCell
        
        cell?.profileIMage.image = nil
        cell?.titleName.text = self.names[indexPath.row]
        
        
        DispatchQueue.main.async {
            
            cell?.profileIMage.af_setImage(withURL: URL(string: self.images[indexPath.row])!)
            
            
            
        }
        
        
        
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let searchText = userFindField.text
        
        let commonName = searchText?.lowercased()
        
        let enocodedText = commonName!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            
            DataService.dataBase.REF_BASE.child("users").observe(.value, with: { (snapshot) in
                
                self.images = []
                self.names = []
                self.ids = []
                
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshot {
                        
                        
                        
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                         
                            
                            let name = postDict["userName"] as? String
                            let image = postDict["userImageURL"] as? String
                            let uid = postDict["uid"] as? String
                            
                            
                            if (name?.lowercased().contains((searchText?.lowercased())!))! {
                                self.names.append(name!)
                                self.ids.append(uid!)
                                self.images.append(image!)
                                
                                
                                print(self.names)
                                print(self.ids)
                                print(self.images)
                            }
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                }
                
                
                
                
                
                
                
                
                
                
                
            })
            
            
            
            
            self.findTable.reloadData()
           
        }
        
        return true
        
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            
            self.names.removeAll()
            self.ids.removeAll()
            self.images.removeAll()
            
        }
        
        
        
    }
    
    var names = [String]()
    var ids = [String]()
    var images = [String]()
    
    
    //検索ボタン押下時の呼び出しメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        userFindField.resignFirstResponder()
        
    }

 
}
