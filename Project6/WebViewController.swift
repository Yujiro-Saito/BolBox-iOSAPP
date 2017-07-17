//
//  WebViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/16.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class WebViewController: UIViewController,UIWebViewDelegate,UINavigationBarDelegate {

    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    
    var postUrl: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        // Delegate設定
        webView.delegate = self
        navBar.delegate = self
        
        // インスタンスをビューに追加する
        self.view.addSubview(webView)
        
        
        // URLを指定
        let url: URL = URL(string: postUrl)!
        let request: URLRequest = URLRequest(url: url)
        
        // リクエストを投げる
        webView.loadRequest(request)
        
        //バーの高さ
        self.navBar.frame = CGRect(x: 0,y: 607, width: UIScreen.main.bounds.size.width, height: 60)
        self.view.bringSubview(toFront: navBar)
        
        


    }
    
    @IBAction func close(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        
        self.webView.goBack()

    }
    
    @IBAction func goForward(_ sender: Any) {
        
        self.webView.goForward()

    }
   
    
    
    // ロード時にインジケータをまわす
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("indicator on")
    }
    
    // ロード完了でインジケータ非表示
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        print("indicator off")
    }

  
}
