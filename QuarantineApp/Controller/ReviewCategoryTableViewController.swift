//
//  ReviewCategoryTableViewController.swift
//  QuarantineApp
//
//  Created by iosdev on 16.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit
import os.log

class ReviewCategoryTableViewController: UITableViewController {
    
    //MARK: Properties
    var reviewCategories = [ReviewCategory]()
    var selectedCategory: String?
    @IBOutlet weak var segmentControl: UINavigationItem!
    var movies = NSLocalizedString("Movies", comment: "")
    var tvshows = NSLocalizedString("TV Series", comment: "")
    var games = NSLocalizedString("Games", comment: "")
    var books = NSLocalizedString("Books", comment: "")
    var sports = NSLocalizedString("Sports", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Calls the function that loads review categories to table view
        loadReviewCategories()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reviewCategories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ReviewCategoryTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ReviewCategoryTableViewCell else {
            fatalError("")
        }
        
        let reviewCategoryCreated = reviewCategories[indexPath.row]
        
        cell.reviewCategoryTitle.text = reviewCategoryCreated.title
        cell.reviewCategoryImage.image = reviewCategoryCreated.image
        
        selectedCategory = reviewCategoryCreated.title
        print("category option: \(String(describing: selectedCategory))")
        
        // Configure the cell...

        return cell
    }

    // MARK: Navigation to selected category's user reviews
    
    //The segue sends the selected category as string to the next viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "userReviewSegue":
            guard let userReviewsTableViewController2 = segue.destination as? UserReviewsTableViewController else {
                fatalError("somethings wrong with the userreview segue")
            }
            
            guard let selectedReviewCategory = sender as? ReviewCategoryTableViewCell else {
                fatalError("issue cell")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedReviewCategory) else {
                fatalError("")
            }
            
            let selectedC = reviewCategories[indexPath.row]
            userReviewsTableViewController2.selectedCategory = selectedC.title
        default:
            fatalError("")
        }
    }
    
    //MARK: Private functions

    //This function loads the review categories to the table view
    private func loadReviewCategories() {
        
        let reviewCategoryPhoto1 = UIImage(named: "Reviews")
        let reviewCategoryPhoto2 = UIImage(named: "tvshows")
        let reviewCategoryBooksPhoto = UIImage(named: "books")
        let reviewCategoryGames = UIImage(named: "games")
        
        guard let reviewCategory1 = ReviewCategory(title: movies, image: reviewCategoryPhoto1) else {
            print("issue with the category")
            fatalError("Unable to get reviewCategory")
        }

        guard let reviewCategory4 = ReviewCategory(title: tvshows, image: reviewCategoryPhoto2) else {
            print("issue with the category")
            fatalError("Unable to get reviewCategory")
        }
        guard let reviewCategory2 = ReviewCategory(title: games, image: reviewCategoryGames) else {
            print("issue with the category")
            fatalError("Unable to get reviewCategory")
        }
        guard let reviewCategory3 = ReviewCategory(title: books, image: reviewCategoryBooksPhoto) else {
            print("issue with the category")
            fatalError("Unable to get reviewCategory")
        }
        
        reviewCategories += [reviewCategory1, reviewCategory2, reviewCategory3, reviewCategory4]
    }

}
