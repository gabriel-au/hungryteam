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
        
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        
        cell!.textLabel?.text = venueName
        cell!.detailTextLabel?.text = dateFormatter.stringFromDate(vote.date!)
        
        return cell!
    }
    
    deinit {
        self.ref.child("votes").removeObserverWithHandle(_refHandle)
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("votes").observeEventType(.Value, withBlock: { (snapshot) -> Void in
            
            self.todaysVote = []
            self.lastVotes = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    
                    if snap.hasChildren() {
                        self.venues = []
                        
                        for child in snap.children {

                            
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

}
