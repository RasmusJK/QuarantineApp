//
//  CovidTrackerViewController.swift
//  QuarantineApp
//
//  Created by iosdev on 14.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit

class CovidTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CovidAPIDelegate {
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var deadLabel: UILabel!
    @IBOutlet weak var recoveredLabel: UILabel!
    @IBOutlet weak var countryTableView: UITableView!
    
    
    let covidApi = CovidAPI()
    var covidCountryList = [""]
    
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
            let notCountry = ["Africa", "Asia", "Europe", "North America", "South America", "Oceania", "World", "", "Total:"]
            if covidData?.country == "World" {
                self.totalLabel.text = "Cases: \(covidData?.cases ?? 0)"
                self.deadLabel.text = "Deaths: \(covidData?.deaths ?? 0)"
                self.recoveredLabel.text = "Recovered: \(covidData?.recovered ?? 0)"
            }
            if !notCountry.contains(covidData?.country ?? "unknown")  {
                self.covidCountryList.append("\(covidData?.country ?? "unknown"): \(covidData?.cases ?? 0)")
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
        cell.textLabel!.text = covidCountryList[indexPath.row]
        return cell
    }
    
}
