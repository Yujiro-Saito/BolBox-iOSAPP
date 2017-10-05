import UIKit
import Alamofire
import AlamofireImage
import SafariServices
import youtube_ios_player_helper

class DetialContentViewController: UIViewController,UIWebViewDelegate {
    
    //Common
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    var imageURL: String!
    var name: String!
    var folderName: String!
    var type = Int()
    var videoKey = String()
    var linkURL = String()
    
    @IBOutlet weak var videoPlayer: YTPlayerView!
    @IBOutlet weak var itemTextBox: UITextView!
    
    @IBOutlet weak var webViewing: UIWebView!
    
    @IBOutlet weak var paginView: UIView!
    @IBAction func baking(_ sender: Any) {
        
        webViewing.goBack()
    }
    @IBAction func goIng(_ sender: Any) {
        webViewing.goForward()
    }
    
    // ロード時にインジケータをまわす
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    // ロード完了でインジケータ非表示
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    func safariTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let safari = UIAlertAction(title: "Safariで開く", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            
            print("いいいいいいいいいいいあああああああああああ")
            print(self.linkURL)
            let targetURL = self.linkURL
            let encodedURL = targetURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            
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
            
            
            
            
            
        })
        
        let report = UIAlertAction(title: "不審な投稿として報告", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            
            
        })
        
        
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
        })
        
        actionSheet.addAction(safari)
        actionSheet.addAction(report)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if self.imageURL != "" {
            
            if self.videoKey != "" {
                let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(DetialContentViewController.safariTapped))
                self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
            }
            
        } else if linkURL != "" {
            let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(DetialContentViewController.safariTapped))
            self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        }
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        self.navigationController?.hidesBarsOnSwipe = false

        webViewing.delegate = self
        webViewing.scalesPageToFit = true
        
        
        
        self.itemImage.isHidden = true
        self.itemName.isHidden = true
        self.videoPlayer.isHidden = true
        self.itemTextBox.isHidden = true
        self.paginView.isHidden = true
        self.webViewing.isHidden = true
        
        
        
        self.itemImage.layer.cornerRadius = 15
        
        if self.type == 0 {
            
            self.itemImage.isHidden = false
            self.itemImage.af_setImage(withURL: URL(string: imageURL)!)
        } else if self.type == 1 {
            
            
            
            self.itemImage.isHidden = true
            
            self.itemName.isHidden = true
            self.itemTextBox.isHidden = true
            
            self.paginView.isHidden = false
            self.webViewing.isHidden = false
            
            let linkURLweb = linkURL
            let favoriteURL = NSURL(string: linkURLweb)
            
            let urlRequest = NSURLRequest(url: favoriteURL! as URL)
            
            webViewing.loadRequest(urlRequest as URLRequest)
            
            
            
            
            
        } else {
            
            
            if self.videoKey != "Fuck" && self.videoKey != "" {
                self.videoPlayer.isHidden = false
                videoPlayer.load(withVideoId: videoKey)
            }
            
        
        }
        
        
        
    }
    
    
    
    
   
    
    
    
    
    
    
    
    
    
}
