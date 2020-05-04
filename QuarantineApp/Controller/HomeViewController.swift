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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SteamAPIDelegate, NetflixAPIDelegate, NSFetchedResultsControllerDelegate {
    
    
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
    let steamAPI = SteamAPI()
    let netflixAPI : NetflixAPI = NetflixAPI()
    var topMedia = [TopMediaItem]()
    @IBOutlet var menuButton: UIButton!
    var movieFetchedResultsController : NSFetchedResultsController<NetflixMovie>!
    var seriesFetchedResultsController : NSFetchedResultsController<NetflixSeries>!
    var gamesFetchedResultsController : NSFetchedResultsController<Games>!
    //Firebase Auth handler
    var handle: AuthStateDidChangeListenerHandle?
    
    
    //Search bar properties and functions
    let searchBar = UISearchBar()
    @objc func handleShowSearchBar() {
        searchBar.becomeFirstResponder()
        search(shouldShow: true)
        
    }
    
    func search(shouldShow: Bool){
        showBarButtons(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar: nil
    }
    let searchController = UISearchController(searchResultsController: nil)
    var combinedMedia : [AnyObject] = []
    var filteredMedia : [AnyObject] = []
    var filteredMovies: [NetflixMovie] = []
    var filteredShows: [NetflixSeries] = []
    var filteredGames: [Games] = []
    var searchIsActive : Bool = false
    //var filteredTop: topMedia = []
    
    var isSearchBarEmpty: Bool {
        return searchBar.text?.isEmpty ?? true
    }
    var isFiltering : Bool {
        return searchIsActive && !isSearchBarEmpty
    }
    
    var MediaSource: String = "asd"
    var All = "All"
    var Movies = NSLocalizedString("Movies", comment: "")
    var Shows = NSLocalizedString("Shows", comment: "")
    var Games = NSLocalizedString("Games", comment: "")
    var Search = NSLocalizedString("Search", comment: "")
    
    func showBarButtons(shouldShow: Bool) {
        if shouldShow {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                                target: self,
                                                                action: #selector(handleShowSearchBar))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    
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
        
        topMedia = []
        itemTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        //Search bar setup
        searchBar.sizeToFit()
        searchBar.delegate = self
        showBarButtons(shouldShow: true)
        
        itemTableView.delegate = self
        itemTableView.dataSource = self
        netflixAPI.netflixAPIDelegate = self
        steamAPI.steamAPIDelegate = self
        steamAPI.url = "https://steamspy.com/api.php?request=top100in2weeks"
        
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global(qos: .userInitiated).sync {
            self.fetchResultsToController(entity: "NetflixMovie")
            self.fetchResultsToController(entity: "NetflixSeries")
            self.fetchResultsToController(entity: "Games")
            print("Current thread in home is: \(Thread.current)")
            
            var categorySwitch : String
            if (self.movieFetchedResultsController.fetchedObjects!.count == 0) {
                categorySwitch = "NetflixMovie"
                //MARK: UNCOMMENT THIS ONLY WHEN NEEDED OTHERWISE TOPI GETS CHARGED >:D
                self.netflixAPI.getData(categorySwitch: categorySwitch)
            }
            if (self.seriesFetchedResultsController.fetchedObjects!.count == 0) {
                categorySwitch = "NetflixSeries"
                //MARK: UNCOMMENT THIS ONLY WHEN NEEDED OTHERWISE TOPI GETS CHARGED >:D
                self.netflixAPI.getData(categorySwitch: categorySwitch)
            }
            if (self.gamesFetchedResultsController.fetchedObjects!.count == 0) {
                self.steamAPI.getData()
            }
            self.getTopMedia()
        }
        
        // Setting an event for segment changing
        categorySegment.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        
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
            //performSegue(withIdentifier: "Auth", sender: self)
        }
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToSingle") {
            guard let singleVC = segue.destination as? SingleViewController else { return }
            let indexPath = itemTableView.indexPathForSelectedRow
            let index = indexPath?.section
            switch categorySegment.selectedSegmentIndex {
                case 0:
                    if (isFiltering) {
                        // First check if object is game
                        if let object = filteredMedia[index!] as? Games {
                            singleVC.singleTitleText = object.title ?? ""
                            singleVC.descOrDevText = object.developer ?? ""
                            singleVC.ratingText = "Average play time in two weeks: \(String(object.avg2weeks))"
                        } else {
                            // Else assume it is movie or series
                            let object = filteredMedia[index!]
                            singleVC.singleTitleText = object.title ?? ""
                            singleVC.descOrDevText = object.desc ?? ""
                            singleVC.ratingText = "IMBD: \(String(object.imbdrating))"
                            if (object.imgurl != "" && object.imgurl != nil) {
                                let image = CustomImageView()
                                image.loadImageWithURLString(urlString: object.imgurl!)
                                singleVC.imgurl = image.image!
                            }
                        }
                        
                    } else {
                        let object = topMedia[index!]
                        singleVC.singleTitleText = object.title
                        singleVC.descOrDevText = object.descOrDev
                        if object.type == "game" {
                            singleVC.ratingText = "Average play time in two weeks: \(object.avgOrRating)"
                        } else {
                            singleVC.ratingText = "IMBD: \(object.avgOrRating)"
                        }
                        if (object.imgurl != "") {
                            let image = CustomImageView()
                            image.loadImageWithURLString(urlString: object.imgurl)
                            singleVC.imgurl = image.image!
                        }
                    }
                case 1:
                    if (isFiltering) {
                        let object = filteredMovies[index!]
                        singleVC.singleTitleText = object.title ?? ""
                        singleVC.descOrDevText = object.desc ?? ""
                        singleVC.ratingText = "IMBD: \(String(object.imbdrating))"
                        if (object.imgurl != "" && object.imgurl != nil) {
                            let image = CustomImageView()
                            image.loadImageWithURLString(urlString: object.imgurl!)
                            singleVC.imgurl = image.image!
                        }
                    } else {
                        let object = movieFetchedResultsController.object(at: indexPath!)
                        singleVC.singleTitleText = object.title ?? ""
                        singleVC.descOrDevText = object.desc ?? ""
                        singleVC.ratingText = "IMBD: \(String(object.imbdrating))"
                        if (object.imgurl != "" && object.imgurl != nil) {
                            let image = CustomImageView()
                            image.loadImageWithURLString(urlString: object.imgurl!)
                            singleVC.imgurl = image.image!
                        }
                    }
                case 2:
                    if (isFiltering) {
                        let object = filteredShows[index!]
                        singleVC.singleTitleText = object.title ?? ""
                        singleVC.descOrDevText = object.desc ?? ""
                        singleVC.ratingText = "IMBD: \(String(object.imbdrating))"
                        if (object.imgurl != "" && object.imgurl != nil) {
                            let image = CustomImageView()
                            image.loadImageWithURLString(urlString: object.imgurl!)
                            singleVC.imgurl = image.image!
                        }
                    } else {
                        let object = seriesFetchedResultsController.object(at: indexPath!)
                        singleVC.singleTitleText = object.title ?? ""
                        singleVC.descOrDevText = object.desc ?? ""
                        singleVC.ratingText = "IMBD: \(String(object.imbdrating))"
                        if (object.imgurl != "" && object.imgurl != nil) {
                            let image = CustomImageView()
                            image.loadImageWithURLString(urlString: object.imgurl!)
                            singleVC.imgurl = image.image!
                        }
                    }
                case 3:
                    if (isFiltering) {
                        let object = filteredGames[index!]
                        singleVC.singleTitleText = object.title ?? ""
                        singleVC.descOrDevText = object.developer ?? ""
                        singleVC.ratingText = "Average play time in two weeks: \(String(object.avg2weeks))"
                    } else {
                        let object = gamesFetchedResultsController.object(at: indexPath!)
                        singleVC.singleTitleText = object.title ?? ""
                        singleVC.descOrDevText = object.developer ?? ""
                        singleVC.ratingText = "Average play time in two weeks: \(String(object.avg2weeks))"
                    }
                default:
                    print("ASD")
                }
            
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
    
    func getTopMedia() {
        let topMovieFRC = movieFetchedResultsController.fetchedObjects?.first
        let topSeriesFRC = seriesFetchedResultsController.fetchedObjects?.first
        let topGameFRC = gamesFetchedResultsController.fetchedObjects?.first
        print("Top movie FRC: \(movieFetchedResultsController.fetchedObjects!.count)")
        print("Top series FRC: \(topSeriesFRC)")
        print("Top game FRC: \(topGameFRC)")
        
        if (topMovieFRC != nil) {
            let topMovieClass = TopMediaItem(title: topMovieFRC?.title ?? "", descOrDev: topMovieFRC?.desc ?? "", avgOrRating: String(format:"%.1f", topMovieFRC?.imbdrating ?? ""), imgurl: topMovieFRC?.imgurl ?? "", type: "movie")
            topMedia.append(topMovieClass)
        }
        if (topSeriesFRC != nil) {
            let topSeriesClass = TopMediaItem(title: topSeriesFRC?.title ?? "", descOrDev: topSeriesFRC?.desc ?? "", avgOrRating: String(format:"%.1f", topSeriesFRC?.imbdrating ?? ""), imgurl: topSeriesFRC?.imgurl ?? "", type: "series")
            topMedia.append(topSeriesClass)
        }
        if (topGameFRC != nil) {
            let topGameClass = TopMediaItem(title: topGameFRC?.title ?? "", descOrDev: topGameFRC?.developer ?? "", avgOrRating: topGameFRC?.avg2weeks.description ?? "", imgurl: "", type: "game")
            topMedia.append(topGameClass)
        }
        DispatchQueue.main.async{
            self.itemTableView.reloadData()
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
    func combineFetchedResults() {
        print("Combining fetch results")
        for item in movieFetchedResultsController.fetchedObjects! {
            combinedMedia.append(item)
        }
        for item in seriesFetchedResultsController.fetchedObjects! {
            combinedMedia.append(item)
        }
        for item in gamesFetchedResultsController.fetchedObjects! {
            combinedMedia.append(item)
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
        if (isFiltering) {
            switch (MediaSource) {
            case "All":
                return 1
            case "Movies":
                return 1
            case "Shows":
                return 1
            case "Games":
                return 1
            default:
                return 0
            }
        } else {
            switch categorySegment.selectedSegmentIndex {
            case 0:
                if (!topMedia.isEmpty) {
                    return 1
                } else {
                    return 0
                }
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
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (isFiltering) {
            switch (MediaSource) {
            case "All":
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
                let media = filteredMedia[indexPath.section]
                cell.Title.text = media.title
                if let movie = media as? NetflixMovie {
                    cell.DescOrDev.text = movie.desc
                    cell.Rating.text = "IMBD: \(String(format:"%.1f", movie.imbdrating ))"
                    if (movie.imgurl != "" && movie.imgurl != nil) {
                        let image = CustomImageView()
                        image.loadImageWithURLString(urlString: movie.imgurl!)
                        cell.img.image = image.image
                    }
                }
                if let series = media as? NetflixSeries {
                    cell.DescOrDev.text = series.desc
                    cell.Rating.text = "IMBD: \(String(format:"%.1f", series.imbdrating ))"
                    if (series.imgurl != "" && series.imgurl != nil) {
                        let image = CustomImageView()
                        image.loadImageWithURLString(urlString: series.imgurl!)
                        cell.img.image = image.image
                    }
                }
                if let game = media as? Games {
                    cell.DescOrDev.text = game.developer
                    cell.Rating.text = "Avg time played: \(game.avg2weeks) minutes"
                    //Make the image thumbnail data
                    let image : UIImage = UIImage(named: "Profile") ?? UIImage()
                    cell.img.image = image
                }
                
                cell.Title.sizeToFit()
                cell.DescOrDev.sizeToFit()
                cell.Rating.sizeToFit()
                
                return cell
            case "Movies":
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
                let media = filteredMovies[indexPath.section]
                cell.Title.text = media.title
                cell.DescOrDev.text = media.desc
                cell.Rating.text = "IMBD: \(String(format:"%.1f", media.imbdrating ))"
                
                cell.Title.sizeToFit()
                cell.DescOrDev.sizeToFit()
                cell.Rating.sizeToFit()
                
                if (media.imgurl != "" && media.imgurl != nil) {
                    let image = CustomImageView()
                    image.loadImageWithURLString(urlString: media.imgurl!)
                    cell.img.image = image.image
                }
                return cell
            case "Shows":
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
                let media = filteredShows[indexPath.section]
                cell.Title.text = media.title
                cell.DescOrDev.text = media.desc
                cell.Rating.text = "IMBD: \(String(format:"%.1f", media.imbdrating ))"
                
                cell.Title.sizeToFit()
                cell.DescOrDev.sizeToFit()
                cell.Rating.sizeToFit()
                
                if (media.imgurl != "" && media.imgurl != nil) {
                    let image = CustomImageView()
                    image.loadImageWithURLString(urlString: media.imgurl!)
                    cell.img.image = image.image
                }
                return cell
            case "Games":
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
                let media = filteredGames[indexPath.section]
                cell.Title.text = media.title
                cell.DescOrDev.text = media.developer
                cell.Rating.text = "Avg time played: \(media.avg2weeks) minutes"
                
                cell.Title.sizeToFit()
                cell.DescOrDev.sizeToFit()
                cell.Rating.sizeToFit()
                
                //Make the image thumbnail data
                let image : UIImage = UIImage(named: "Profile") ?? UIImage()
                cell.img.image = image
                
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
                cell.Title.text = ""
                cell.DescOrDev.text = ""
                cell.Rating.text = ""
                return cell
            }
        } else {
            switch categorySegment.selectedSegmentIndex {
            case 0:
                MediaSource = All
                searchBar.placeholder = "\(Search)"
                let cell = tableView.dequeueReusableCell(withIdentifier: "TopItemCell", for: indexPath) as! TopItemTableViewCell
                cell.Title.text = topMedia[indexPath.section].title
                cell.DescOrDev.text = topMedia[indexPath.section].descOrDev
                if topMedia[indexPath.section].type == "game" {
                    cell.Rating.text = "Avg time played: \(topMedia[indexPath.section].avgOrRating) minutes"
                } else {
                    cell.Rating.text = "IMBD: \(topMedia[indexPath.section].avgOrRating)"
                }
                
                cell.Title.sizeToFit()
                cell.DescOrDev.sizeToFit()
                cell.Rating.sizeToFit()
                
                //Make the image thumbnail data
                if (topMedia[indexPath.section].type == "game") {
                    let image : UIImage = UIImage()
                    cell.Thumbnail.image = image
                } else {
                    if (topMedia[indexPath.section].imgurl != "" && topMedia[indexPath.section].imgurl != nil) {
                        let image = CustomImageView()
                        image.loadImageWithURLString(urlString: topMedia[indexPath.section].imgurl)
                        cell.Thumbnail.image = image.image
                    }
                }
                
                return cell
            case 1:
                MediaSource = Movies
                searchBar.placeholder = "\(Search) \(MediaSource)"
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
                let movie = (movieFetchedResultsController?.object(at: indexPath))!
                cell.Title.text = movie.title
                cell.DescOrDev.text = movie.desc
                cell.Rating.text = "IMBD: \(String(format:"%.1f", movie.imbdrating ))"
                
                cell.Title.sizeToFit()
                cell.DescOrDev.sizeToFit()
                cell.Rating.sizeToFit()
                
                if (movie.imgurl != "" && movie.imgurl != nil) {
                    let image = CustomImageView()
                    image.loadImageWithURLString(urlString: movie.imgurl!)
                    cell.img.image = image.image
                }
                
                return cell
            case 2:
                MediaSource = Shows
                searchBar.placeholder = "\(Search) \(MediaSource)"
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
                let series = (seriesFetchedResultsController?.object(at: indexPath))!
                cell.Title.text = series.title
                cell.DescOrDev.text = series.desc
                cell.Rating.text = "IMBD: \(String(format:"%.1f", series.imbdrating ))"
                
                cell.Title.sizeToFit()
                cell.DescOrDev.sizeToFit()
                cell.Rating.sizeToFit()
                
                if (series.imgurl != "" && series.imgurl != nil) {
                    let image = CustomImageView()
                    image.loadImageWithURLString(urlString: series.imgurl!)
                    cell.img.image = image.image
                }
                return cell
            case 3:
                MediaSource = Games
                searchBar.placeholder = "\(Search) \(MediaSource)"
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
                let game = (gamesFetchedResultsController?.object(at: indexPath))!
                cell.Title.text = game.title
                cell.DescOrDev.text = game.developer
                cell.Rating.text = "Avg time played: \(String(format:"%.1f", game.avg2weeks )) minutes."
                
                cell.Title.sizeToFit()
                cell.DescOrDev.sizeToFit()
                cell.Rating.sizeToFit()
                
                //Make the image thumbnail data
                let image : UIImage = UIImage(named: "Profile") ?? UIImage()
                cell.img.image = image
                return cell
            default:
                MediaSource = All
                searchBar.placeholder = "\(Search)"
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
                cell.Title.text = ""
                cell.DescOrDev.text = ""
                cell.Rating.text = ""
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToSingle", sender: self)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if (isFiltering) {
            switch (MediaSource) {
            case "All":
                return filteredMedia.count
            case "Movies":
                return filteredMovies.count
            case "Shows":
                return filteredShows.count
            case "Games":
                return filteredGames.count
            default:
                return 0
            }
        } else {
            switch categorySegment.selectedSegmentIndex {
            case 0:
                return topMedia.count
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
}


extension HomeViewController: UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchIsActive = true
        combineFetchedResults()
        print("Search bar editing did begin..")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchIsActive = false
        print("Search bar editing did end..")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search text is \(searchText) and filtering for \(MediaSource)")
        filterContentForSearch(searchText)
    }
    
    func filterContentForSearch(_ searchText: String) {
        if(MediaSource == All){
            filteredMedia = combinedMedia.filter{(object : AnyObject) -> Bool in
                return object.title!.lowercased().contains(searchText.lowercased())
            }
        } else if(MediaSource == Movies) {
            filteredMovies = movieFetchedResultsController.fetchedObjects!.filter {(movies: NetflixMovie) -> Bool in
                return movies.title!.lowercased().contains(searchText.lowercased())
            }
        } else if(MediaSource == Shows) {
            filteredShows = seriesFetchedResultsController.fetchedObjects!.filter {(series: NetflixSeries) -> Bool in
                return series.title!.lowercased().contains(searchText.lowercased())
            }
        } else if(MediaSource == Games) {
            filteredGames = gamesFetchedResultsController.fetchedObjects!.filter {(games: Games) -> Bool in
                return games.title!.lowercased().contains(searchText.lowercased())
            }
        }
        itemTableView.reloadData()
    }
}
