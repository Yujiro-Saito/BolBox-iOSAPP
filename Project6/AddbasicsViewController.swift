//
//  AddbasicsViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/09/22.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class AddbasicsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    
    @IBOutlet weak var tableing: UITableView!
    
    @IBOutlet weak var searchBaraai: UISearchBar!
    
    var postType: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        tableing.delegate = self
        tableing.dataSource = self
        
        
        
        
        searchBaraai.delegate = self
        
        //何も入力されていなくてもReturnキーを押せるようにする。
        searchBaraai.enablesReturnKeyAutomatically = false

    }

    
    var uiri = String()
  
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let searchText = searchBaraai.text
        
        let enocodedText = searchText?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            //typeによってURL切り替え
            
            if self.postType == 0 {
                //app
                 self.uiri = "https://itunes.apple.com/search?term=\(enocodedText!)&country=JP&lang=ja_jp&entity=software&limit=10"
            } else if self.postType == 1 {
                self.uiri = "https://itunes.apple.com/search?term=\(enocodedText!)&country=JP&lang=ja_jp&media=music&limit=30"
            } else if self.postType == 2 {
                self.uiri = "https://itunes.apple.com/search?term=\(enocodedText!)&entity=movie&country=JP&limit=30"
            } else if self.postType == 3 {
            }
            
            
            
            
            let finalKeyWord = self.uiri.replacingOccurrences(of: " ", with: "+")
            
            self.callAlamo(url: finalKeyWord)
            
        }
        
        return true
        
        
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            print("uuuuue")
            self.trackNames.removeAll()
            self.imageURLBox.removeAll()
            self.tableing.reloadData()
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = self.tableing.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? BaseItemSearchTableViewCell
        tableView.tableFooterView = UIView()
        
        cell?.itemName?.text = trackNames[indexPath.row]
        
        //cell?.artist.text = self.artistNames[indexPath.row]
        
        //let urll = self.imageURLBox[indexPath.row]
        //let urlCha = URL(string: urll)
        
        //cell?.musicaimage.af_setImage(withURL: urlCha!)
        
        
        
        return cell!
    }
    
    
    //var urling = "https://itunes.apple.com/search?term=jack+johnson&limit=15"
    
    func callAlamo(url: String) {
        
        Alamofire.request(url).response { (response) in
            
            self.parseData(JsonData: response.data!)
            
            
        }
        
        
    }
    
    //共通
    var trackNames = [String]()
    var imageURLBox = [String]()
    var totalLinkBox = [String]()
    
    //app
    //var appLinks = [String?]()
    var appDescs = [String?]()
    
    //music
    var artistNames = [String?]()
    var previewUrls = [String?]()
    
    typealias jsonFormat = [String : Any]
    
    func parseData(JsonData: Data) {
        
        
        self.trackNames = []
        self.previewUrls = []
        self.imageURLBox = []
        self.artistNames = []
        self.appDescs = []
        self.totalLinkBox = []
        
        
        do {
            
            var readableJSON = try JSONSerialization.jsonObject(with: JsonData, options: .mutableContainers) as! jsonFormat
            
            if let songs = readableJSON["results"] as? [jsonFormat] {
                
                //print(apps)
                for a in 0..<songs.count {
                    
                    let song = songs[a]
                    
                    
                    
                    //APP
                    if self.postType == 0 {
                        
                        //Links
                        if let appLinkURL = song["trackViewUrl"] as? String {
                            
                            
                            totalLinkBox.append(appLinkURL)
                        }
                        
                        //app Ori
                        if let appDesc = song["description"] as? String {
                            
                            
                            appDescs.append(appDesc)
                        }
                        
                        //Name
                        if let title = song["trackName"] as? String {
                            
                            
                            trackNames.append(title)
                            print(trackNames)
                        }
                        
                        
                        //IMG
                        if let imageURL = song["artworkUrl100"] as? String {
                            
                            
                            
                            imageURLBox.append(imageURL)
                            print(imageURLBox)
                        }
                        
                        
                        
                        
                        
                        
                    }
                    
                    else if self.postType == 1 {
                       //Music
                        
                        
                        //Name
                        if let title = song["trackName"] as? String {
                            
                            
                            trackNames.append(title)
                            print(trackNames)
                        }
                        
                        //Music Ori
                        if let preLink = song["previewUrl"] as? String {
                            
                            
                            previewUrls.append(preLink)
                            print(previewUrls)
                        }
                        
                        
                        //IMG
                        if let imageURL = song["artworkUrl100"] as? String {
                            
                            
                            
                            imageURLBox.append(imageURL)
                            print(imageURLBox)
                        }
                        
                        
                        //Link
                        if let link = song["collectionViewUrl"] as? String {
                            
                            
                            totalLinkBox.append(link)
                            print(previewUrls)
                        }
                        
                        
                        //Music Ori
                        if let artistName = song["artistName"] as? String {
                            
                            artistNames.append(artistName)
                            
                            
                        }
                        
                        
                        
                        
                    } else if self.postType == 2 {
                        
                        
                        //Name
                        if let title = song["trackName"] as? String {
                            
                            
                            trackNames.append(title)
                        }
                        
                        
                        //Link
                        if let link = song["trackViewUrl"] as? String {
                            
                            
                            totalLinkBox.append(link)
                        }
                        
                        //IMG
                        if let imageURL = song["artworkUrl100"] as? String {
                            
                            
                            
                            imageURLBox.append(imageURL)
                        }
                        
                        
                        
                        
                        //監督名
                        if let artistName = song["artistName"] as? String {
                            
                            artistNames.append(artistName)
                            
                            
                        }

                        //Desc
                        if let desc = song["longDescription"] as? String {
                            
                            
                            appDescs.append(desc)
                        }
                        
                        
                        
                        
                    }
                    
                   
                    
                    
                }
                
            }
            
            
            
            //self.trackNames.reverse()
            //self.imageURLBox.reverse()
            //self.artistNames.reverse()
            //self.appLinks.reverse()
            //self.appDescs.reverse()
            

            
            self.tableing.reloadData()
            
            
            
            
            
        } catch {
            //print(error)
            
        }
        
        
        
        
    }
    //検索ボタン押下時の呼び出しメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBaraai.resignFirstResponder()
        
    }
    
    
    
    
    var trackName: String!
    var trackImageURL: String!
    var accessLink: String!
    
    
    var trackDesc: String!

    var previewUrlAi: String!
    var artistName: String!
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        trackName = self.trackNames[indexPath.row]
        trackImageURL = self.imageURLBox[indexPath.row]
        accessLink = self.totalLinkBox[indexPath.row]
        
        
       
        
        
        
        
        if self.postType == 0 {
            
            
            if self.appDescs[indexPath.row] != nil {
                trackDesc = self.appDescs[indexPath.row]
            }
            
            
            performSegue(withIdentifier: "goingHell", sender: nil)
            

        } else if self.postType == 1 {
            
            if self.previewUrls[indexPath.row] != nil {
                previewUrlAi = self.previewUrls[indexPath.row]
            }
            
            if self.artistNames[indexPath.row] != nil {
                
                artistName = self.artistNames[indexPath.row]
            }
            
            
            performSegue(withIdentifier: "goingHell", sender: nil)
            
        }  else if self.postType == 2 {
            
            
            
            if self.appDescs[indexPath.row] != nil {
                trackDesc = self.appDescs[indexPath.row]
            }
            
            if self.artistNames[indexPath.row] != nil {
                
                artistName = self.artistNames[indexPath.row]
            }

            
            performSegue(withIdentifier: "goingHell", sender: nil)
            
            
        }
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goingHell" {
            
            let basePostVC = (segue.destination as? BasicPostViewController)!
            
            basePostVC.trackName = trackName
            basePostVC.imageURL = trackImageURL
            basePostVC.previewUrl = previewUrlAi
            basePostVC.artistName = artistName
            basePostVC.accessLink = accessLink
            basePostVC.trackDesc = trackDesc
        
            
            if self.postType == 0 {
                basePostVC.folderName = "bstart"
                basePostVC.postingSitu = 0
                
            } else if self.postType == 1 {
                basePostVC.folderName = "dStart"
                basePostVC.postingSitu = 1
            } else if self.postType == 2 {
                basePostVC.folderName = "cstart"
                basePostVC.postingSitu = 2
            }
            
            
            

            
            
            
            
        }
    }

    
    
    
    
    
    
    
    

}
