//
//  FIRData.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/05/14.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage


//DB アクセス
let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()
let REF = FIRDatabaseReference()

let barColor = UIColor.rgb(r: 31, g: 158, b: 187, alpha: 1)
let KEY_UID = "uid"

class DataService {
    
    
    
    static let dataBase = DataService()
    
    //DB REF
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_TOP = DB_BASE.child("topReccomend")
    private var _REF_FIRST = DB_BASE.child("first")
    private var _REF_SECOND = DB_BASE.child("second")
    private var _REF_THIRD = DB_BASE.child("third")
    private var _REF_FOURTH = DB_BASE.child("fourth")
    private var _REF_FIFTH = DB_BASE.child("fifth")
    private var _REF_USER = DB_BASE.child("users")

    
    
    //Storage REF
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    private var _REF_USER_IMAGES = STORAGE_BASE.child("user-pics")
    
    
    //Properties
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POST: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_TOP: FIRDatabaseReference {
        return _REF_TOP
    }
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    var REF_FIRST: FIRDatabaseReference {
        
        return _REF_FIRST
        
    }
    
    var REF_SECOND: FIRDatabaseReference {
        
        return _REF_SECOND
        
    }
    
    var REF_THIRD: FIRDatabaseReference {
        
        return _REF_THIRD
        
    }
    
    var REF_FOURTH: FIRDatabaseReference {
        
        return _REF_FOURTH
        
    }
    
    var REF_FIFTH: FIRDatabaseReference {
        
        return _REF_FIFTH
        
    }
    
   
    var REF_USER: FIRDatabaseReference {
        return _REF_USER
    }
    
    
    func createDataBaseUser(uid: String, userData: Dictionary<String, String>, userName: Dictionary<String, Any>, photoURL: Dictionary<String, Any>, userEmail: Dictionary<String, Any>) {
        REF_USER.child(uid).setValue(userData)
        REF_USER.child(uid).setValue(userName)
        REF_USER.child(uid).setValue(photoURL)
        REF_USER.child(uid).setValue(userEmail)
    }
    
    func loginUserDatabase(uid: String, userData: Dictionary<String, String>) {
        REF_USER.child(uid).updateChildValues(userData)
    }

    
    
    
    
}
