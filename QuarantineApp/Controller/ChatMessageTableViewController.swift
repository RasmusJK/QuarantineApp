//
//  ChatMessageTableViewController.swift
//  QuarantineApp
//
//  Created by iosdev on 4.5.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit
import os.log
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ChatMessageTableViewController: UITableViewController {
    
    //MARK: Properties
    var allUserReviews = [UserReview]()
    var allUserReviewsFromDb = [UserReview]()
    var userReviews = [UserReview]()
    var listtt = [String]()
    var selectedCategory: String?
    var selectedCity: String?
    var newReview: UserReview!
    var listofuserreviews = [String]()
    let db = Firestore.firestore()
    var list = [String: Any]()
    var titles = [String]()
    var titleof = ""
    var reviewof = ""
    var finallist = [String: Any]()
    var chatMessages = [ChatMessage]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Just showing the category, doesnt matter at the moment tho
        print("this is what u got as a category \(String(describing: selectedCity))")
        guard let currentCategory = selectedCity else {
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
        
            var chatRoom = ""
            var chatUsername = ""
            var chatMessage = ""
    
        for (key, value) in self.list {
                print(" single value and key:\(key) \(value)")
                
            chatRoom = self.list["chatRoom"] as! String
            chatUsername = self.list["chatUser"] as! String
            chatMessage = self.list["chatText"] as! String
            }
            
        let object = ChatMessage(chatRoom: chatRoom, chatUsername: chatUsername, chatMessage: chatMessage) ?? ChatMessage(chatRoom: "No Room", chatUsername: "no user", chatMessage: "no message")!
            
            if object.chatRoom == self.selectedCity {
                self.chatMessages.append(object ?? ChatMessage(chatRoom: "No Room", chatUsername: "no user", chatMessage: "no message")!)
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
        return chatMessages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "messageCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChatMessageTableViewCell else {
            fatalError("fucked up loading data to userreview")
        }
            
        let userRev = chatMessages[indexPath.row]

        cell.chatMessageLabel.text = userRev.chatMessage
        cell.usernameLabel.text = userRev.chatUsername
 
    //    let userRev = String(describing: list[indexPath.row])
      //  print("for the cell: \(userRev)")
      //  cell.reviewTextLabel.text = userRev
        // Configure the cell...

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
        db.collection("chat").getDocuments { QuerySnapshot, error in
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
    
    
    //This should receive the new review from the add view but its not working atm will check later
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? CreateChatMessageViewController, let newMessage = sourceViewController.message{

                //Add a new review
                let newIndexPath = IndexPath(row: chatMessages.count, section: 0)
                let newMessageAsString = String(describing: "\(newMessage)")
            
                chatMessages.append(newMessage)
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
