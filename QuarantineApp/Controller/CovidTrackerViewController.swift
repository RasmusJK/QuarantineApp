//
//  CovidTrackerViewController.swift
//  QuarantineApp
//
//  Created by iosdev on 14.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit

class CovidTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CovidAPIDelegate {
    //MARK: Properties
    let transition = SlideInTransition()
    var menuIsActive = false
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var deadLabel: UILabel!
    @IBOutlet weak var recoveredLabel: UILabel!
    @IBOutlet weak var countryTableView: UITableView!
    @IBOutlet var menuButton: UIButton!
    
    
    let covidApi = CovidAPI()
    var covidCountryList = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryTableView.dataSource = self
        countryTableView.delegate = self
        
        // Set action for menu button
        menuButton.addTarget(self, action: #selector(menuPressed), for: .touchUpInside)
        
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
extension CovidTrackerViewController : UIViewControllerTransitioningDelegate {
    /**
        Shows and dismisses the side/burger menu
    */
    @objc func menuPressed() {
        if !menuIsActive {
            guard let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
            menuViewController.didTapMenuItem = { menuItem in
                print(menuItem)
                //self.changeView(menuItem)
                }
            menuViewController.modalPresentationStyle = .overCurrentContext
            menuViewController.transitioningDelegate = self
            menuIsActive = true
            present(menuViewController, animated: true)
        } else {
            menuIsActive = false
            dismiss(animated: true, completion: {
                print("Dismissing menu")
            })
        }
    }
    func changeView(_ menuItem: menuItem)  {
        switch menuItem {
            case .profile:
                present(((storyboard?.instantiateViewController(withIdentifier: "Profile"))!), animated: true)
            case .tracker:
                performSegue(withIdentifier: "tracker", sender: self)
            case .help:
                print("ASD")
            case .logout:
                print("asd")
        }
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isActive = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isActive = false
        return transition
    }
}
