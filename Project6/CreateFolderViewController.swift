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
        //self.view.bringSubview(toFront: createButton)
        
        
        
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
        
        // ナビゲーションを透明にする処理
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.hidesBarsOnSwipe = false
        
        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.camera, target: self, action: #selector(CreateFolderViewController.postDidTap))
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
    }
    
    func postDidTap() {
        
        if self.nameTextField.text != "" {
            performSegue(withIdentifier: "photo", sender: nil)
        } else {
            //alert
            let alertViewControler = UIAlertController(title: "フォルダ名", message: "タイトルを登録してください", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertViewControler.addAction(okAction)
            self.present(alertViewControler, animated: true, completion: nil)
        }
        
        
        
        
        
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
       /* if segue.identifier == "ToLink" {
            let linkVC = (segue.destination as? LinkPostViewController)!
            linkVC.folderName = self.nameTextField.text!
        } else if segue.identifier == "photos" {
            
            let photoVc = (segue.destination as? PhotoPostViewController)!
            
            photoVc.folderName = self.nameTextField.text!
            
            
        }*/
        
        if segue.identifier == "photo" {
            
            let designVC = (segue.destination as? PhotoPostViewController)!
            designVC.folderName = self.nameTextField.text!
            
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
