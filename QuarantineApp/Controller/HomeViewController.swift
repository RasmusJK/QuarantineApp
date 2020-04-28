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
import FirebaseAuth
import CoreData


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SteamAPIDelegate, NetflixAPIDelegate, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    // Receives data from the Steam API and saves it to the FetchedResultsController
    func newData(_ steamData: SteamData?) {
        DispatchQueue.main.async {
            for item in steamData! {
                self.saveGameToCoreData(title: item.value.name ?? "", developer: item.value.developer ?? "", avg2weeks: item.value.average2Weeks ?? 0, appid: item.value.appid ?? 0)
            }
            self.fetchResultsToController(entity: "Games")
        }
    }
    
    //Receives data from the Netflix API and saves it to the FetchedResultsController
    func newData(_ netflixInfo: NetflixInfo?, categorySwitch : String) {
        DispatchQueue.main.async {
            if categorySwitch == "NetflixMovie" {
                for info in (netflixInfo?.results)! {
                    self.saveMovieToCoreData(title: info.title ?? "", desc: info.synopsis ?? "", imgurl: info.img ?? "", imbdrating: info.imdbrating ?? 0.0)
                    
                }
                self.fetchResultsToController(entity: categorySwitch)
            } else if categorySwitch == "NetflixSeries" {
                for info in (netflixInfo?.results)! {
                    self.saveSeriesToCoreData(title: info.title ?? "", desc: info.synopsis ?? "", imgurl: info.img ?? "", imbdrating: info.imdbrating ?? 0.0)
                }
                self.fetchResultsToController(entity: categorySwitch)
            }
        }
    }
    
    //MARK: Properties
    @IBOutlet var itemTableView: UITableView!
    @IBOutlet var categorySegment: LocalizedUISegmentedControl!
    let transition = SlideInTransition()
    let steamAPI = SteamAPI()
    var menuIsActive = false
    let netflixAPI : NetflixAPI = NetflixAPI()
    let testTopMedia = ["Movie", "Show", "Game", "Stream"]
    @IBOutlet var menuButton: UIButton!
    var movieFetchedResultsController : NSFetchedResultsController<NetflixMovie>!
    var seriesFetchedResultsController : NSFetchedResultsController<NetflixSeries>!
    var gamesFetchedResultsController : NSFetchedResultsController<Games>!
    //Firebase Auth handler
    var handle: AuthStateDidChangeListenerHandle?
    
    //Search controller properties
    let searchController = UISearchController(searchResultsController: nil)
    //Var filtered : [?] = []
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    var MediaSource: String = "All"
    
    
    @IBAction func emptyCoreDataDebug(_ sender: UIButton) {
        deleteAllCoreData(entity: "NetflixMovie")
        deleteAllCoreData(entity: "NetflixSeries")
        deleteAllCoreData(entity: "Games")
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: "NetflixMovie")
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: "NetflixSeries")
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: "Games")
        
        //Fetch updated results to FRC
        fetchResultsToController(entity: "NetflixMovie")
        fetchResultsToController(entity: "NetflixSeries")
        fetchResultsToController(entity: "Games")
        
        //Check if deletion was succesful by seeing the number of fetched objects
        print(movieFetchedResultsController.fetchedObjects?.count)
        print(seriesFetchedResultsController.fetchedObjects?.count)
        print(gamesFetchedResultsController.fetchedObjects?.count)
        
        itemTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTableView.delegate = self
        itemTableView.dataSource = self
        netflixAPI.netflixAPIDelegate = self
        steamAPI.steamAPIDelegate = self
        steamAPI.url = "https://steamspy.com/api.php?request=top100in2weeks"
        
        fetchResultsToController(entity: "NetflixMovie")
        fetchResultsToController(entity: "NetflixSeries")
        fetchResultsToController(entity: "Games")
        
        var categorySwitch : String
        
        if (movieFetchedResultsController.fetchedObjects!.count == 0) {
            categorySwitch = "NetflixMovie"
            //MARK: UNCOMMENT THIS ONLY WHEN NEEDED OTHERWISE TOPI GETS CHARGED >:D
            //netflixAPI.getData(categorySwitch: categorySwitch)
        }
        if (seriesFetchedResultsController.fetchedObjects!.count == 0) {
            categorySwitch = "NetflixSeries"
            //MARK: UNCOMMENT THIS ONLY WHEN NEEDED OTHERWISE TOPI GETS CHARGED >:D
            //netflixAPI.getData(categorySwitch: categorySwitch)
        }
        if (gamesFetchedResultsController.fetchedObjects!.count == 0) {
            steamAPI.getData()
        }
        
        // Setting an event for segment changing
        categorySegment.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        
        // Set action for menu button
        menuButton.addTarget(self, action: #selector(menuPressed), for: .touchUpInside)
        
        //Firebase Auth handler (filter console to "Auth")
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let userId = user?.uid {
                print("Auth: \(userId), username: \(user?.email?.replacingOccurrences(of: "@quarantodo.info", with: "") ?? "Anonymous")")
            } else {
                print("Auth: No user")
            }
        }
        
        //Check auth at start
        if Auth.auth().currentUser?.uid == nil {
            print("Auth: No user logged in, going to auth =>")
            performSegue(withIdentifier: "Auth", sender: self)
        }
        
        // Set up the search bar controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    /*
    override func viewDidAppear(_ animated: Bool) {
        //MARK: Firebase testing
        let db = Firestore.firestore()
        let reviewItem = "Titanic"
        let reviewRating = 3
        let reviewText = "Not so bad movie"
        let reviewUser = Auth.auth().currentUser?.email?.replacingOccurrences(of: "@quarantodo.info", with: "") ?? "Anonymous"
        //Add
        db.collection("reviews").addDocument(data: [
            "reviewItem": reviewItem,
            "reviewRating": reviewRating,
            "reviewText": reviewText,
            "reviewUser": reviewUser,
        ])
        //Get
        db.collection("reviews").whereField("reviewItem", isEqualTo: "Titanic").getDocuments() { (querySnapshot, err) in
            var rating = 0.0
            var count = 1
            if let err = err {
                print("Error getting Firestore data: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    print("FireStore: \(doc.data())")
                    // doc.data()["FIELDIN NIMI"]
                    let number = doc.data()["reviewRating"]
                    rating += number as! Double
                    count += 1
                }
                rating = rating/Double(count)
                print("FireStore: example rating for Titanic is \(rating)")
            }
        }
    }*/
    
    func saveToCoreData(gameTitle : String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Games", in: managedContext)!
        
        let gameItem = NSManagedObject(entity: entity, insertInto: managedContext)
        
        gameItem.setValue(gameTitle, forKeyPath: "gameTitle")
        
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error)
        }
    }
    //MARK: Private methods
    
    /**
        Fetch from Core Data using the FetchedResultsController
        
        - Parameter entity: Describes what data entity to fetch
     */

    func fetchResultsToController(entity : String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        managedContext.shouldDeleteInaccessibleFaults = true
        print("Entity name: \(entity)")
        switch entity {
            case "NetflixMovie":
                let fetchRequest = NSFetchRequest<NetflixMovie>(entityName: entity)
                let sortDescriptor = NSSortDescriptor(key: "imbdrating", ascending: false)
                fetchRequest.sortDescriptors = [sortDescriptor]
                fetchRequest.returnsObjectsAsFaults = true
                movieFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: "title", cacheName: entity)
                movieFetchedResultsController!.delegate = self
                try? movieFetchedResultsController?.performFetch()
            case "NetflixSeries":
                let fetchRequest = NSFetchRequest<NetflixSeries>(entityName: entity)
                let sortDescriptor = NSSortDescriptor(key: "imbdrating", ascending: false)
                fetchRequest.sortDescriptors = [sortDescriptor]
                seriesFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: "title", cacheName: entity)
                seriesFetchedResultsController!.delegate = self
                try? seriesFetchedResultsController?.performFetch()
            case "Games":
                let fetchRequest = NSFetchRequest<Games>(entityName: entity)
                let sortDescriptor = NSSortDescriptor(key: "avg2weeks", ascending: false)
                fetchRequest.sortDescriptors = [sortDescriptor]
                gamesFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: "title", cacheName: entity)
                gamesFetchedResultsController!.delegate = self
                try? gamesFetchedResultsController?.performFetch()
            default:
            print("shit dont work")
        }
    }
    
    /**
        Deletes managed objects in Core Data
     
        - PARAMETER entity: Describes which entity to delete from storage
     */
    func deleteAllCoreData(entity : String) {
        print("Deleting core data...")
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        managedContext.shouldDeleteInaccessibleFaults = true
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                let managedObjectData : NSManagedObject = object as! NSManagedObject
                print("Object to delete: \(object)")
                managedContext.delete(managedObjectData)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Error in deleting all data from core data: \(error)")
        }
    }
    
    /**
        Saves a game item to Core Data
     */
    func saveGameToCoreData(title : String, developer: String, avg2weeks : Int, appid : Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
          
        let managedContext = appDelegate.persistentContainer.viewContext
          
        let entity = NSEntityDescription.entity(forEntityName: "Games", in: managedContext)!
          
        let gameItem = NSManagedObject(entity: entity, insertInto: managedContext)
          
        gameItem.setValue(title, forKeyPath: "title")
        gameItem.setValue(developer, forKeyPath: "developer")
        gameItem.setValue(avg2weeks, forKeyPath: "avg2weeks")
        gameItem.setValue(appid, forKeyPath: "appid")
        
          
        do {
            try managedContext.save()
        } catch let error as NSError {
              print(error)
        }
    }
    
    /**
        Saves a movie item to Core Data
     */
    func saveMovieToCoreData(title : String, desc : String, imgurl : String, imbdrating : Double) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "NetflixMovie", in: managedContext)!
        
        let movieItem = NSManagedObject(entity: entity, insertInto: managedContext)
        
        movieItem.setValue(title, forKeyPath: "title")
        movieItem.setValue(desc, forKeyPath: "desc")
        movieItem.setValue(imgurl, forKeyPath: "imgurl")
        movieItem.setValue(imbdrating, forKeyPath: "imbdrating")
      
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    /**
        Saves a series item to Core Data
     */
    func saveSeriesToCoreData(title : String, desc : String, imgurl : String, imbdrating : Double) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "NetflixSeries", in: managedContext)!
        
        let seriesItem = NSManagedObject(entity: entity, insertInto: managedContext)
        
        seriesItem.setValue(title, forKeyPath: "title")
        seriesItem.setValue(desc, forKeyPath: "desc")
        seriesItem.setValue(imgurl, forKeyPath: "imgurl")
        seriesItem.setValue(imbdrating, forKeyPath: "imbdrating")
      
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error)
        }
    }
 
    @objc fileprivate func handleSegmentChange(){
        itemTableView.reloadData()
    }
    //MARK: Placeholder methods
    @IBAction func GOTOAUTH(_ sender: UIButton) {
        performSegue(withIdentifier: "Auth", sender: self)
    }
    
}
/**
    Handles the home page table view
 */
