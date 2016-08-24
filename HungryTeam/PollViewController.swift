//
//  PollViewController.swift
//  HungryTeam
//
//  Created by Gabriel Silva on 21/08/2016.
//  Copyright © 2016 Gabriel Silva. All rights reserved.
//

import UIKit
import Firebase

class PollViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var pollTableView: UITableView!
    @IBOutlet weak var firstVenueNameLbl: UILabel!
    @IBOutlet weak var firstVenueAddressLbl: UILabel!
    @IBOutlet weak var firstVenueVotesLbl: UILabel!
    @IBOutlet weak var secondVenueNameLbl: UILabel!
    @IBOutlet weak var secondVenueAddressLbl: UILabel!
    @IBOutlet weak var secondVenueVotesLbl: UILabel!
    @IBOutlet weak var thirdVenueNameLbl: UILabel!
    @IBOutlet weak var thirdVenueAddressLbl: UILabel!
    @IBOutlet weak var thirdVenueVotesLbl: UILabel!
    
    let currentDate = NSDate()
    let dateFormatter = NSDateFormatter()
    
    var venues = [Venue]()
    var todayVenues = [Venue]()
    var todaysVote = [Vote]()
    var lastVotes = [Vote]()
    
    var ref: FIRDatabaseReference!
    private var _refHandle: FIRDatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateFormatter.locale = NSLocale.currentLocale()
        
        configureDatabase()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if let pollTableView = self.pollTableView {
            pollTableView.delegate = self
            pollTableView.dataSource = self
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastVotes.count ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("pollCell");
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "pollCell")
        }
        
        let vote = lastVotes[indexPath.row]
        var venueName = ""
        self.venues = vote.venues!
        
        if venues.count > 1 {
            let venueWinner = venues.maxElement({ $0.votes < $1.votes })
            
            venueName = (venueWinner?.name)!
            
        } else if venues.count == 1 {
            venueName = venues[0].name!
        }
        
        print("WINNER >> \(venueName)")
        
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        
        cell!.textLabel?.text = venueName
        cell!.detailTextLabel?.text = dateFormatter.stringFromDate(vote.date!)
//        cell!.detailTextLabel?.text = venue.address
        
        return cell!
    }
    
    deinit {
        self.ref.child("votes").removeObserverWithHandle(_refHandle)
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("votes").observeEventType(.Value, withBlock: { (snapshot) -> Void in
            //            self.venues.append(snapshot)
            
            //            print("KEY >>> \(snapshot.value)!")
            
            self.todaysVote = []
            self.lastVotes = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
//                    print("SNAP: \(snap)")
                    
                    if snap.hasChildren() {
                        self.venues = []
//                        let snapChildrens = snap.children.allObjects
                        
                        for child in snap.children {
//                            print("SNAP.children: \(child)")
                            
//                            print("DATE >> \(snap.key)")
//                            print("KEY >> \(child.key!)")
//                            print("NAME >> \(child.value["name"])")
//                            print("VOTES >> \(child.value["votes"])")
                            
                            let venue = Venue(id: child.key, name: (child.value["name"] as? String)!, votes: (child.value["votes"] as? Int)!)
                            
                            self.venues.append(venue)
                        }
                    }
                    
                    self.dateFormatter.dateFormat = "yyyy-MM-dd"
                    let voteDate = self.dateFormatter.dateFromString(snap.key)
                    
                    if self.dateFormatter.stringFromDate(self.currentDate) == snap.key {
                        self.todayVenues = self.venues.sort({ $0.votes > $1.votes })
                        let vote = Vote(date: voteDate!, venues: self.todayVenues)
                        
                        self.todaysVote.append(vote)
                    } else {
                        let vote = Vote(date: voteDate!, venues: self.venues)
                        
                        self.lastVotes.append(vote)
                    }
                    
//                    print(">>>> NEW KEY >>> \(snap.key)")
//                    print(">>>> NEW DATE >>> \(voteDate)")
                    
                }
                
                self.lastVotes = self.lastVotes.sort({ $0.date!.compare($1.date!) == NSComparisonResult.OrderedDescending })
                
                self.updateRanking()
                self.pollTableView.reloadData()
            }
        })
    }
    
    func updateRanking() {
        if (todayVenues.count == 1) {
            self.firstVenueNameLbl.text = todayVenues[0].name
            self.firstVenueAddressLbl.text = "Sydney, Australia" //todayVenues[0].address
            self.firstVenueVotesLbl.text = todayVenues[0].votes?.description
        } else if (todayVenues.count > 1 && todayVenues.count <= 2) {
            self.firstVenueNameLbl.text = todayVenues[0].name
            self.firstVenueAddressLbl.text = "Sydney, Australia" //todayVenues[0].address
            self.firstVenueVotesLbl.text = todayVenues[0].votes?.description
            
            self.secondVenueNameLbl.text = todayVenues[1].name
            self.secondVenueAddressLbl.text = "Sydney, Australia" //todayVenues[1].name
            self.secondVenueVotesLbl.text = todayVenues[1].votes?.description
        } else if todayVenues.count > 1 && todayVenues.count <= 3 {
            self.firstVenueNameLbl.text = todayVenues[0].name
            self.firstVenueAddressLbl.text = "Sydney, Australia" //todayVenues[0].address
            self.firstVenueVotesLbl.text = todayVenues[0].votes?.description
            
            self.secondVenueNameLbl.text = todayVenues[1].name
            self.secondVenueAddressLbl.text = "Sydney, Australia" //todayVenues[1].name
            self.secondVenueVotesLbl.text = todayVenues[1].votes?.description
            
            self.thirdVenueNameLbl.text = todayVenues[2].name
            self.thirdVenueAddressLbl.text = "Sydney, Australia" //todayVenues[2].name
            self.thirdVenueVotesLbl.text = todayVenues[2].votes?.description
        }
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
//    }

}
