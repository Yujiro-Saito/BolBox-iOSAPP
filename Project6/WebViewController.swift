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
    
    var postUrl: String?
    
    
    
    

    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        print("エラー")
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(postUrl!)
        
        // Delegate設定
        webView.delegate = self
        navBar.delegate = self
        
        
        
        // インスタンスをビューに追加する
        self.view.addSubview(webView)
        
        
        
        
        if postUrl == "" {
            print("リンクがない")
            
            
        } else {
            
            
            let url: URL? = URL(string: postUrl!)!
            
            let request: URLRequest? = URLRequest(url: url!)
            
             webView.loadRequest(request!)
            
           
        }
        
        
        

        
        
        //バーの高さ
        self.navBar.frame = CGRect(x: 0,y: 607, width: UIScreen.main.bounds.size.width, height: 60)
        self.view.bringSubview(toFront: navBar)
        
    }
    
    
    
    
    @IBAction func close(_ sender: Any) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.webView.stopLoading()
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            
            
            var title = self.webView.stringByEvaluatingJavaScript(from: "document.title")
            
            if title == "" || title == nil {
                
                //10秒たっても読み込めない場合
                self.webView.stopLoading()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                let alertViewControler = UIAlertController(title: "失敗", message: "読み込みに失敗したようです", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertViewControler.addAction(okAction)
                self.present(alertViewControler, animated: true, completion: nil)
            }
            
            
            
            
        
            
            
        }
        
        
        
    }
    
    // ロード完了でインジケータ非表示
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        print("indicator off")
        
        
        
        
        
        
        
        
    }

  
}
