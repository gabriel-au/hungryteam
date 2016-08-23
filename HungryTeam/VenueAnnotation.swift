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
    
    init(title: String?, subtitle:String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
}