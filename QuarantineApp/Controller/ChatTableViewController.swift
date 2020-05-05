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

}
