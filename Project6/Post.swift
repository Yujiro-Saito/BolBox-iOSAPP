//
//  Post.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/14.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import Foundation
import Firebase


class Post {
    
    
    private var _name: String!
    private var _category: String!
    private var _imageURL: String!
    private var _whatContent: String!
    private var _goodCount: Int!
    private var _keepCount: Int!
    private var _pvCount: Int?
    private var _detailImageOne: String!
    private var _detailImageTwo: String!
    private var _detailImageThree: String!
    private var _linkURL: String!
    private var _postID: String!
    private var _peopleWhoLike = Dictionary<String,AnyObject?>()
    private var _userID: String!
    private var _userProfileImage: String!
    private var _userProfileName: String!
    
    
    
    
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    
    
    
    var name: String {
        return _name
    }
    
    var category: String {
        return _category
    }
    
    var imageURL: String {
        return _imageURL
    }
    
    var whatContent: String {
        return _whatContent
    }
    
    var goodCount: Int {
        return _goodCount
    }
    
    var keepCount: Int {
        return _keepCount
    }
    
    var pvCount: Int {
        return _pvCount!
    }
    
    var postID: String {
        return _postID
    }
    
    var detailImageOne: String {
        return _detailImageOne
    }
    
    var detailImageTwo: String {
        return _detailImageTwo
    }
    
    var detailImageThree: String {
        return _detailImageThree
    }
    
    var linkURL: String {
        return _linkURL
    }
    
    
    var postKey: String {
        return _postKey
    }
    
    
    var peopleWhoLike : Dictionary<String, AnyObject?> {
     return _peopleWhoLike
    }
    
    
    var userID: String {
        return _userID
    }
    
    var userProfileImage: String {
        return _userProfileImage
    }
    
    var userProfileName: String {
        return _userProfileName
    }
    

    
    
    init?(name: String,  category: String, imageURL: String, whatContent: String, goodCount: Int, keepCount: Int, pvCount: Int?, detailImageOne: String, detailImageTwo: String, detailImageThree: String, linkURL: String, postID: String, peopleWhoLike: Dictionary<String, AnyObject?>,userID: String,userProfileImage: String,userProfileName: String
        )
    {
        
        
        self._name = name
        self._category = category
        self._imageURL = imageURL
        self._whatContent = whatContent
        self._goodCount = goodCount
        self._keepCount = keepCount
        self._pvCount = pvCount
        self._detailImageOne = detailImageOne
        self._detailImageTwo = detailImageTwo
        self._detailImageThree = detailImageThree
        self._linkURL = linkURL
        self._postID = postID
        self._peopleWhoLike = peopleWhoLike
        self._userID = userID
        self._userProfileImage = userProfileImage
        self._userProfileName = userProfileName
        
    }
    
    
    
    init(postKey: String, postData: Dictionary<String, AnyObject?>) {
        
        self._postKey = postKey
        
        
        if let name = postData["name"] as? String {
            self._name = name
        }
        
        if let category = postData["category"] as? String {
            self._category = category
        }
        
        if let imageURL = postData["imageURL"] as? String {
            self._imageURL = imageURL
        }
        
        if let whatContent = postData["whatContent"] as? String {
            self._whatContent = whatContent
        }
        
        if let goodCount = postData["goodCount"] as? Int {
            self._goodCount = goodCount
        }
        
        if let keepCount = postData["keepCount"] as? Int {
            self._keepCount = keepCount
        }
        
        if let pvCount = postData["pvCount"] as? Int? {
            self._pvCount = pvCount
        }
        
        if let detailImageOne = postData["detailImageOne"] as? String {
            self._detailImageOne = detailImageOne
        }
        
        if let detailImageTwo = postData["detailImageTwo"] as? String {
            self._detailImageTwo = detailImageTwo
        }
        
        if let detailImageThree = postData["detailImageThree"] as? String {
            self._detailImageThree = detailImageThree
        }
        
        if let linkURL = postData["linkURL"] as? String {
            self._linkURL = linkURL
        }
        
        if let postID = postData["postID"] as? String {
            self._postID = postID
        }
        
      
        
        if let peopleWhoLike = postData["peopleWhoLike"] as? Dictionary<String, AnyObject?>! {
            self._peopleWhoLike = peopleWhoLike
        }
        
        if let userID = postData["userID"] as? String {
            self._userID = userID
        }
        
        if let userProfileImage = postData["userProfileImage"] as? String {
            self._userProfileImage = userProfileImage
        }
        
        if let userProfileName = postData["userName"] as? String {
            self._userProfileName = userProfileName
        }
        
        
        
        _postRef = DataService.dataBase.REF_POST.child(_postKey)
        
        
        
}
    
    
    
    
    
    




}
