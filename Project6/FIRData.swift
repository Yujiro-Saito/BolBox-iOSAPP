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

class DataService {
    
    
    static let dataBase = DataService()
    
    //DB REF
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    
    
    //Storage REF
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    //Properties
    
    var REF_POST: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    
    
    
}
