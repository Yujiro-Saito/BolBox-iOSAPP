//
//  YoutubeFindViewController.swift
//  
//
//  Created by  Yujiro Saito on 2017/09/27.
//
//

import UIKit
import Alamofire
import AlamofireImage

class YoutubeFindViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var sTable: UITableView!
    
    var searchURL = String()
    var titleBox = [String]()
    var thumbnailURLBox = [String]()
    var videoIDBox = [String]()
    
    
    var selectedFolder = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.delegate = self
        sTable.delegate = self
        sTable.dataSource = self
        searchField.enablesReturnKeyAutomatically = false
        
        
        searchField.placeholder = "Youtubeを検索"
        
        searchField.disableBlur()
        searchField.backgroundColor = UIColor.clear
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        
        
        
        
        
        /*
        mySearchBar = UISearchBar()
        mySearchBar.delegate = self
        mySearchBar.frame = CGRect(x:0, y: 0,width: self.view.frame.size.width,height: 44)
        mySearchBar.layer.position = CGPoint(x: self.view.bounds.width/2, y: 32)
        mySearchBar.tintColor = UIColor.black
        mySearchBar.barTintColor = UIColor.red
        mySearchBar.placeholder = "Youtubeを検索"
        
        self.navigationItem.titleView = mySearchBar
 
 */
        
        
        
    }
    
    var selectedImageURL = String()
    var selctedTitle = String()
    var videoKey = String()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedImageURL = thumbnailURLBox[indexPath.row]
        self.selctedTitle = titleBox[indexPath.row]
        self.videoKey = videoIDBox[indexPath.row]
        
        
        performSegue(withIdentifier: "GoHellToge", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let postVC = (segue.destination as? YoutubePostViewController)!
        
        postVC.imageURL = self.selectedImageURL
        postVC.titleString = self.selctedTitle
        postVC.videoCode = self.videoKey
        postVC.folderName = self.selectedFolder
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleBox.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sTable.dequeueReusableCell(withIdentifier: "GoHell", for: indexPath) as? YoutubeTableViewCell
        
        cell?.itemIMage.image = nil
        tableView.tableFooterView = UIView()
        cell?.videoTitle.text = self.titleBox[indexPath.row]
        
        DispatchQueue.main.async {
            
            cell?.itemIMage.af_setImage(withURL: URL(string: self.thumbnailURLBox[indexPath.row])!)
            
            
            
        }
        
        
        return cell!
        
        
    }
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let searchText = searchField.text
        
        let enocodedText = searchText!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.searchURL = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyB2oGwTctsfRWNPQ-d1kUvtFzOUXhN9Z0w&q=\(enocodedText!)&part=id,snippet&maxResults=20&order=viewCount"
            
            let finalKeyWord = self.searchURL.replacingOccurrences(of: " ", with: "+")
            
           self.callAlamo(url: finalKeyWord)
        }
        
        return true
        
        
    }
    
    //検索ボタン押下時の呼び出しメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchField.resignFirstResponder()
        
    }
    
    func callAlamo(url: String) {
        
        
        Alamofire.request(url).response { (response) in
            self.parseData(JsonData: response.data!)
        }
        
        
    }

    func parseData(JsonData: Data) {
        
        
        self.titleBox = []
        self.thumbnailURLBox = []
        self.videoIDBox = []
        
        do {
            
            var readableJSON = try JSONSerialization.jsonObject(with: JsonData, options: .mutableContainers) as! jsonFormat
            
            
            
             if let items = readableJSON["items"] as? [jsonFormat] {
                
                for a in 0..<items.count {
                    
                    let item = items[a]
                    
                    //videoID
                    if let videoID = item["id"] as? Dictionary<String,AnyObject> {
                        
                       let id = videoID["videoId"] as? String
                       
                        if id != nil {
                            
                            self.videoIDBox.append(id!)
                        } else if id == nil {
                            self.videoIDBox.append("")
                        }
                        
                        
                    }
                    
                    //Title
                    if let videoInfo = item["snippet"] as? Dictionary<String,AnyObject> {
                        
                        
                        let title = videoInfo["title"] as? String
                        
                        if title != nil {
                            
                            self.titleBox.append(title!)
                        }
                        
                        //Image
                        if let imageURL = videoInfo["thumbnails"] as? Dictionary<String,AnyObject> {
                            
                            let imageIt = imageURL["high"] as? Dictionary<String,AnyObject>
                            
                            let finalImage = imageIt?["url"] as? String
                            
                            if finalImage != nil {
                                
                                self.thumbnailURLBox.append(finalImage!)
                            }
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                }
                
                
                
            }
            
            
            print("ああああああああああいいいいいいいいいいいいうううううううう")
            print(self.titleBox)
            print(self.thumbnailURLBox)
            print(self.videoIDBox)
            
            
            self.sTable.reloadData()
            
            
            
        }
           
            
            
        
            
            
        catch {
            //print(error)
            
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            
            self.titleBox.removeAll()
            self.thumbnailURLBox.removeAll()
            self.videoIDBox.removeAll()

            
        }
        
        
        
    }
    
    

    typealias jsonFormat = [String : Any]
    
    
}
extension UISearchBar {
     func disableBlur() {
        backgroundImage = UIImage()
        isTranslucent = true
    }
}
