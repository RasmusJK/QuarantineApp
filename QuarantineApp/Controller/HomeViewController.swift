//
//  HomeViewController.swift
//  QuarantineApp
//
//  Created by Roope Vaarama on 14.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Properties
    @IBOutlet var itemTableView: UITableView!
    @IBOutlet var categorySegment: LocalizedUISegmentedControl!
    let testTopMedia = ["Movie", "Show", "Game", "Stream"]
    let testTopMovies = ["Movie1", "Movie2", "Movie3", "Movie4", "Movie5"]
    let testTopShows = ["Show1", "Show2", "Show3", "Show4", "Show5"]
    let testTopGames = ["Game1", "Game2", "Game3", "Game4", "Game5"]
    let testTopStreams = ["Stream1", "Stream2", "Stream3", "Stream4", "Stream5"]
    lazy var mediaToDisplay = testTopMedia
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTableView.delegate = self
        itemTableView.dataSource = self
        
        // Setting an event for segment changing
        categorySegment.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        
        //MARK: Firebase testing
        let db = Firestore.firestore()
        let testText = "toimiiko?"
        //Add
        db.collection("testing").addDocument(data: ["text": testText])
        //Get
        db.collection("testing").whereField("text", isEqualTo: testText).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting Firestore data: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    print("id: \(doc.documentID), data: \(doc.data())")
                }
            }
        }
        
    }
    
    //MARK: Private methods
    @objc fileprivate func handleSegmentChange(){
        switch categorySegment.selectedSegmentIndex {
        case 0:
            mediaToDisplay = testTopMedia
        case 1:
            mediaToDisplay = testTopMovies
        case 2:
            mediaToDisplay = testTopShows
        case 3:
            mediaToDisplay = testTopGames
        case 4:
            mediaToDisplay = testTopStreams
        default:
            mediaToDisplay = testTopMedia
        }
        itemTableView.reloadData()
    }
}

extension HomeViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaToDisplay.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (categorySegment.selectedSegmentIndex == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopItemCell", for: indexPath) as! TopItemTableViewCell
            cell.Title.text = "Top \(mediaToDisplay[0])"
            cell.Users.text = "Top \(mediaToDisplay[0])"
            cell.Available.text = "Top \(mediaToDisplay[0])"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
            cell.Title.text = mediaToDisplay[0]
            cell.Users.text = mediaToDisplay[0]
            cell.Available.text = mediaToDisplay[0]
            return cell
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

