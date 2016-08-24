//
//  VenueAnnotation.swift
//  HungryTeam
//
//  Created by Gabriel Silva on 22/08/2016.
//  Copyright © 2016 Gabriel Silva. All rights reserved.
//

import Foundation
import MapKit

class VenueAnnotation: NSObject, MKAnnotation {
    var title:String?
    var subtitle:String?
    var coordinate: CLLocationCoordinate2D
    var voted: Bool = false
    var available: Bool = true
    var winner: Bool = false
    
    init(title: String?, subtitle:String?, coordinate: CLLocationCoordinate2D, voted: Bool, available: Bool, winner: Bool) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.voted = voted
        self.available = available
        self.winner = winner
        
        super.init()
    }
}