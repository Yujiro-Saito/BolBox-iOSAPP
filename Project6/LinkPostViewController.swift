//
//  LinkPostViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/06.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage
import Eureka

class LinkPostViewController: FormViewController, UIWebViewDelegate  {
    
    let titleWebView : UIWebView = UIWebView()
    //データ
    var folderName = String()
    let uid = FIRAuth.auth()?.currentUser?.uid
    let userName = FIRAuth.auth()?.currentUser?.displayName
    var folderInfo = Dictionary<String,String>()
    var linkBool = Bool()
    
    // ロード時にインジケータをまわす
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    // ロード完了でインジケータ非表示
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
        }
        self.check = true
    }
   
    
    var check = false
    //投稿ボタン
    func postButtonDidTap(){

        showIndicator()
        
        let linkRow: TextRow? = form.rowBy(tag: "link")
        let linkValue = linkRow?.value
        
        
        if linkValue == nil  {
            
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }
            
            let alertViewControler = UIAlertController(title: "リンク", message: "リンクは必須です", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertViewControler.addAction(okAction)
            self.present(alertViewControler, animated: true, completion: nil)
            
            
        } else {
            
            //タイトル取得
            
            DispatchQueue.main.async {
                
                let url: URL = URL(string: linkValue!)!
                let request: URLRequest = URLRequest(url: url)
                
                self.titleWebView.loadRequest(request)
                

                
            }
            
            
            self.wait( {self.check == false} ) {
                let titles = self.titleWebView.stringByEvaluatingJavaScript(from: "document.title")!
                print(self.titleWebView.stringByEvaluatingJavaScript(from: "document.title")!)
                self.check = false
                
                
                let alert: UIAlertController = UIAlertController(title: titles, message: nil, preferredStyle:  UIAlertControllerStyle.alert)
                
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                    (action: UIAlertAction!) -> Void in
                    print("OK")
                    
                    self.showIndicator()
                    
                    if self.isImage == false {
                        self.folderInfo = ["imageURL" : self.imageURL, "name" : self.folderName]
                    } else if self.isImage == true {
                        
                        self.folderInfo = ["imageURL" : self.imageURL, "name" : self.folderName]
                        
                    }
                    
                    
                    let folderNameDictionary: Dictionary<String, Dictionary<String, String?>> = [self.folderName : self.folderInfo]
                    
                    
                    let firebasePost = DataService.dataBase.REF_USER.child(self.uid!).child("posts").childByAutoId()
                    let key = firebasePost.key
                    let keyvalue = ("\(key)")
                    
                    let post: Dictionary<String, AnyObject> = [
                        //
                        
                        
                        "folderName" :  self.folderName as AnyObject,
                        "linkURL" : linkValue! as AnyObject,
                        "pvCount" : 0 as AnyObject,
                        "userID" : self.uid as AnyObject,
                        "userName" : self.userName as AnyObject,
                        "name" : titles as AnyObject,
                        "imageURL" : "" as AnyObject,
                        "postID" : keyvalue as AnyObject
                    ]
                    
                    self.linkBool = true
                    
                    self.wait( {self.linkBool == false} ) {
                        
                        
                        firebasePost.setValue(post)
                        DataService.dataBase.REF_BASE.child("users/\(self.uid!)/folderName").updateChildValues(folderNameDictionary)
                        self.linkBool = false
                        
                        DispatchQueue.main.async {
                            
                            self.indicator.stopAnimating()
                            self.performSegue(withIdentifier: "DoneLink", sender: nil)
                        }
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                })
                let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
                    (action: UIAlertAction!) -> Void in
                    print("Cancel")
                })
                
                alert.addAction(cancelAction)
                alert.addAction(defaultAction)
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
            
            
            
        }
        

        
        
    }
    
    var isImage = Bool()
    var imageURL = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleWebView.delegate = self
        titleWebView.scalesPageToFit = true
        
        
        DataService.dataBase.REF_BASE.child("users").child(uid!).child("folderName").queryOrdered(byChild: "name").queryEqual(toValue: folderName).observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        print(postDict)
                        
                        let itemURL = postDict["imageURL"] as! String
                        
                        if itemURL == "" {
                            self.isImage = false
                            self.imageURL = ""
                            
                        } else if itemURL != "" {
                            self.isImage = true
                            self.imageURL = itemURL
                            
                        }
                        
                        
                    }
                    
                }
                
                
            }
            
            
        })
        
        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(LinkPostViewController.postButtonDidTap))
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.darkGray]
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        self.navigationController?.hidesBarsOnSwipe = false
        tableView.backgroundColor = UIColor.white
        
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        
        form +++ Section("登録")
            <<< TextRow("link"){ row in
                row.title = "リンク"
                row.placeholder = "コピーしたリンク(必須)"
            }
        
        
        
        
        
        
        
    }
    
    let indicator = UIActivityIndicatorView()
    
    func showIndicator() {
        
        indicator.activityIndicatorViewStyle = .whiteLarge
        
        indicator.center = self.view.center
        
        indicator.color = UIColor.darkGray
        
        indicator.hidesWhenStopped = true
        
        self.view.addSubview(indicator)
        
        self.view.bringSubview(toFront: indicator)
        
        indicator.startAnimating()
        
    }
    
    
    func wait(_ waitContinuation: @escaping (()->Bool), compleation: @escaping (()->Void)) {
        var wait = waitContinuation()
        
        
        // 0.01秒周期で待機条件をクリアするまで待ちます。
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            while wait {
                DispatchQueue.main.async {
                    wait = waitContinuation()
                    semaphore.signal()
                }
                semaphore.wait()
                Thread.sleep(forTimeInterval: 0.01)
            }
            
            
            // 待機条件をクリアしたので通過後の処理を行います。
            DispatchQueue.main.async {
                compleation()
                
                
                
            }
        }
    }
    
    
}

