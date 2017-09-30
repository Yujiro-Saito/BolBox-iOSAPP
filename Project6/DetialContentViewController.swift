import UIKit
import Alamofire
import AlamofireImage
import SafariServices
import youtube_ios_player_helper

class DetialContentViewController: UIViewController {
    
    //Common
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    var imageURL: String!
    var name: String!
    var folderName: String!
    var type = Int()
    var videoKey = String()
    
    @IBOutlet weak var videoPlayer: YTPlayerView!
    @IBOutlet weak var itemTextBox: UITextView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray

        
        
        
        print(name)
        print(imageURL)
        print(folderName)
        print(type)
        print(videoKey)
        self.itemImage.isHidden = true
        self.itemName.isHidden = true
        self.videoPlayer.isHidden = true
        self.itemTextBox.isHidden = true
        
        self.itemImage.layer.cornerRadius = 15
        
        if self.type == 0 {
            self.itemImage.isHidden = false
            self.itemImage.af_setImage(withURL: URL(string: imageURL)!)
        } else if self.type == 1 {
            self.itemName.isHidden = false
            self.itemTextBox.isHidden = false
            self.itemName.text = name
            self.itemTextBox.text = "スマートフォンでスクリーンショットを撮る方法　スナップチャットでスクリーンショットを撮る方法は他のアプリと変わりませんが、素早く撮る必要があります。スナップチャットのスクリーンショットを撮ると相手に通知が送られるため、相手に知られても問題がないことを確認してから撮りましょう。スクリーンショットの撮り方はスマートフォンの機種によって異なります。"
            
        } else {
            if self.videoKey != "Fuck" && self.videoKey != "" {
                self.videoPlayer.isHidden = false
                videoPlayer.load(withVideoId: videoKey)
            }
            
        
        }
        
        
        
    }
    
    
    
    
   
    
    
    
    
    
    
    
    
    
}
