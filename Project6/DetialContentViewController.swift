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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
