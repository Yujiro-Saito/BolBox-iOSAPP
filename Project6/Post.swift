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
    private var _pvCount: Int!
    
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
        return _pvCount
    }
    
    var postKey: String {
        return _postKey
    }
    
    
    
    init(name: String,  category: String, imageURL: String, whatContent: String, goodCount: Int, keepCount: Int, pvCount: Int) {
        
        
        self._name = name
        self._category = category
        self._imageURL = imageURL
        self._whatContent = whatContent
        self._goodCount = goodCount
        self._keepCount = keepCount
        self._pvCount = pvCount
    }
    
    
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        
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
        
        if let pvCount = postData["pvCount"] as? Int {
            self._pvCount = pvCount
        }
        
        _postRef = DataService.dataBase.REF_POST.child(_postKey)
        
        
        
}
    

    
    
    
    
    




}
