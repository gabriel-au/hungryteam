//
//  Venue.swift
//  HungryTeam
//
//  Created by Gabriel Silva on 21/08/2016.
//  Copyright © 2016 Gabriel Silva. All rights reserved.
//

import Foundation

class Venue {
    
    private var _id: String!
    private var _name: String!
    private var _address: String!
    private var _latitude: Float!
    private var _longitude: Float!
    private var _poll_date: NSDate!
    private var _votes: Int!
    private var _voted: Bool!
    private var _available: Bool!
    private var _winner: Bool!
    
    var id: String? {
        return _id
    }
    
    var name: String? {
        return _name
    }
    
    var address: String? {
        return _address
    }
    
    var latitude: Float? {
        return _latitude
    }
    
    var longitude: Float? {
        return _longitude
    }
    
    var pollDate: NSDate? {
        return _poll_date
    }
    
    var votes: Int? {
        return _votes
    }
    
    var voted: Bool? {
        return _voted
    }
    
    var available: Bool? {
        return _available
    }
    
    var winner: Bool? {
        return _winner
    }
    
    init(id: String, name: String, address: String, latitude: Float, longitude: Float, voted: Bool, available: Bool, winner: Bool) {
        self._id = id
        self._name = name
        self._address = address
        self._latitude = latitude
        self._longitude = longitude
        self._voted = voted
        self._available = available
        self._winner = winner
    }
    
    init(id: String, name: String, address: String, latitude: Float, longitude: Float) {
        self._id = id
        self._name = name
        self._address = address
        self._latitude = latitude
        self._longitude = longitude
    }
    
    init(id: String, name: String, votes: Int) {
        self._id = id
        self._name = name
        self._votes = votes
    }
    
    init(id: String, dictionary: Dictionary<String, AnyObject>, voted: Bool, available: Bool, winner: Bool) {
        self._id = id
        
        if let name = dictionary["name"] as? String {
            _name = name
        }
        
        if let address = dictionary["address"] as? String {
            _address = address
        }
        
        if let latitude = dictionary["latitude"] as? Float {
            _latitude = latitude
        }
        
        if let longitude = dictionary["longitude"] as? Float {
            _longitude = longitude
        }
        
        if let pollDate = dictionary["poll_date"] as? NSDate {
            _poll_date = pollDate
        }
        
        if let votes = dictionary["votes"] as? Int {
            _votes = votes
        }
        
        self._voted = voted
        self._available = available
        self._winner = winner
    }
    
    func adjustVotes(addVotes: Bool) {
        
        if addVotes {
            _votes = _votes + 1
        } else {
            _votes = _votes - 1
        }
    }
}
