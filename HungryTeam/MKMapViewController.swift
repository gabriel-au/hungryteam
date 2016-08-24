//
//  MKMapViewController.swift
//  HungryTeam
//
//  Created by Gabriel Silva on 23/08/2016.
//  Copyright © 2016 Gabriel Silva. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? VenueAnnotation {
            let identifier = annotation.title
            var view = MKPinAnnotationView()
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier!) as! MKPinAnnotationView! {
                view = dequeuedView
                view.annotation = annotation
            }
            else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.animatesDrop = true
                view.canShowCallout = true
                
                if annotation.available {
                    view.pinTintColor = UIColor.greenColor()
                } else {
                    view.pinTintColor = UIColor.grayColor()
                }
                
                if annotation.voted {
                    view.pinTintColor = UIColor.purpleColor()
                }
                
                if annotation.winner {
                    view.pinTintColor = UIColor.redColor()
                }
            }
            return view
        }
        return nil
    }
}