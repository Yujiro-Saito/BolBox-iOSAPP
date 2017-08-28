//
//  PostProductInfoViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/21.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class PostProductInfoViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var productNameField: SkyFloatingLabelTextField!
    @IBOutlet weak var productURLField: SkyFloatingLabelTextField!
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //名前テキスト
        productNameField.placeholder = "追加するものの名前"
        productNameField.title = "Name"
        productNameField.tintColor = barColor
        productNameField.textColor = UIColor.darkGray
        productNameField.lineColor = UIColor.lightGray
        productNameField.selectedTitleColor = barColor
        productNameField.selectedLineColor = barColor
        productNameField.lineHeight = 1.0 // bottom line height in points
        productNameField.selectedLineHeight = 2.0
        
        
        //URLテキスト
        productURLField.placeholder = "URL(あればで可)"
        productURLField.title = "URL"
        productURLField.tintColor = barColor
        productURLField.textColor = UIColor.darkGray
        productURLField.lineColor = UIColor.lightGray
        productURLField.selectedTitleColor = barColor
        productURLField.selectedLineColor = barColor
        productURLField.lineHeight = 1.0 // bottom line height in points
        productURLField.selectedLineHeight = 2.0
        
        //デリゲート
        productNameField.delegate = self
        productURLField.delegate = self
        
       
        
    }
    
    
    
    
    @IBAction func continueButtonDidTap(_ sender: Any) {
        
        
                //名前があれば画面遷移 URLはOptional
                if productNameField.text != "" {
                    performSegue(withIdentifier: "ToContinue", sender: nil)
                } else {
                    
                    let alertViewControler = UIAlertController(title: "エラーがあります", message: "名前を登録してください", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alertViewControler.addAction(okAction)
                    self.present(alertViewControler, animated: true, completion: nil)
                    
                }
        
        
        
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToContinue") {
            
            let postImageArea = (segue.destination as? PostProductPhotosViewController)!
            
            
            postImageArea.productName = productNameField.text!
            
            //URLがもしあればを送る
            if self.productURLField.text != nil && self.productURLField.text != ""  {
                postImageArea.productUrl = self.productURLField.text
            }
            
            
        }
    }
    
    
    
    
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        productNameField.resignFirstResponder()
        productURLField.resignFirstResponder()
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
    
    
    
   
  
  

}