extension HomeViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch categorySegment.selectedSegmentIndex {
        case 0:
            return testTopMedia.count
        case 1:
            return (movieFetchedResultsController.sections?[section].numberOfObjects)!
        case 2:
            return (seriesFetchedResultsController.sections?[section].numberOfObjects)!
        case 3:
            return (gamesFetchedResultsController.sections?[section].numberOfObjects)!
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch categorySegment.selectedSegmentIndex {
        case 0:
            MediaSource = "All"
            searchController.searchBar.placeholder = "Search"
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopItemCell", for: indexPath) as! TopItemTableViewCell
            cell.Title.text = "Top \(testTopMedia[0])"
            cell.DescOrDev.text = "Top \(testTopMedia[0])"
            cell.Rating.text = "Top \(testTopMedia[0])"
            return cell
        case 1:
            MediaSource = "Movies"
            searchController.searchBar.placeholder = "Search \(MediaSource)"
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
            let movie = (movieFetchedResultsController?.object(at: indexPath))!
            cell.Title.text = movie.title
            cell.DescOrDev.text = movie.desc
            cell.Rating.text = String(format:"%.1f", movie.imbdrating )
            
            cell.Title.sizeToFit()
            cell.DescOrDev.sizeToFit()
            cell.Rating.sizeToFit()
            
            //Make the image thumbnail data
            let imgUrl = URL(string: movie.imgurl ?? "")
            if (imgUrl != nil) {
                let imgData = try? Data(contentsOf: imgUrl!)
                if (imgData != nil) {
                    let image : UIImage = UIImage(data: imgData!)!
                    cell.img.image = image
                }
            }
            return cell
        case 2:
            MediaSource = "Shows"
            searchController.searchBar.placeholder = "Search \(MediaSource)"
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
            let series = (seriesFetchedResultsController?.object(at: indexPath))!
            cell.Title.text = series.title
            cell.DescOrDev.text = series.desc
            cell.Rating.text = String(format:"%.1f", series.imbdrating )
            
            cell.Title.sizeToFit()
            cell.DescOrDev.sizeToFit()
            cell.Rating.sizeToFit()
            
            //Make the image thumbnail data
            let imgUrl = URL(string: series.imgurl ?? "")
            if (imgUrl != nil) {
                let imgData = try? Data(contentsOf: imgUrl!)
                if (imgData != nil) {
                    let image : UIImage = UIImage(data: imgData!)!
                    cell.img.image = image
                    }
                }
            return cell
        case 3:
            MediaSource = "Games"
            searchController.searchBar.placeholder = "Search \(MediaSource)"
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
            let game = (gamesFetchedResultsController?.object(at: indexPath))!
            cell.Title.text = game.title
            cell.DescOrDev.text = game.developer
            cell.Rating.text = String(format:"%.1f", game.avg2weeks )
            return cell
        default:
            MediaSource = "All"
            searchController.searchBar.placeholder = "Search"
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
            cell.Title.text = testTopMedia[0]
            cell.DescOrDev.text = testTopMedia[0]
            cell.Rating.text = testTopMedia[0]
            return cell
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        switch categorySegment.selectedSegmentIndex {
        case 0:
            return 1
        case 1:
            return movieFetchedResultsController.sections!.count
        case 2:
            return seriesFetchedResultsController.sections!.count
        case 3:
            return gamesFetchedResultsController.sections!.count
        default:
            return 0
        }
    }
}
/**
    Extension for handling the burger/side menu functionality and animation
 */
