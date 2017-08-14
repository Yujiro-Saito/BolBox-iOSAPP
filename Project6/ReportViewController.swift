//
//  ReportViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/08/14.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import OnOffButton

class ReportViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var MessageText: UILabel!
    @IBOutlet weak var checkButton: OnOffButton!
    var isPostDone = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        self.checkButton.isHidden = true
        self.checkButton.checked = false
        self.MessageText.isHidden = true
        
        
        reportText.delegate = self
       
        
        //メールアドレス
        reportText.placeholder = "具体的な投稿内容やユーザー名など"
        reportText.title = "報告"
        reportText.tintColor = barColor
        reportText.textColor = UIColor.darkGray
        reportText.lineColor = UIColor.lightGray
        reportText.selectedTitleColor = barColor
        reportText.selectedLineColor = barColor
        reportText.lineHeight = 1.0
        reportText.selectedLineHeight = 2.0


    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        reportText.resignFirstResponder()
        
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
    
    @IBOutlet weak var infoLabel: UILabel!
    
    
    @IBOutlet weak var reportText: SkyFloatingLabelTextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var sendButton: RegisterButton!
    
    
    @IBAction func sendButtonDidTap(_ sender: Any) {
        
        
        if reportText.text != "" && reportText.text != nil {
            
            showIndicator()
            
            //FBに送信
            //Emailアドレス(あれば)、ユーザー名、テキストの内容
            
           
            
                
                
                DispatchQueue.main.async {
                    print("おおおおおおおお")
                    
                    let currentUserName = FIRAuth.auth()?.currentUser?.displayName
                    let currentUserEmail = FIRAuth.auth()?.currentUser?.email
                    
                    
                    let reportData = ["userName" : currentUserName, "Email" : currentUserName, "reportContent" : self.reportText.text]
                    
                    DataService.dataBase.REF_BASE.child("reports/\(currentUserName)").setValue(reportData)
                    
                    self.isPostDone = true
                    
                    self.indicator.stopAnimating()
                    print("投稿を完了しました")
                }
            
            
            
                
            
                
            

                
                //チェックを確認してから遷移
                self.wait( {self.isPostDone == false} ) {
                    
                    
                    
                    //チェック以外のUIを隠す
                    self.reportText.isHidden = true
                    self.backButton.isHidden = true
                    self.sendButton.isHidden = true
                    
                    
                    //チェックつける
                    self.MessageText.isHidden = false
                    self.infoLabel.isHidden = true
                    
                    self.checkButton.isHidden = false
                    self.checkButton.checked = true
                    
                    self.isPostDone = false
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.performSegue(withIdentifier: "reportDone", sender: nil)
                    }
                    
                    
                    
                    
                }
                
                
                
                
                
                
            
            
            
            

        } else {
            let alertViewControler = UIAlertController(title: "エラーがあります", message: "必要なフィールドを埋めてください", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertViewControler.addAction(okAction)
            self.present(alertViewControler, animated: true, completion: nil)
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

    let indicator = UIActivityIndicatorView()
    
    func showIndicator() {
        
        indicator.activityIndicatorViewStyle = .whiteLarge
        
        indicator.center = self.view.center
        
        indicator.color = UIColor.rgb(r: 31, g: 158, b: 187, alpha: 1)
        
        indicator.hidesWhenStopped = true
        
        self.view.addSubview(indicator)
        
        self.view.bringSubview(toFront: indicator)
        
        indicator.startAnimating()
        
        
        
        
    }
    
    

    
    


}
