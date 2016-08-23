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
    
    init(id: String, name: String, address: String, latitude: Float, longitude: Float) {
        self._id = id
        self._name = name
        self._address = address
        self._latitude = latitude
        self._longitude = longitude
    }
    
    init(id: String, dictionary: Dictionary<String, AnyObject>) {
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
    }
    
    
//    private var _venues: [Venue]!
    
//    init(id: String, name: String, latitude: Float, longitude: Float, address: String) {
//        super.init()
//        
//        self.id = id
//        self.name = name
//        self.latitude = latitude
//        self.longitude = longitude
//        self.address = address
//        
//    }
//    
//    override var description: String {
//        return "id: \(id)" +
//                "name: \(name)" +
//                "latitude: \(latitude)" +
//                "longitude: \(longitude)" +
//                "address: \(address)"
//    }
//    
//    func getVenues() -> [Venue] {
//        //        strArrayTest = ["Nome 1", "Nome 2"]
//        
//        venues = []
//        
//        venues.append(Venue.init(id: "4d3fafb5cb84b60c02947f22", name: "Tartine", latitude: -33.920053, longitude: 151.189177, address: "635 Gardeners Rd, Mascot NSW 2020"))
//        
//        venues.append(Venue.init(id: "4b5d8f9ff964a5208c6129e3", name: "Tavolino Pizzeria", latitude: -33.922332, longitude: 151.187632, address: "7/1-5 Bourke St, Mascot NSW 2020"))
//        
//        venues.append(Venue.init(id: "4bf58dd8d48988d1a1941735", name: "Spice Thai Cuisine Mascot", latitude: -33.923418, longitude: 151.186881, address: "3/8 Bourke St, Mascot NSW 2020"))
//        
//        venues.append(Venue.init(id: "4d3fafb5cb84b60c02947fab", name: "Ichiro's Sushi Bar", latitude: -33.922563, longitude: 151.186108, address: "14/19-33 Kent Rd, Mascot NSW 2020"))
//        
//        // Tavolino Pizzeria -33.922332, 151.187632 7/1-5 Bourke St, Mascot NSW 2020
//        // Spice Thai Cuisine Mascot -33.923418, 151.186881 3/8 Bourke St, Mascot NSW 2020
//        // Ichiro's Sushi Bar -33.922563, 151.186108 14/19-33 Kent Rd, Mascot NSW 2020
//        // Tartine -33.920053, 151.189177 635 Gardeners Rd, Mascot NSW 202
//        
//        return self.venues
//    }

}
