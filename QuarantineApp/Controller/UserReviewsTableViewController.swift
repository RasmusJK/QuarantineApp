//
//  UserReviewsTableViewController.swift
//  QuarantineApp
//
//  Created by iosdev on 22.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit
import os.log
import Firebase

class UserReviewsTableViewController: UITableViewController {
    
    var allUserReviews = [UserReview]()
    var allUserReviewsFromDb = [UserReview]()
    var userReviews = [UserReview]()
    var selectedCategory: String?
    var newReview: UserReview!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("this is what u got as a category \(String(describing: selectedCategory))")
        guard let currentCategory = selectedCategory else {
            fatalError("dont have a category")
        }
        print("as string: \(currentCategory)")
        
        //MARK: Firebase User review testing
        let db = Firestore.firestore()
        
        //Get
        db.collection("reviews").getDocuments() { (querySnapshot, err) in
        if let err = err {
        print("Error getting Firestore data: \(err)")
        } else {
        for doc in querySnapshot!.documents {
            print("id: \(doc.documentID), data: \(doc.data())")
        }
            
        }
        }

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    //MARK: Private functions
    
    private func loadUserReviews() {
        
        guard let rev1 = UserReview(title: "Harry Potter", rating: "5", username: "testuser", review: "Harry Potter is the best book ever") else {
        fatalError("prob with the smhth")
        }
        guard let rev2 = UserReview(title: "Harry Potter 2", rating: "4", username: "testuser", review: "Harry Potter is the best book ever") else {
        fatalError("prob with the smhth")
        }
        guard let rev3 = UserReview(title: "Harry Potter", rating: "5", username: "testuser", review: "Harry Potter is the best book ever") else {
        fatalError("prob with the smhth")
        }
        guard let rev4 = UserReview(title: "Harry Potter", rating: "5", username: "testuser", review: "Harry Potter is the best book ever") else {
        fatalError("prob with the smhth")
        }
        guard let rev5 = UserReview(title: "Harry Potter", rating: "5", username: "testuser", review: "Harry Potter is the best book ever") else {
        fatalError("prob with the smhth")
        }
        guard let rev6 = UserReview(title: "Harry Potter", rating: "5", username: "testuser", review: "Harry Potter is the best book ever") else {
        fatalError("prob with the smhth")
        }
      
        allUserReviews += [rev1, rev2, rev3, rev4, rev5, rev6]
        for i in allUserReviews {
          //  if i.category == selectedCategory {
                userReviews += [i]
            }
        }
    
    //MARK: Actions
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? CreateReviewViewController, let newReview = sourceViewController.review {

                //Add a new review
                let newIndexPath = IndexPath(row: userReviews.count, section: 0)
                
                userReviews.append(newReview)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }

}
