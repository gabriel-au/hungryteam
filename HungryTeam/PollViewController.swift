//
//  PollViewController.swift
//  HungryTeam
//
//  Created by Gabriel Silva on 21/08/2016.
//  Copyright © 2016 Gabriel Silva. All rights reserved.
//

import UIKit

class PollViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var pollTableView: UITableView!
    
    var venues: [Venue] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forDevTests()

        // Do any additional setup after loading the view.
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
        return venues.count ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("pollCell");
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "pollCell")
        }
        
        let venue = venues[indexPath.row]
        
        cell!.textLabel?.text = venue.name
        cell!.detailTextLabel?.text = venue.address
        
        return cell!
    }
    
    func forDevTests() {
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
    }

}
