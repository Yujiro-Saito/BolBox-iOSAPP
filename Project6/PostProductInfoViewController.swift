//
//  PostProductInfoViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/21.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class PostProductInfoViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var scrolling: UIScrollView!
    
    @IBOutlet weak var productNameField: SkyFloatingLabelTextField!
   // @IBOutlet weak var urlField: SkyFloatingLabelTextField!
    @IBOutlet weak var categoryField: SkyFloatingLabelTextField!
    
    
    let selectPicker = UIPickerView()
    var categoryBox = ["カテゴリーを選択してください","アプリ","メディア","ゲーム", "教育・キャリア"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //名前テキスト
        productNameField.placeholder = "紹介する物の名前"
        productNameField.title = "名前"
        productNameField.tintColor = barColor
        productNameField.textColor = UIColor.darkGray
        productNameField.lineColor = UIColor.lightGray
        productNameField.selectedTitleColor = barColor
        productNameField.selectedLineColor = barColor
        productNameField.lineHeight = 1.0 // bottom line height in points
        productNameField.selectedLineHeight = 2.0
        
        
        
        
        //カテゴリテキスト
        categoryField.placeholder = "カテゴリーを選択してください"
        categoryField.title = "カテゴリー"
        categoryField.tintColor = barColor
        categoryField.textColor = UIColor.darkGray
        categoryField.lineColor = UIColor.lightGray
        categoryField.selectedTitleColor = barColor
        categoryField.selectedLineColor = barColor
        categoryField.lineHeight = 1.0 // bottom line height in points
        categoryField.selectedLineHeight = 2.0
        
        
        selectPicker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: selectPicker.bounds.size.height)
        selectPicker.delegate   = self
        selectPicker.dataSource = self
        
        productNameField.delegate = self
        categoryField.delegate = self
        
        let vi = UIView(frame: selectPicker.bounds)
        vi.backgroundColor = UIColor.white
        vi.addSubview(selectPicker)
        
        categoryField.inputView = vi
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        
        let doneButton   = UIBarButtonItem(title: "完了", style: UIBarButtonItemStyle.done, target: self, action: #selector(PostProductInfoViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: UIBarButtonItemStyle.plain, target: self, action: #selector(PostProductInfoViewController.cancelPressed))
        let spaceButton  = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        categoryField.inputAccessoryView = toolBar
        
    }
    
    // Done
    func donePressed() {
        
        view.endEditing(true)
    }
    
    // Cancel
    func cancelPressed() {
        categoryField.text = ""
        view.endEditing(true)
    }
    
    
    @IBAction func continueButtonDidTap(_ sender: Any) {
        
            if categoryField.text == "アプリ" || categoryField.text == "メディア" || categoryField.text == "ゲーム" || categoryField.text == "教育・キャリア"  {
                
                if productNameField.text != "" {
                    performSegue(withIdentifier: "ToContinue", sender: nil)
                } else {
                    
                    let alertViewControler = UIAlertController(title: "エラーがあります", message: "必要なフィールドを埋めてください", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alertViewControler.addAction(okAction)
                    self.present(alertViewControler, animated: true, completion: nil)
                    
                }
            
            
           }
           
           else {
            
            let alertViewControler = UIAlertController(title: "エラーがあります", message: "必要なフィールドを埋めてください", preferredStyle: .alert)
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
            postImageArea.productCategory = categoryField.text!
            
            
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    }
    
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryBox.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryBox[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryField.text = categoryBox[row]
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        categoryField.resignFirstResponder()
        productNameField.resignFirstResponder()
        
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
