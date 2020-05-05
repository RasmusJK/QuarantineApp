//
//  ProfileViewController.swift
//  QuarantineApp
//
//  Created by iosdev on 14.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let db = Firestore.firestore()
    var userReviews = [UserReview]()
    var list = [String: Any]()
   //var reviewArray = [String: Any]()
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var profileTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.delegate = self
        profileTableView.dataSource = self
      
       //getData()
       
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
        
            for (key, value) in self.list {
                    print(" single value and key:\(key) \(value)")
                    
                movietitle = self.list["reviewItem"] as! String
                movierating = self.list["reviewRating"] as! String
                reviewtext = self.list["reviewText"] as! String
                username = self.list["reviewUser"] as! String
                reviewCategory = self.list["reviewCategory"] as? String ?? "no category"
                }
                    
            let object = UserReview(title: movietitle, rating: movierating, username: username, review: reviewtext, category: reviewCategory) ?? UserReview(title: "no value", rating: "no value", username: "no value", review: "no value", category: "no value")!
                
                
                    self.userReviews.append(object ?? UserReview(title: "no value", rating: "no value", username: "no value", review: "no value", category: "no value")! )
                
            self.profileTableView.reloadData()
            }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser?.email != nil {
            usernameLabel.text = Auth.auth().currentUser?.email?.replacingOccurrences(of: "@quarantodo.info", with: "") ?? "Anonymous"
            
        } else {
            performSegue(withIdentifier: "toAuth", sender: nil)
        }
    }
    //MARK: TableviewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return userReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileTableViewCell else {
            fatalError("rip")
        }
        
        let myRev = userReviews[indexPath.row]
        
        cell.profileTitleLabel.text = myRev.title
        cell.profileTextLabel.text = myRev.review
        cell.profileRatingLabel.text = "\(myRev.rating)/5"
    
        
        return cell
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    //OLD GETDATA
    /*func getData() {
        
        db.collection("reviews").whereField("reviewUser", isEqualTo: "testuser").getDocuments() {(querySnapshot,err)  in
           
            if let err = err {
                print("error getting documents \(err)")
            } else {
                for document in querySnapshot!.documents {
                   // print(document.data())
                    let data = document.data()
                    self.reviewArray = data
                    
                    print("reviewArray", self.reviewArray)
                    
                            var movietitle = ""
                            var movierating = ""
                            var reviewtext = ""
                            var username = ""
                            var reviewCategory = ""
                    
                        for (key, value) in self.list {
                                print(" single value and key:\(key) \(value)")
                                
                            movietitle = self.list["reviewItem"] as! String
                            movierating = self.list["reviewRating"] as! String
                            reviewtext = self.list["reviewText"] as! String
                            username = self.list["reviewUser"] as! String
                            reviewCategory = self.list["reviewCategory"] as? String ?? "no category"
                            }
                     let object = UserReview(title: movietitle, rating: movierating, username: username, review: reviewtext, category: reviewCategory) ?? UserReview(title: "no value", rating: "no value", username: "no value", review: "no value", category: "no value")!
                    
                    self.userReviews.append(object ?? UserReview(title: "no value", rating: "no value", username: "no value", review: "no value", category: "no value")! )
                    
                    self.profileTableView.reloadData()

                }
            }
        }
    }
    */
    func downloadUserReviewsNow(completion: @escaping ([String: Any], Error?) -> Void) {
    var reviewArray = [String: Any]()
        db.collection("reviews").whereField("reviewUser", isEqualTo: "testuser").getDocuments { QuerySnapshot, error in
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
    @IBAction func logoutButton(_ sender: UIButton) {
        //Logout from firebase
        do {
            try Auth.auth().signOut()
        } catch let err as NSError {
            print ("Auth: \(err)")
        }
        print("Auth: Logged out")
        performSegue(withIdentifier: "toAuth", sender: nil)
    }
    
    
}