extension HomeViewController : UIViewControllerTransitioningDelegate {
    /**
     Shows and dismisses the side/burger menu
     */
    @objc func menuPressed() {
        print(menuIsActive)
        if !menuIsActive {
            guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
            menuViewController.didTapMenuItem = { menuItem in
                print(menuItem)
                self.changeView(menuItem)
            }
            menuViewController.modalPresentationStyle = .overCurrentContext
            menuViewController.transitioningDelegate = self
            menuIsActive = false
            present(menuViewController, animated: true)
        } else {
            menuIsActive = true
            dismiss(animated: true, completion: {
                print("Dismissing menu")
            })
        }
    }
    func changeView(_ menuItem: menuItem)  {
        switch menuItem {
        //Broken?
        case .profile:
            print("ASD")
        //present(((storyboard?.instantiateViewController(withIdentifier: "Profile"))!), animated: true)
        case .tracker:
            print("ASD")
        //performSegue(withIdentifier: "tracker", sender: self)
        case .help:
            print("ASD")
        case .jokes:
            print("ASD")
        case .logout:
            //Logout from firebase
            do {
                try Auth.auth().signOut()
            } catch let err as NSError {
                print ("Auth: \(err)")
            }
            print("Auth: Logged out")
            performSegue(withIdentifier: "Auth", sender: self)
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
    
    func filterContentForSearchText(_ searchText: String){
        /* Alter this for actually get it work
         filteredArticles = fetchedResultsController.fetchedObjects!.filter { (news: News) -> Bool in
            return news.newsTitle!.lowercased().contains(searchText.lowercased())
        }
        newsTableView.reloadData()*/
    }
    
    //Update search results
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
        print("Search bar altered")
    }

}

