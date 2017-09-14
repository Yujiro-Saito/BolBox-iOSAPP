//
//  CreateFolderViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/06.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import FirebaseAuth
import OnOffButton

class CreateFolderViewController: UIViewController,UITextFieldDelegate {
    
    
    
    
    
    let indicator = UIActivityIndicatorView()
    var folderBool = false
    
    func showIndicator() {
        
        indicator.activityIndicatorViewStyle = .whiteLarge
        
        indicator.center = self.view.center
        
        indicator.color = UIColor.white
        
        indicator.hidesWhenStopped = true
        
        self.view.addSubview(indicator)
        
        self.view.bringSubview(toFront: indicator)
        
        indicator.startAnimating()
        
    }
    
    
    
    @IBAction func cancelDidTap(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var cancel: UIButton!
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    
    let selectedFolderName = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.folderBool = false
        
        nameTextField.delegate = self
        self.view.bringSubview(toFront: createButton)
        
        
        
        //テキスト
        nameTextField.placeholder = "フォルダ名を入力"
        nameTextField.title = "フォルダ名"
        nameTextField.tintColor = UIColor.clear
        nameTextField.textColor = UIColor.white
        nameTextField.lineColor = UIColor.white
        nameTextField.selectedTitleColor = .white
        nameTextField.selectedLineColor = .white
        nameTextField.lineHeight = 1.0
        nameTextField.selectedLineHeight = 2.0

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(CreateFolderViewController.postDidTap))
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
    }
    
    func postDidTap() {
        
        let actionSheet = UIAlertController(title: "アクション", message: "フォルダの作成 写真 リンク", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let folder = UIAlertAction(title: "フォルダを作成", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            if self.nameTextField.text == "" {
                let alertViewControler = UIAlertController(title: "フォルダ名", message: "フォルダ名を入力してください", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertViewControler.addAction(okAction)
                self.present(alertViewControler, animated: true, completion: nil)
            } else if self.nameTextField.text != "" {
                //folderNameに投稿
                
                self.showIndicator()
                
                
                let currentUserUID = FIRAuth.auth()?.currentUser?.uid
                let folderName = self.nameTextField.text
                let folderDictionay = ["imageURL" : "" , "name" : folderName!]
                
                let folderInfoDict: Dictionary<String, Dictionary<String, String?>> = [folderName! : folderDictionay]
                
                
                
                
                
                DispatchQueue.main.async {
                    
                    
                    DataService.dataBase.REF_BASE.child("users/\(currentUserUID!)/folderName").updateChildValues(folderInfoDict)
                    
                    self.folderBool = true
                    
                    self.indicator.stopAnimating()
                }
                
                
                
                
                
                self.wait( {self.folderBool == false} ) {
                    
                    
                    
                    
                    
                    DispatchQueue.main.async {
                        self.folderBool = false
                        self.performSegue(withIdentifier: "GoBAcckingh", sender: nil)
                    }
                    
                    
                    
                    
                    
                    
                }
                
                
                
                
                
                
            }
            
            
            
        })
        
        let photo = UIAlertAction(title: "写真を追加する", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            if self.nameTextField.text == "" {
                let alertViewControler = UIAlertController(title: "フォルダ名", message: "フォルダ名を入力してください", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertViewControler.addAction(okAction)
                self.present(alertViewControler, animated: true, completion: nil)
            } else if self.nameTextField.text != "" {
                
                self.performSegue(withIdentifier: "photos", sender: nil)
            }
            
            
            
        })
        
        let link = UIAlertAction(title: "リンクを追加する", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            if self.nameTextField.text == "" {
                let alertViewControler = UIAlertController(title: "フォルダ名", message: "フォルダ名を入力してください", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertViewControler.addAction(okAction)
                self.present(alertViewControler, animated: true, completion: nil)
            } else if self.nameTextField.text != "" {
                self.performSegue(withIdentifier: "ToLink", sender: nil)
            }
            
        })
        
        
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
        })
        
        actionSheet.addAction(folder)
        actionSheet.addAction(photo)
        actionSheet.addAction(link)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
        

        
        
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nameTextField.resignFirstResponder()
        
        return true
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToLink" {
            let linkVC = (segue.destination as? LinkPostViewController)!
            linkVC.folderName = self.nameTextField.text!
        } else if segue.identifier == "photos" {
            
            let photoVc = (segue.destination as? PhotoPostViewController)!
            
            photoVc.folderName = self.nameTextField.text!
            
            
        }
        
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
