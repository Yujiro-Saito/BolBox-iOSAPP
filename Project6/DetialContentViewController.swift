//
//  DetialContentViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/23.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SafariServices

class DetialContentViewController: UIViewController {
    
    
    //Common
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemButton: UIButton!
    var imageURL: String!
    var name: String!
    
    
    @IBAction func actionDidTap(_ sender: Any) {
    }
    
    //App
    @IBOutlet weak var Desc: UILabel!
    var appDescription: String?
    var appLink: String?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(appDescription!)
        print(appLink!)
        
        let itemURL = URL(string: imageURL)
        itemName.text = self.name
        Desc.text = self.appDescription!
        itemImage.af_setImage(withURL: itemURL!)
        
        itemButton.addTarget(self, action: #selector(self.onClick(_:)), for: .touchUpInside)

    }
    
    
    func onClick(_ sender: AnyObject){
        
        
        
        
        let targetURL = self.appLink
        let encodedURL = targetURL?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        //URL正式
        guard let finalUrl = URL(string: encodedURL!) else {
            print("無効なURL")
            return
        }
        
        
        
        //opem safari
        
        
        if (encodedURL?.contains("https"))! || (encodedURL?.contains("http"))! {
            
            //httpかhttpsで始まってるか確認
            if (encodedURL?.hasPrefix("https"))! || (encodedURL?.hasPrefix("http"))! {
                //http(s)で始まってる場合safari起動
                let safariVC = SFSafariViewController(url: finalUrl)
                self.present(safariVC, animated: true, completion: nil)
                
            }
                //Httpsの場合
            else if let range = encodedURL?.range(of: "https") {
                let startPosition = encodedURL?.characters.distance(from: (encodedURL?.characters.startIndex)!, to: range.lowerBound)
                
                //4番目から最後までをURLとして扱う
                
                let indexNumber = startPosition
                
                let validURLString = (encodedURL?.substring(with: (encodedURL?.index((encodedURL?.startIndex)!, offsetBy: indexNumber!))!..<(encodedURL?.index((encodedURL?.endIndex)!, offsetBy: 0))!))
                
                let validURL = URL(string: validURLString!)
                
                
                //safari起動
                let safariVC = SFSafariViewController(url: validURL!)
                self.present(safariVC, animated: true, completion: nil)
                
                
            } else if let httpRange = encodedURL?.range(of: "http") {
                //Httpの場合
                let startPosition = encodedURL?.characters.distance(from: (encodedURL?.characters.startIndex)!, to: httpRange.lowerBound)
                
                //4番目から最後までをURLとして扱う
                
                let indexNumber = startPosition
                
                let validURLString = (encodedURL?.substring(with: (encodedURL?.index((encodedURL?.startIndex)!, offsetBy: indexNumber!))!..<(encodedURL?.index((encodedURL?.endIndex)!, offsetBy: 0))!))
                
                let validURL = URL(string: validURLString!)
                
                //safari起動
                let safariVC = SFSafariViewController(url: validURL!)
                self.present(safariVC, animated: true, completion: nil)
                
                
                
                
                
                
            }
                
            else {
            }
            
            
        } else {
            //そもそもhttp(s)がない場合
            print("無効なURL")
            //アラート表示
            let alertController = UIAlertController(title: "エラー", message: "URLが無効なようです", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) {
                (action) in
                self.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            
            
            
        }
        
        
        

        
        
    }
    
    
    

    

}
