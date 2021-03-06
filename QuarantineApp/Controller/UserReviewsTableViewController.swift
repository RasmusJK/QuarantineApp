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
    var userOptional: String?
    var movies = NSLocalizedString("Movies", comment: "")
    var tvshows = NSLocalizedString("TV Shows", comment: "")
    var games = NSLocalizedString("Games", comment: "")
    var books = NSLocalizedString("Books", comment: "")
    var sports = NSLocalizedString("Sports", comment: "")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Showing the selected category gotten from the previous viewcontroller
        //and translates it into english if application language is Finnish
        print("this is what u got as a category \(String(describing: selectedCategory))")
        if selectedCategory == "Elokuvat" {
            selectedCategory = "Movies"
        }
        else if selectedCategory == "TV Sarjat" {
            selectedCategory = "TV Shows"
        }
        else if selectedCategory == "Kirjat" {
            selectedCategory = "Books"
        }
        else if selectedCategory == "Pelit" {
            selectedCategory = "Games"
        }
        
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
            var reviewCategory = ""
    
        //Maps through the key value pairs and gets each reviews info
        for (key, value) in self.list {
                print(" single value and key:\(key) \(value)")
                
            movietitle = self.list["reviewItem"] as! String
            movierating = self.list["reviewRating"] as! String
            reviewtext = self.list["reviewText"] as! String
            username = self.list["reviewUser"]! as! String
            reviewCategory = self.list["reviewCategory"] as? String ?? "no category"
            }
          
        //Creates a UserReview object of the fetched review
        let object = UserReview(title: movietitle, rating: movierating, username: username, review: reviewtext, category: reviewCategory) ?? UserReview(title: "no value", rating: "no value", username: "no value", review: "no value", category: "no value")!
         
            //If objects category matches the selected category the object is
            //added to the list shown on the tableview
            if object.category == self.selectedCategory {
                self.userReviews.append(object ?? UserReview(title: "no value", rating: "no value", username: "no value", review: "no value", category: "no value")! )
            }
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
        cell.ratingTextLabel.text = userRev.rating

        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    //MARK: Private functions

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
    }
    
    //MARK: Actions
    
    //This receives the new review from the add view
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
