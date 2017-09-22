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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableing.delegate = self
        tableing.dataSource = self
        
        
        
        
        searchBaraai.delegate = self
        
        //何も入力されていなくてもReturnキーを押せるようにする。
        searchBaraai.enablesReturnKeyAutomatically = false

    }

  
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let searchText = searchBaraai.text
        
        let enocodedText = searchText?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("aaaaai")
            
            
            //music
            //let uiri = "https://itunes.apple.com/search?term=\(enocodedText!)&country=JP&lang=ja_jp&media=music&limit=30"
            
            //app
            let uiri = "https://itunes.apple.com/search?term=\(enocodedText!)&country=JP&lang=ja_jp&entity=software&limit=10"
            
            let finalKeyWord = uiri.replacingOccurrences(of: " ", with: "+")
            
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
    
    var trackNames = [String]()
    var previewUrls = [String?]()
    var imageURLBox = [String]()
    var artistNames = [String?]()
    var appLinks = [String?]()
    var appDescs = [String?]()
    
    
    typealias jsonFormat = [String : Any]
    
    func parseData(JsonData: Data) {
        
        
        self.trackNames = []
        self.previewUrls = []
        self.imageURLBox = []
        self.artistNames = []
        self.appLinks = []
        self.appDescs = []
        
        do {
            
            var readableJSON = try JSONSerialization.jsonObject(with: JsonData, options: .mutableContainers) as! jsonFormat
            
            if let songs = readableJSON["results"] as? [jsonFormat] {
                
                //print(apps)
                for a in 0..<songs.count {
                    
                    let song = songs[a]
                    //print(app)
                    
                    //"trackViewUrl"
                    //description
                    
                    //app ori
                    if let appLinkURL = song["trackViewUrl"] as? String {
                        
                        
                        appLinks.append(appLinkURL)
                    }
                    
                    //app ori
                    if let appDesc = song["description"] as? String {
                        
                        
                        appDescs.append(appDesc)
                    }
                    
                    
                    if let title = song["trackName"] as? String {
                        
                        
                        trackNames.append(title)
                        print(trackNames)
                    }
                    
                    
                    if let link = song["previewUrl"] as? String {
                        
                        
                        previewUrls.append(link)
                        print(previewUrls)
                    }
                    
                    if let imageURL = song["artworkUrl100"] as? String {
                        
                        
                        
                        imageURLBox.append(imageURL)
                        print(imageURLBox)
                    }
                    
                    
                    
                    
                    
                    if let artistName = song["artistName"] as? String {
                        
                        artistNames.append(artistName)
                        
                        
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
    
    var trackNameaI: String!
    var previewUrlAi: String!
    var imageURLAi: String!
    var appicationLink: String!
    var applicationDesc: String!


    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        trackNameaI = self.trackNames[indexPath.row]
        imageURLAi = self.imageURLBox[indexPath.row]
        
        print(trackNameaI)
        print(imageURLAi)
        print(previewUrls)
        print(appLinks)
        
        
        /*if self.previewUrls[indexPath.row] == nil {
            print("aaaaaai")
        }else {
            previewUrlAi = self.previewUrls[indexPath.row]
        }
        */
        if self.appLinks[indexPath.row] != nil {
            appicationLink = self.appLinks[indexPath.row]
        }
        
        if self.appDescs[indexPath.row] != nil {
            applicationDesc = self.appDescs[indexPath.row]
        }

        
        performSegue(withIdentifier: "goingHell", sender: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goingHell" {
            
            let basePostVC = (segue.destination as? BasicPostViewController)!
            
            basePostVC.trackName = trackNameaI
            basePostVC.imageURL = imageURLAi
            basePostVC.previewUrl = previewUrlAi
            basePostVC.appLink = appicationLink
            basePostVC.appDesc = applicationDesc

            
            
            
            
        }
    }

    
    
    
    
    
    
    
    

}
