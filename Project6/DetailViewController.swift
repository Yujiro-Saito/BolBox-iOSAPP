//
//  DetailViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/24.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage
import ImageSlideshow
import SafariServices

class DetailViewController: UIViewController {
    
    //Outlet
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailStarNum: UILabel!
    @IBOutlet weak var detailCategoryName: UILabel!
    @IBOutlet weak var detailWhatContent: UILabel!
    
    @IBOutlet weak var slideShow: ImageSlideshow!
    
    
    
    var name: String?
    var starNum: String?
    var categoryName: String?
    var whatContent: String?
    var imageURL: String?
    var detailImageOne: String?
    var detailImageTwo: String?
    var detailImageThree: String?
    var linkURL: String!
    
    var detailImageBox = [String]()
    var transScalable = CGAffineTransform()
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    var posts = [Post]()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        
        
    }
    
    
       
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        
        detailImage.af_setImage(withURL: URL(string: imageURL!)!)
        
        detailName.text = name
        detailStarNum.text = starNum
        detailCategoryName.text = categoryName
        detailWhatContent.text = whatContent
        
        
        
        let alamofireSource = [AlamofireSource(urlString: self.detailImageOne!)!, AlamofireSource(urlString: self.detailImageTwo!)!, AlamofireSource(urlString: self.detailImageThree!)!]
        
        
        self.slideShow.setImageInputs(alamofireSource)
        self.slideShow.contentScaleMode = .scaleAspectFill
        self.slideShow.slideshowInterval = 5
        self.slideShow.zoomEnabled = true
        self.slideShow.pageControlPosition = .hidden
        self.slideShow.activityIndicator = DefaultActivityIndicator()
        self.slideShow.activityIndicator = DefaultActivityIndicator(style: .whiteLarge, color: barColor)
        
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.didTap))
        slideShow.addGestureRecognizer(recognizer)
        
        
    }
    
    
    func didTap() {
        let fullScreenController = slideShow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            }
    
    
    
    
    
    @IBAction func goSeeTapped(_ sender: Any) {
        
        do {
            
            print(linkURL)
            let safariVC = SFSafariViewController(url: URL(string: linkURL!)!)
            self.present(safariVC, animated: true, completion: nil)
            
        } catch {
            
            //alert
            
            
            let alertController = UIAlertController(title: "エラー", message: "エラーが発生しました", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) {
                (action) in
                self.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            
        }

            
        }
        
        
        
    
    }
    
  
