//
//  DetailViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/24.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import ImageSlideshow

class DetailViewController: UIViewController {
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    let localSource = [ImageSource(imageString: "img1")!, ImageSource(imageString: "img2")!, ImageSource(imageString: "img3")!, ImageSource(imageString: "img4")!]
    
    let alamofireSource = [AlamofireSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!, AlamofireSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!, AlamofireSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.slideshow.setImageInputs(alamofireSource)
        self.slideshow.contentScaleMode = .scaleAspectFill
        self.slideshow.slideshowInterval = 5
        self.slideshow.zoomEnabled = true
        self.slideshow.pageControlPosition = .hidden
        self.slideshow.activityIndicator = DefaultActivityIndicator(style: .whiteLarge, color: .black)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.didTap))
        slideshow.addGestureRecognizer(recognizer)

    }
    
    func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller; skip the line if no activity indicator should be shown
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }


   

}
