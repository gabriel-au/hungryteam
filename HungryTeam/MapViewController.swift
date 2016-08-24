//
//  MapViewController.swift
//  HungryTeam
//
//  Created by Gabriel Silva on 21/08/2016.
//  Copyright © 2016 Gabriel Silva. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class MapViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTableView: UITableView!
    @IBOutlet weak var voteBtn: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    
    let distanceSpan: Double = 1000
    
    let currentDate = NSDate()
    let dateFormatter = NSDateFormatter()
    let calendar = NSCalendar.currentCalendar()
    var currentDateComponents: NSDateComponents?
    var startOfWeek: NSDate?
    
    var locManager:CLLocationManager!
    var currentLocation:CLLocation!
    var lat: CLLocationDegrees!
    var lng: CLLocationDegrees!
    
    var venueSelected: Venue!
    var venues = [Venue]()
    var venueAnnotations = [VenueAnnotation]()
    
    var votedToday = false
    
    var ref: FIRDatabaseReference!
    private var _refHandle: FIRDatabaseHandle!
    
    private var _venue: Venue?
    
    var venue: Venue? {
        return _venue
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager = CLLocationManager()
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        mapTableView.delegate = self
        mapTableView.dataSource = self
        
        self.dateFormatter.locale = NSLocale.currentLocale()
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.currentDateComponents = calendar.components([.YearForWeekOfYear, .WeekOfYear], fromDate: currentDate)
        self.startOfWeek = calendar.dateFromComponents(currentDateComponents!)
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways){
            
            currentLocation = locManager.location
            
        }
        
        lat = currentLocation.coordinate.latitude
        lng = currentLocation.coordinate.longitude

        let center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let region = MKCoordinateRegionMakeWithDistance(center, distanceSpan, distanceSpan)
        
        mapView.setRegion(region, animated: true)
        
        configureDatabase()
    }
    
    deinit {
        self.ref.child("venues").removeObserverWithHandle(_refHandle)
    }
    
    override func viewWillAppear(animated: Bool) {
        centerMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func voteBtnPressed(sender: UIButton) {
        if venueSelected != nil {
            let voteAlert = UIAlertController(title: "VOTE", message: "You can vote once a day. \nVoting closes at 1pm. \nDo you confirm your vote?", preferredStyle: UIAlertControllerStyle.Alert)
            
            voteAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
//                print("Handle Ok logic here")
                
                self.vote(self.venueSelected)
                self.tabBarController!.selectedIndex = 1
            }))
            
            voteAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            }))
            
            presentViewController(voteAlert, animated: true, completion: nil)
        }

    }
    
    @IBAction func locationBtnPressed(sender: UIButton) {
        centerMap()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("locationsCell")
        
//        let venuesSnapshot: FIRDataSnapshot! = self.venues[indexPath.row]
//        let venue = venuesSnapshot.value as! Dictionary<String, String>
//        let name = venue[Constants.VenueFields.name] as String!
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "locationsCell")
        }
        
        let venue = venues[indexPath.row]
        
        cell!.textLabel?.text = venue.name
        cell!.detailTextLabel?.text = venue.address
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        venueSelected = venues[indexPath.row]
        let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: Double(venueSelected.latitude!), longitude: Double(venueSelected.longitude!)), (distanceSpan*2), (distanceSpan*2))
        
        mapView?.setRegion(region, animated: true)
        mapView?.selectAnnotation(venueAnnotations[indexPath.row], animated: true)
//        mapView?.selectAnnotation(mapView.annotations[indexPath.row], animated: true)
        
        if votedToday {
            self.voteBtn.setTitle("ALREADY VOTED", forState: UIControlState.Disabled)
            self.voteBtn.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Disabled)
            self.voteBtn.enabled = false
        } else {
            if venueSelected.available! {
                self.voteBtn.enabled = true
            } else {
                self.voteBtn.setTitle("VOTED THIS WEEK", forState: UIControlState.Disabled)
                self.voteBtn.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Disabled)
                self.voteBtn.enabled = false
            }
        }
        
        self.voteBtn.hidden = false
        
//        print("INDEX ROW >>> \(indexPath.row)")
//        print("NAME >>> \(venueSelected.name)")
    }
    
    func vote(venue: Venue) {
        let today = self.dateFormatter.stringFromDate(currentDate)
        
        let voteUserRef = DataService.ds.REF_CURRENT_USER.child("votes").child(today).child(self.venueSelected.id!)
        
        voteUserRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let doesNotExist = snapshot.value as? NSNull {
                voteUserRef.setValue(true)
                
            }
        })
        
        let voteVenueRef = DataService.ds.REF_BASE.child("votes").child(today).child(self.venueSelected.id!).child("votes")
        
        voteVenueRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let doesNotExist = snapshot.value as? NSNull {
                voteVenueRef.setValue(1)
                voteVenueRef.parent?.child("name").setValue(venue.name)
//                voteVenueRef.child("name").setValue(venue.name)
            } else {
                let valString = snapshot.value
                var value = valString!.intValue
                value = value + 1
                
                voteVenueRef.setValue(Int(value))
            }
        })
        
    }
    
    func configureDatabase() {
        DataService.ds.createFirebaseUser()
        
        let date = self.dateFormatter.stringFromDate(currentDate)
        
        let voteUserTestRef = DataService.ds.REF_CURRENT_USER.child("votes").child(date)
        
        voteUserTestRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let doesNotExist = snapshot.value as? NSNull {
                self.votedToday = false
            } else {
                self.votedToday = true
            }
        })

        
