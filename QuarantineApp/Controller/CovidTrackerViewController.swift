//
//  CovidTrackerViewController.swift
//  QuarantineApp
//
//  Created by iosdev on 14.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit

//Gets data from CovidAPI and prints it to tableView
class CovidTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CovidAPIDelegate {
    //MARK: Properties
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var countryTableView: UITableView!
    @IBOutlet var menuButton: UIButton!
    
    
    let covidApi = CovidAPI()
    var covidCountryList: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryTableView.dataSource = self
        countryTableView.delegate = self
        
        covidApi.url = "https://coronavirus-19-api.herokuapp.com/countries"
        covidApi.covidAPIDelegate = self
        covidApi.getData()
    }
    
    //MARK: Delegated data
    func newData(_ covidData: CovidData?) {
        DispatchQueue.main.async {
            //Some rows from APi weren't countries, hard coded them away
            let notCountry = ["Africa", "Asia", "Europe", "North America", "South America", "Oceania", "World", " ", "", "Total:"]
            if covidData?.country == "World" {
                self.totalLabel.text = "World: \(covidData?.cases ?? 0) | \(covidData?.deaths ?? 0) | \(covidData?.recovered ?? 0)"
            }
            if !notCountry.contains(covidData!.country)  {
                self.covidCountryList.append("\(covidData?.country ?? "error"): \(covidData?.cases ?? 0) | \(covidData?.deaths ?? 0) | \(covidData?.recovered ?? 0)")
                self.countryTableView.reloadData()
            }
        }
    }
    
    //MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return covidCountryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        covidCountryList.sort()
        cell.textLabel!.text = covidCountryList[indexPath.row]
        return cell
    }
    
}

