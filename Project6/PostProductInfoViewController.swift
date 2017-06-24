//
//  PostProductInfoViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/21.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class PostProductInfoViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var categoryField: SignUpField!
    @IBOutlet weak var productNameField: SignUpField!
    @IBOutlet weak var urlField: SignUpField!
    let selectPicker = UIPickerView()
    var categoryBox = ["テクノロジー", "デザイン・アート", "教育・キャリア", "買い物", "ゲーム"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectPicker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: selectPicker.bounds.size.height)
        selectPicker.delegate   = self
        selectPicker.dataSource = self
        
        productNameField.delegate = self
        categoryField.delegate = self
        urlField.delegate = self
        
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
        
        
        performSegue(withIdentifier: "ToContinue", sender: nil)
        
        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToContinue") {
            
            let postImageArea = (segue.destination as? PostProductPhotosViewController)!
            
            
            postImageArea.productName = productNameField.text!
            postImageArea.productURL = urlField.text!
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
        print("tapped")
        self.categoryField.text = categoryBox[row]
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        categoryField.resignFirstResponder()
        productNameField.resignFirstResponder()
        urlField.resignFirstResponder()
        
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
