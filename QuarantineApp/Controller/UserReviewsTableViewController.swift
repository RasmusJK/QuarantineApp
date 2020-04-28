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
import FirebaseAuth
import FirebaseFirestore

class UserReviewsTableViewController: UITableViewController {
    
    //MARK: Properties
    var allUserReviews = [UserReview]()
    var allUserReviewsFromDb = [UserReview]()
    var userReviews = [UserReview]()
    var listtt = [String]()
    var selectedCategory: String?
    var newReview: UserReview!
    var listofuserreviews = [String]()
    let db = Firestore.firestore()
    var list = [String: Any]()
    var titles = [String]()
    var titleof = ""
    var reviewof = ""
    var finallist = [String: Any]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Just showing the category, doesnt matter at the moment tho
        print("this is what u got as a category \(String(describing: selectedCategory))")
        guard let currentCategory = selectedCategory else {
            fatalError("dont have a category")
        }
        print("as string: \(currentCategory)")
        
        
        //Calls a function that fetches the user reviews from database
        downloadUserReviewsNow() { reviewArray, error in
        if let error = error {
           return
        }
            self.list = reviewArray
            print("this is the dictionary object \(reviewArray)")
        
            var movietitle = ""
            var movierating = ""
            var reviewtext = ""
            var username = ""
    
        for (key, value) in self.list {
                print(" single value and key:\(key) \(value)")
                
            movietitle = self.list["reviewItem"] as! String
            movierating = self.list["reviewText"] as! String
            reviewtext = self.list["reviewText"] as! String
            username = self.list["reviewUser"] as! String
            }
                
        let object = UserReview(title: movietitle, rating: movierating, username: username, review: reviewtext)
        self.userReviews.append(object ?? UserReview(title: "no value", rating: "no value", username: "no value", review: "no value")! )

        self.tableView.reloadData()
        }
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
 
    //    let userRev = String(describing: list[indexPath.row])
      //  print("for the cell: \(userRev)")
      //  cell.reviewTextLabel.text = userRev
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
    
    /*
     //OLD VERSION
    private func loadUserReviews() {
        
        //MARK: Firebase User review testing
        //Get
        db.collection("reviews").getDocuments() { (querySnapshot, err) in
        if let err = err {
        print("Error getting Firestore data: \(err)")
        } else {
            for doc in querySnapshot!.documents {
               // print("id: \(doc.documentID), data: ç(doc.data())")
                var data = String(describing: doc.data())
             //   print("data: \(data)")
                self.list.append("\(doc.data())")
                }
            print("thisis list \(self.list)")
            }
        }
    }
    */

    //Function for fetching user reviews from database that's called on the viewDidLoad
    func downloadUserReviewsNow(completion: @escaping ([String: Any], Error?) -> Void) {
        var reviewArray = [String: Any]()
        db.collection("reviews").getDocuments { QuerySnapshot, error in
          if let error = error {
            print(error)
            completion(reviewArray, error)
            return
          }
            
          for doc in QuerySnapshot!.documents {
            let data = doc.data()
            reviewArray = data
            
            completion(reviewArray, error)
            }
        }
        
        /*
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
 */
    }
    
    //MARK: Actions
    
    //This should receive the new review from the add view but its not working atm will check later
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? CreateReviewViewController, let newReview = sourceViewController.review {

                //Add a new review
                let newIndexPath = IndexPath(row: userReviews.count, section: 0)
                let newReviewAsString = String(describing: "\(newReview)")
            
                userReviews.append(newReview)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            
           downloadUserReviewsNow() { reviewArray, error in
            if let error = error {
               return
            }
              self.list = reviewArray
              self.tableView.reloadData()
            }
        }
    }
}
