//
//  UserReviewsTableViewController.swift
//  QuarantineApp
//
//  Created by iosdev on 22.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit
import os.log

class UserReviewsTableViewController: UITableViewController {
    
    var userReviews = [UserReview]()
    var selectedCategory: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        let categorySelected = selectedCategory

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadUserReviews()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userReviews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "userReviewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserReviewTableViewCell else {
            fatalError("fucked up loading data to userreview")
        }
            
        let userRev = userReviews[indexPath.row]
        
        cell.reviewItemTitleLabel.text = userRev.title
        cell.reviewerUsernameLabel.text = userRev.username
        cell.reviewTextLabel.text = userRev.review
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
    
    //MARK: Private functions
    
    private func loadUserReviews() {
        
        guard let rev1 = UserReview(category: "book", title: "Harry Potter", username: "testuser", review: "Harry Potter is the best book ever") else {
        fatalError("prob with the smhth")
        }
        guard let rev2 = UserReview(category: "movie", title: "The Movie", username: "dude", review: "I hated this movie but I still watch it everyday.") else {
        fatalError("prob with the ")
        }
        guard let rev3 = UserReview(category: "game", title: "CS", username: "yeehaaw", review: "I play this game every day. It makes my quarantine feel like a holiday.") else {
        fatalError("prob with the ")
        }
        guard let rev4 = UserReview(category: "book", title: "How to Live in A Quarantine", username: "bookuser", review: "Nice book.") else {
        fatalError("prob with the ")
        }
        guard let rev5 = UserReview(category: "movie", title: "The Hobit", username: "quarantineloser", review: "I write some stuff that doesn't help you.") else {
        fatalError("prob with the ")
        }
        guard let rev6 = UserReview(category: "game", title: "Half Life Alyx", username: "VRboeh", review: "I live my VR glasses on and I have a new life now in this game.") else {
        fatalError("prob with the ")
        }
      
        userReviews += [rev1, rev2, rev3, rev4, rev5, rev6]
        
    }

}
