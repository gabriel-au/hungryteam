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
    
    private var _REF_BASE = FIRDatabase.database().reference()
//    private var _REF_POSTS = FIRDatabase.database().reference() + ""
//    private var _REF_USERS = "\(URL_BASE)/users"
    
//    var rootRef = FIRDatabase.database().reference()
    
//    var REF_BASE: Firebase {
//        return _REF_BASE
//    }
}