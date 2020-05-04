//
//  ChatTableViewController.swift
//  QuarantineApp
//
//  Created by iosdev on 4.5.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

//  Created by iosdev on 16.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit
import os.log

class ChatTableViewController: UITableViewController {
    
    //MARK: Properties
    //var cities = [String]()
    var selectedCity: String?
    var cities = ["Helsinki", "Vantaa", "Espoo", "Tampere"]
    @IBOutlet weak var segmentControl: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        loadReviewCategories()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ChatCityCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChatTableViewCell else {
            fatalError("")
        }
        
        let city = cities[indexPath.row]
        
        cell.cityLabel.text = city
        
        selectedCity = city
        
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
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "chatmessageSeque":
            guard let chatTableViewController2 = segue.destination as? ChatMessageTableViewController else {
                fatalError("somethings wrong with the userreview segue")
            }
            
            guard let selectedCity = sender as? ChatTableViewCell else {
                fatalError("issue cell")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCity) else {
                fatalError("")
            }
            
            let selectedC = cities[indexPath.row]
            chatTableViewController2.selectedCity = selectedC
        default:
            fatalError("")
        }
    }
    
    //MARK: Private functions
    
    private func loadReviewCategories() {
        
      /*  guard let reviewCategory1 = ReviewCategory(title: "Movies", image: reviewCategoryPhoto1) else {
            print("fucked up with title")
            fatalError("Unable to get reviewCategory")
        }
        guard let reviewCategory4 = ReviewCategory(title: "TV Series", image: reviewCategoryPhoto2) else {
            print("fucked up with title")
            fatalError("Unable to get reviewCategory")
        }
        guard let reviewCategory2 = ReviewCategory(title: "Games", image: reviewCategoryGames) else {
            print("fucked up with image")
            fatalError("Unable to get reviewCategory")
        }
        guard let reviewCategory3 = ReviewCategory(title: "Books", image: reviewCategoryBooksPhoto) else {
            print("fucked up with image")
            fatalError("Unable to get reviewCategory")
        }
    /*    guard let reviewCategory4 = ReviewCategory(title: "TV Show Reviews", image: reviewCategoryTvPhoto) else {
            print("fucked up with image")
            fatalError("Unable to get reviewCategory")
        } */
        
        reviewCategories += [reviewCategory1, reviewCategory2, reviewCategory3, reviewCategory4]
    }
 /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "userReviewSegue") {
            if let destination = segue.destination as? UserReviewsTableViewController {
                print("you are going to see reviews from the category: \(selectedCategory)")
                destination.selectedCategory = "\(selectedCategory)"
            }
        }
    } */ */
    }
}
