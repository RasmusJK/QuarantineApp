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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Frivate functions
    
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
