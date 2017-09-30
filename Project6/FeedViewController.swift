//
//  FeedViewController.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/08/30.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import AlamofireImage
import FaveButton
import youtube_ios_player_helper
import SafariServices


class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    var userID = String()
    var imagesURL = String()
    var userName = String()
    var linkURL = String()
    
    @IBOutlet weak var allBgView: UIView!
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        userName = userNameBox[indexPath.row]
        userID = userIDBox[indexPath.row]
        imagesURL = userProfileImageBox[indexPath.row]
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserHome" {
            
            
            let userVC = (segue.destination as? UserViewController)!
            
            userVC.userName = userName
            userVC.userImageURL = imagesURL
            userVC.userID = userID
            print(imagesURL)
            
            
        }
    }
    
    
    
    var newPosts = [Post]()
    var detailPosts: Post?
    
    @IBOutlet weak var tableFeed: UITableView!
    
    
    
    //data
    
    var folderNameBox = [String]()
    var imageURLBox = [String]()
    var linkURLBox = [String]()
    var nameBox = [String]()
    var postIDBox = [String]()
    var userIDBox = [String]()
    var userNameBox = [String]()
    var userProfileImageBox = [String]()
    var pvCountBox = [Int]()
    var checkBox = [String]()
    var videoKeyCheck = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableFeed.delegate = self
        tableFeed.dataSource = self
        

        tableFeed.isPagingEnabled = true
        
        // フォント種をTime New Roman、サイズを10に指定
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSFontAttributeName: UIFont(name: "Times New Roman", size: 18)!]
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        
       
 
        
    }
    
    
    
   
    
    
    let selfUID = FIRAuth.auth()?.currentUser?.uid
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
       
        self.navigationController?.setNavigationBarHidden(true, animated: true)
       
        
        
        //navigationItem.titleView = mySearchBar
        
        
        //Followのチェック follower数のチェック
        DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: selfUID!).observe(.value, with: { (snapshot) in
            
            self.checkBox = []
            self.folderNameBox = []
            self.imageURLBox = []
            self.linkURLBox = []
            self.nameBox = []
            self.userNameBox = []
            self.userProfileImageBox = []
            self.userIDBox = []
            self.pvCountBox = []
            self.postIDBox = []
            self.videoKeyCheck = []
            
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        
                        if postDict["following"] as? Dictionary<String, AnyObject?> != nil {
                            
                            let followingDictionary = postDict["following"] as? Dictionary<String, AnyObject?>
                            for (followKey,followValue) in followingDictionary! {
                                
                                print("キーは\(followKey)、値は\(followValue)")
                                let followingKey = followKey
                                
                                
                            ///

                                //ユーザーのコレクションの読み込み
                                DataService.dataBase.REF_BASE.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: followingKey).observe(.value, with: { (snapshot) in
                                    
                                    self.newPosts = []
                                    
                                    if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                        
                                        for snap in snapshot {
                                            
                                            if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                                
                                                
                                                
                                                if postDict["posts"] as? Dictionary<String, Dictionary<String, AnyObject?>> != nil {
                                                    
                                                    
                                                    let posts = postDict["posts"] as? Dictionary<String, Dictionary<String, AnyObject>>
                                                    
                                                    for (key,value) in posts! {
                                                        
                                                        let folderName = value["folderName"] as! String
                                                        
                                                        let imageURL = value["imageURL"] as! String
                                                        
                                                        let linkURL = value["linkURL"] as! String
                                                        
                                                        let name = value["name"] as! String
                                                        
                                                        let videoCheck = value["videoKey"] as! String?
                                                        
                                                        
                                                        
                                                        
                                                        //Likes
                                                        if value["peopleWhoLike"] as? Dictionary<String,Dictionary<String,String>?> != nil {
                                                            
                                                            
                                                            let likePeople = value["peopleWhoLike"] as? Dictionary<String,Dictionary<String,String>?>
                                                            
                                                            for (likeKey,likeValue) in likePeople! {
                                                                
                                                                
                                                                print(likeValue!)
                                                                
                                                                let checkID = likeValue?["currentUserID"] as String!
                                                                let myUID = FIRAuth.auth()?.currentUser?.uid
                                                                
                                                                if checkID! == myUID! {
                                                                    
                                                                   self.checkBox.append("YES")
                                                                    
                                                                }
                                                                
                                                                
                                                            }
                                                            
                                                            
                                                        } else {
                                                            self.checkBox.append("NO")
                                                        }
                                                        
                                                        
                                                        let postID = value["postID"] as! String
                                                        
                                                        let pvCount = value["pvCount"] as! Int
                                                        
                                                        let userID = value["userID"] as! String
                                                        
                                                        let userName = value["userName"] as! String
                                                        
                                                        let userProfileImage = value["userProfileImage"] as! String
                                                        
                                                        
                                                        if videoCheck != nil {
                                                            self.videoKeyCheck.append(videoCheck!)
                                                        } else {
                                                            self.videoKeyCheck.append("")
                                                        }
                                                        
                                                        self.folderNameBox.append(folderName)
                                                        self.imageURLBox.append(imageURL)
                                                        self.linkURLBox.append(linkURL)
                                                        self.nameBox.append(name)
                                                        self.postIDBox.append(postID)
                                                        self.pvCountBox.append(pvCount)
                                                        self.userIDBox.append(userID)
                                                        self.userNameBox.append(userName)
                                                        self.userProfileImageBox.append(userProfileImage)
                                                        
                                                       
                                            
                                                        
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                }
                                                
                                                
                                                
                                                
                                                
                                            }
                                            
                                            
                                            
                                        }
                                        
                                        
                                        
                                        
                                        
                                    }
                                    
                                
                                    self.checkBox.reverse()
                                    self.videoKeyCheck.reverse()
                                    self.folderNameBox.reverse()
                                    self.imageURLBox.reverse()
                                    self.linkURLBox.reverse()
                                    self.nameBox.reverse()
                                    self.userIDBox.reverse()
                                    self.userNameBox.reverse()
                                    self.userProfileImageBox.reverse()
                                    self.pvCountBox.reverse()
                                    self.postIDBox.reverse()
                                    self.tableFeed.reloadData()
                                    
                                    
                                    print(self.userProfileImageBox)
                                    
                                    
                                })

                                
                                
                            }
                            
                        }
                        
                    }
                    
                }
            }
            
            //
        })
        
        
        
        
        
        
          }
    
    let photoURLUser = FIRAuth.auth()?.currentUser?.photoURL
    var resNames = [String]()
    var resImagess = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return folderNameBox.count
       
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    var favBool = Bool()
    
    func favOne(_ sender: UIButton){
        
        
        
        /*
        let cell = sender.superview?.superview as! FeedTableViewCell
        guard let row = self.tableFeed.indexPath(for: cell)?.row else {
            return
        }
        
        print(row)
        
        var currentFavNum = pvCountBox[row]
        let favCheck = checkBox[row]
        var favNum = ["pvCount": currentFavNum]
        var check = Bool()
        
        if favCheck == "YES" {
            //liked alredy
            check = true
            cell.oneLoveButton.isSelected = false
            
        } else {
           //Not yet
            cell.oneLoveButton.isSelected = false
            
            
        }
        
        
        if cell.oneLoveButton.isSelected == false {
            print("loved")
            //++
            
            
           
            
        } else {
            print("hate")
            //--
            
            currentFavNum += 1
            
            favNum = ["pvCount": currentFavNum]
            
            print(favNum)
            print(self.userIDBox[row])
            print(self.postIDBox[row])
            
            DataService.dataBase.REF_BASE.child("users/\(self.userIDBox[row])/posts/\(self.postIDBox[row])").updateChildValues(favNum)
            cell.oneLoveButton.isSelected = true
        }
        
    
        if cell.oneLoveButton.isSelected == true {
            //+++
            print("ddede")
            currentFavNum -= 1
            
            favNum = ["pvCount": currentFavNum]
         
            print(favNum)
            print(self.userIDBox[row])
            print(self.postIDBox[row])
            
            
            DispatchQueue.main.async {
                DataService.dataBase.REF_BASE.child("users/\(self.userIDBox[row])/posts/\(self.postIDBox[row])").updateChildValues(favNum)
                
                
            }
        } else {
            //---
            print("aadedede")
            currentFavNum += 1
            
            favNum = ["pvCount": currentFavNum]
            
            print(favNum)
            print(self.userIDBox[row])
            print(self.postIDBox[row])
            
            
            DispatchQueue.main.async {
                DataService.dataBase.REF_BASE.child("users/\(self.userIDBox[row])/posts/\(self.postIDBox[row])").updateChildValues(favNum)
                
                
            }
            
        }
 */
    }
    
    
    
    @IBAction func UserCheckButton(_ sender: Any) {
        
        let cell = (sender as AnyObject).superview??.superview?.superview as! FeedTableViewCell
        
        guard let row = self.tableFeed.indexPath(for: cell)?.row else {
            return
        }
        
        imagesURL = self.userProfileImageBox[row]
        self.userName = self.userNameBox[row]
        self.userID = self.userIDBox[row]
        
        
        
        
    performSegue(withIdentifier: "UserHome", sender: nil)
    }
    
    @IBAction func folderChecking(_ sender: Any) {
    }
    
    
    @IBAction func likersLists(_ sender: Any) {
        
    }
    
     func safariOnclick(_ sender: AnyObject){
        
        
        
        
        
        
        let cell = sender.superview??.superview?.superview as! FeedTableViewCell
        
        guard let row = self.tableFeed.indexPath(for: cell)?.row else {
            return
        }
 
        let selectedURL = self.linkURLBox[row]
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let safari = UIAlertAction(title: "Safariで開く", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            
            
            let targetURL = selectedURL
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
    
    func imageOnClick(_ sender: AnyObject){
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
      
        
        let report = UIAlertAction(title: "不審な投稿として報告", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            
            
        })
        
        
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
        })
        
        actionSheet.addAction(report)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        
        
        
        
        let cell = tableFeed.dequeueReusableCell(withIdentifier: "Feeder", for: indexPath) as? FeedTableViewCell
        
        
        
        
        
        
        
        //読み込むまで画像は非表示
        cell?.clipsToBounds = true
        cell?.bigImage.isHidden = true
        cell?.videoPlayer.isHidden = true
        cell?.titleLabel.isHidden = true
        cell?.textBox.isHidden = true
        cell?.bigImage.image = nil
        
        //Common
        cell?.folderName.text = self.folderNameBox[indexPath.row]
        cell?.userName.text = self.userNameBox[indexPath.row]
        cell?.userPrfileImage.af_setImage(withURL:  URL(string: self.userProfileImageBox[indexPath.row])!)
        cell?.favNumLabel.text = "\(self.pvCountBox[indexPath.row])件"

    

        
        //画像ありのセル
        if self.imageURLBox[indexPath.row] != "" {
            
            
            self.allBgView.backgroundColor = UIColor.black
            
            //Youtubeの場合
            
            if self.videoKeyCheck[indexPath.row] != ""  {
                
                
                //cell?.actionButton.addTarget(self, action: #selector(self.safariOnclick(_:)), for: .touchUpInside)
                cell?.actionButton.addTarget(self, action: #selector(FeedViewController.safariOnclick(_:)), for: .touchUpInside)
                
                    
                
                
                
                cell?.videoPlayer.load(withVideoId: self.videoKeyCheck[indexPath.row])
                
                
                if self.checkBox[indexPath.row] == "YES" {
                    cell?.favButton.isSelected = true
                } else {
                    
                    cell?.favButton.isSelected = false
                    
                }
                
              cell?.videoPlayer.backgroundColor = UIColor.black
              cell?.videoPlayer.isHidden = false

                
            } else {
                
                cell?.actionButton.addTarget(self, action: #selector(self.imageOnClick(_:)), for: .touchUpInside)
                if self.checkBox[indexPath.row] == "YES" {
                    cell?.favButton.isSelected = true
                } else {
                    
                    cell?.favButton.isSelected = false
                    
                }
                
                //Image
                cell?.bigImage.isHidden = false
                cell?.bigImage.af_setImage(withURL:  URL(string: self.imageURLBox[indexPath.row])!)
                
                
                
                
            }
            
            
            
            return cell!
            
            
            
        } else if self.imageURLBox[indexPath.row] == "" {
            
            cell?.actionButton.addTarget(self, action: #selector(self.safariOnclick(_:)), for: .touchUpInside)
            
            self.allBgView.backgroundColor = UIColor.white
            
            
            if self.checkBox[indexPath.row] == "YES" {
                cell?.favButton.isSelected = true
            } else {
                
                cell?.favButton.isSelected = false
                
            }
            
            cell?.titleLabel.isHidden = false
            cell?.textBox.isHidden = false
            
            cell?.titleLabel.text = self.nameBox[indexPath.row]
            cell?.textBox.text = "Quoraは英語のサービスだが、2016年からは多言語化を開始している。現在はドイツ語、スペイン語、フランス語、イタリア語でもサービスを提供していて、先日9月26日には、日本語ベータ版もローンチした（日本語ベータ版をいち早く試してみたい人は、ここから事前登録することができる）。TechCrunch Tokyo 2017では、Adam D’Angelo氏にQuoraを創業した経緯やユニコーンに成長するまでの道のりについて聞きたいと思っている。また、日本だとYahoo!知恵袋やOKWaveといった先行するサービスがある中、どのようにサービス展開を考えているかも聞きたいところだ。"
            
            
            return cell!
            
        }
        
       
return cell!
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        //let height = self.view.frame.height
        let height = self.tableFeed.frame.height
        
        return height
    }
    
        
    
        
        
        
        
    
    
    
    
    
    
    
   

}





