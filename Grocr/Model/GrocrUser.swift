//
//  GrocrUser.swift
//  Grocr
//
//  Created by Quinton Quaye on 12/11/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import Foundation
import FirebaseAuth
struct GrocrUser {
    
    var uid: String // for firebase unique id
    var userName: String
    
    // stadard init
    init(uid: String, userName: String){
        
        self.uid = uid
        self.userName = userName
        
    }
    
    // firebase authorization init
    init(authData: FIRUser){
        uid = authData.uid
        userName = authData.email!
    }
}