//        votedToday = DataService.ds.hasVoted(self.dateFormatter.stringFromDate(currentDate))
        
        if votedToday {
            print(">>>> VOTED <<<<<<<")
        }
        
        ref = FIRDatabase.database().reference()
        
        // Listen for new records in the Firebase database
        _refHandle = self.ref.child("venues").observeEventType(.Value, withBlock: { (snapshot) -> Void in
            //            self.venues.append(snapshot)
            
            //            print("KEY >>> \(snapshot.value)!")
            
            self.venues = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    var venueAvailable = true
                    
//                    print("SNAP: \(snap)")
                    
                    if let venueDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        
                        let voteDate = self.dateFormatter.dateFromString((snap.value!["poll_date"] as? String)!)
                        
                        if voteDate != nil {
                            let dateOrder = NSCalendar.currentCalendar().compareDate(self.startOfWeek!, toDate: voteDate!, toUnitGranularity: .Day)
                            
                            if dateOrder == NSComparisonResult.OrderedAscending || dateOrder == NSComparisonResult.OrderedSame {
                                venueAvailable = false
                            }
                        }
                        
                        let venue = Venue(id: key, dictionary: venueDict, voted: false, available: venueAvailable, winner: false)
                        
                        self.venues.append(venue)
                    }
                }
                
//                self.venues[0].setAvailability(false)
                
                self.mapTableView.reloadData()
                self.addVenuesOnMap(self.venues)
            }
        })
    }
    
    func centerMap() {
        if locManager != nil {
            let center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            let region = MKCoordinateRegionMakeWithDistance(center, distanceSpan, distanceSpan)
            
            let selectedAnnotations = mapView.selectedAnnotations
            
            if selectedAnnotations.count > 0 {
                mapView.deselectAnnotation(selectedAnnotations[0], animated: true)
            }
            
            self.voteBtn.hidden = true
            
//            venues.count > 0 ||
            
            if mapTableView.indexPathForSelectedRow != nil {
                mapTableView.deselectRowAtIndexPath(mapTableView.indexPathForSelectedRow!, animated: true)
            }
            
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    func addVenuesOnMap(venues: [Venue]) {
        self.venueAnnotations = []
        
        for venue in venues {
            let annotation = VenueAnnotation(title: venue.name, subtitle: venue.address, coordinate: CLLocationCoordinate2D(latitude: Double(venue.latitude!), longitude: Double(venue.longitude!)), voted: venue.voted!, available: venue.available!, winner: venue.winner!)
            
            self.venueAnnotations.append(annotation)
        }
        
        mapView?.addAnnotations(venueAnnotations)
        
//        for annotation in (mapView?.annotations)! {
//            print("ANNOTATION TITLE >> \(annotation.title)")
//            mapView?.annotations.
//        }
    }
    
//    func forDevTests() {
        //        strArrayTest = ["Nome 1", "Nome 2"]
        
//        venues.append(Venue.init(id: "4d3fafb5cb84b60c02947f22", name: "Tartine", latitude: -33.920053, longitude: 151.189177, address: "635 Gardeners Rd, Mascot NSW 2020"))
//        
//        venues.append(Venue.init(id: "4b5d8f9ff964a5208c6129e3", name: "Tavolino Pizzeria", latitude: -33.922332, longitude: 151.187632, address: "7/1-5 Bourke St, Mascot NSW 2020"))
//        
//        venues.append(Venue.init(id: "4bf58dd8d48988d1a1941735", name: "Spice Thai Cuisine Mascot", latitude: -33.923418, longitude: 151.186881, address: "3/8 Bourke St, Mascot NSW 2020"))
//        
//        venues.append(Venue.init(id: "4d3fafb5cb84b60c02947fab", name: "Ichiro's Sushi Bar", latitude: -33.922563, longitude: 151.186108, address: "14/19-33 Kent Rd, Mascot NSW 2020"))
        
        // Tavolino Pizzeria -33.922332, 151.187632 7/1-5 Bourke St, Mascot NSW 2020
        // Spice Thai Cuisine Mascot -33.923418, 151.186881 3/8 Bourke St, Mascot NSW 2020
        // Ichiro's Sushi Bar -33.922563, 151.186108 14/19-33 Kent Rd, Mascot NSW 2020
        // Tartine -33.920053, 151.189177 635 Gardeners Rd, Mascot NSW 202
//    }

}

