//
//  GroceryItem.swift
//  Grocr
//
//  Created by Quinton Quaye on 12/11/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct GroceryItem {
    let key: String
    let item: String
    let addedByUser: String
    let ref: FIRDatabaseReference?
    var completed: Bool
    
    // standard init
    init(key: String = "", item: String, addedByUser: String, completed: Bool){
        
        self.key = key
        self.item = item
        self.addedByUser = addedByUser
        self.completed = completed
        self.ref = nil
        
    }
    
    //database init for snapshot
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        let snapShotValue = snapshot.value as! [String: AnyObject] // is a dictionary ie: [key : value] property
        item = snapShotValue["item"] as! String
        addedByUser = snapShotValue["addedByUser"] as! String
        completed = snapShotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any{
        return [
            "item": item,
            "addedByUser": addedByUser,
            "completed": completed
        ]
    }
}
