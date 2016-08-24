//
//  Vote.swift
//  HungryTeam
//
//  Created by Gabriel Silva on 23/08/2016.
//  Copyright © 2016 Gabriel Silva. All rights reserved.
//

import Foundation

class Vote {
    
    private var _date: NSDate!
    private var _venues: [Venue]!
    
    var date: NSDate? {
        return _date
    }
    
    var venues: [Venue]? {
        return _venues
    }
    
    init(date: NSDate, venues: [Venue]) {
        self._date = date
        self._venues = venues
    }
    
}