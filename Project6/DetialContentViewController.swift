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
import AVFoundation


class DetialContentViewController: UIViewController {
    
    var player: AVAudioPlayer!
    //Common
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemButton: UIButton!
    @IBOutlet weak var itemSecondButton: UIButton!
    var imageURL: String!
    var name: String!
    var folderName: String!
    
    
    @IBAction func actionDidTap(_ sender: Any) {
    }
    
    //App
    @IBOutlet weak var Desc: UILabel!
    var appDescription: String?
    var appLink: String?
    
    
    //Muaic
    var previewURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isFirst = true
        
        self.itemSecondButton.isHidden = true
        
        if self.folderName == "App" {
            
            let itemURL = URL(string: imageURL)
            itemName.text = self.name
            Desc.text = self.appDescription!
            itemImage.af_setImage(withURL: itemURL!)
            
            itemButton.setTitle("インストール", for: .normal)
            itemButton.addTarget(self, action: #selector(self.onClick(_:)), for: .touchUpInside)

            
        } else if self.folderName == "Music" {
            
            
            
            self.itemButton.setTitle("再生", for: .normal)
            
            
            
            itemButton.addTarget(self, action: #selector(self.musicPlay(_:)), for: .touchUpInside)
            itemSecondButton.addTarget(self, action: #selector(self.stop(_:)), for: .touchUpInside)
            let itemURL = URL(string: imageURL)
            itemName.text = self.name
            itemImage.af_setImage(withURL: itemURL!)
            Desc.isHidden = true
            
        }
        
        
    }
    
    var isFirst = true
    
    func stop(_ sender: AnyObject){
        player.pause()
        
        self.itemSecondButton.isHidden = true
        self.itemButton.isHidden = false
        
    }
    
    
    func musicPlay(_ sender: AnyObject){
        
        self.itemButton.isHidden = true
        self.itemSecondButton.isHidden = false
        self.itemSecondButton.setTitle("停止", for: .normal)
        
        let linkk = URL(string: self.previewURL!)
        
        if self.isFirst == true {
            downloadFileFromURL(url: linkk!)
        } else {
            
            player.prepareToPlay()
            player.play()
        }
        
        
       
        
        
        
    }
    
    func downloadFileFromURL(url: URL){
        
        isFirst = false
        
        var downloadTask = URLSessionDownloadTask()
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {
            customURL, response, error in
            
            self.play(url: customURL!)
            
        })
        
        downloadTask.resume()
        
        
            

    }
    
    
    func play(url: URL) {
        
        do {
            
                
            
                player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                player.play()
                
            
            
            
           
            
        }
        catch{
            print(error)
        }
        
        
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
