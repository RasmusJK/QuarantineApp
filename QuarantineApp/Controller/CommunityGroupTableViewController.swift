//
//  CommunityGroupTableViewController.swift
//  QuarantineApp
//
//  Created by iosdev on 16.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit

class CommunityGroupTableViewController: UITableViewController {
    //MARK: Properties
    
    var communityGroups = [CommunityGroup]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadCommunityGroups()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return communityGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CommunityGroupTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CommunityGroupTableViewCell else {
            fatalError("fucked up loading data to groupcell")
        }
            
        let communityGroupCreated = communityGroups[indexPath.row]
        
        cell.communityGroupImage.image = communityGroupCreated.image
        cell.communityGroupTitle.text = communityGroupCreated.title

        // Configure the cell...

        return cell
    }
    
    //MARK: Private functions
    
    private func loadCommunityGroups() {
        
     let communitygroupPhoto1 = UIImage(named: "CommunityIcon")
       
           guard let communityGroup1 = CommunityGroup(title: "Discord Covid Server", image: communitygroupPhoto1) else {
               fatalError("prob with the communitygroup")
               }
           guard let communityGroup2 = CommunityGroup(title: "Discord: Quarantine Chat", image: communitygroupPhoto1) else {
           fatalError("prob with the communitygroup")
           }
           guard let communityGroup3 = CommunityGroup(title: "TOP Steam Group", image: communitygroupPhoto1) else {
           fatalError("prob with the communitygroup")
           }
           guard let communityGroup4 = CommunityGroup(title: "GAME & BEER Server", image: communitygroupPhoto1) else {
           fatalError("prob with the communitygroup")
           }
           guard let communityGroup5 = CommunityGroup(title: "Discord: Random Shit", image: communitygroupPhoto1) else {
           fatalError("prob with the communitygroup")
           }
           guard let communityGroup6 = CommunityGroup(title: "Steam: Game Company", image: communitygroupPhoto1) else {
           fatalError("prob with the communitygroup")
           }
           
           communityGroups += [communityGroup1, communityGroup2, communityGroup3, communityGroup4, communityGroup5, communityGroup6]
    }

}
