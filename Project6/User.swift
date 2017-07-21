//
//  User.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/07/22.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import Foundation
import FirebaseDatabase


struct User {
    
    var userDesc: String!
    var ref: FIRDatabaseReference?
    var key: String?
    
    
    
    //Initialize
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        ref = snapshot.ref
        userDesc = (snapshot.value! as! NSDictionary)["profileDesc"] as! String
        
    }
    
    
    
    
    
}
