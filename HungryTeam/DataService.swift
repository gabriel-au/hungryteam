//
//  DataService.swift
//  HungryTeam
//
//  Created by Gabriel Silva on 22/08/2016.
//  Copyright © 2016 Gabriel Silva. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let ds = DataService()
    
    var voted: Bool!
    
    private var _REF_BASE = FIRDatabase.database().reference()
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_CURRENT_USER: FIRDatabaseReference {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let user = REF_BASE.child("users").child(uid)
        return user
    }
    
    func createFirebaseUser() {
        REF_CURRENT_USER.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if (snapshot.value as? NSNull) != nil {
                let user = ["device": "mobile"]
                
                self.REF_CURRENT_USER.setValue(user)
            }
        })
    }
    
    func hasVoted(date: String) -> Bool {
        let voteUserTestRef = DataService.ds.REF_CURRENT_USER.child("votes").child(date)
        
        voteUserTestRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let doesNotExist = snapshot.value as? NSNull {
                self.voted = false
            } else {
                self.voted = true
            }
        })
        
        return self.voted
    }
}