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
import CoreData


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SteamAPIDelegate, NetflixAPIDelegate {
    func newData(_ steamData: SteamData?) {
        DispatchQueue.main.async {
            for item in steamData! {
                print("newData steamData: \(item)")
                self.testTopGames.append(item.value)
                //  self.saveToCoreData(gameTitle: item.value.name)
            }
        }
    }
    func newData(_ netflixInfo: NetflixInfo?) {
        DispatchQueue.main.async {
            for info in (netflixInfo?.results)! {
                print("newData netflixInfo: \(info.title ?? "no title")")
                self.testTopMovies.append(info)
            }
        }
    }
    
    //MARK: Properties
    @IBOutlet var itemTableView: UITableView!
    @IBOutlet var categorySegment: LocalizedUISegmentedControl!
    let transition = SlideInTransition()
    var menuIsActive = false
    let netflixAPI : NetflixAPI = NetflixAPI()
    let testTopMedia = ["Movie", "Show", "Game", "Stream"]
    var testTopMovies = [Result]()
    let testTopShows = ["Show1", "Show2", "Show3", "Show4", "Show5"]
    var testTopGames = [SteamDataValue]()
    let testTopStreams = ["Stream1", "Stream2", "Stream3", "Stream4", "Stream5"]
    lazy var mediaToDisplay = testTopMedia
    @IBOutlet var menuButton: UIButton!
    
    //Firebase Auth handler
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTableView.delegate = self
        itemTableView.dataSource = self
        netflixAPI.netflixAPIDelegate = self
        
        //MARK: UNCOMMENT THIS ONLY WHEN NEEDED OTHERWISE TOPI GETS CHARGED >:D
        //netflixAPI.getData()
        
        // Steam API
        let steamAPI = SteamAPI()
        steamAPI.url = "https://steamspy.com/api.php?request=top100in2weeks"
        steamAPI.steamAPIDelegate = self
        steamAPI.getData()
        
        // Setting an event for segment changing
        categorySegment.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        
        // Set action for menu button
        menuButton.addTarget(self, action: #selector(menuPressed), for: .touchUpInside)
        /*
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
         */
        
        //Firebase Auth handler
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("Auth: \(auth.currentUser?.uid ?? "no uid"), username: \(auth.currentUser?.email?.replacingOccurrences(of: "@quarantodo.info", with: "") ?? "anonymous")")
        }
        
        //Check auth at start
        if Auth.auth().currentUser?.email == nil {
            print("Auth: No user logged in, going to auth =>")
            performSegue(withIdentifier: "Auth", sender: self)
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
    
    @IBAction func GOTOAUTH(_ sender: UIButton) {
        performSegue(withIdentifier: "Auth", sender: self)
    }
    
    
    //MARK: Private methods
    @objc fileprivate func handleSegmentChange(){
        itemTableView.reloadData()
    }
}

extension HomeViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch categorySegment.selectedSegmentIndex {
        case 0:
            return testTopMedia.count
        case 1:
            return testTopMovies.count
        case 2:
            return testTopShows.count
        case 3:
            return testTopGames.count
        case 4:
            return testTopStreams.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch categorySegment.selectedSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopItemCell", for: indexPath) as! TopItemTableViewCell
            cell.Title.text = "Top \(testTopMedia[0])"
            cell.Users.text = "Top \(testTopMedia[0])"
            cell.Available.text = "Top \(testTopMedia[0])"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
            cell.Title.text = testTopMovies[indexPath.row].title
            cell.Users.text = testTopMovies[indexPath.row].title
            cell.Available.text = testTopMovies[indexPath.row].title
            
            //Make the image thumbnail data
            let imgUrl = URL(string: testTopMovies[indexPath.row].img!)
            if (imgUrl != nil) {
                let imgData = try? Data(contentsOf: imgUrl!)
                if (imgData != nil) {
                    let image : UIImage = UIImage(data: imgData!)!
                    cell.img.image = image
                }
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
            cell.Title.text = testTopMedia[0]
            cell.Users.text = testTopMedia[0]
            cell.Available.text = testTopMedia[0]
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
            cell.Title.text = testTopGames[indexPath.row].name
            cell.Users.text = testTopGames[indexPath.row].owners
            cell.Available.text = testTopGames[indexPath.row].developer
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
            cell.Title.text = testTopMedia[0]
            cell.Users.text = testTopMedia[0]
            cell.Available.text = testTopMedia[0]
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
            cell.Title.text = testTopMedia[0]
            cell.Users.text = testTopMedia[0]
            cell.Available.text = testTopMedia[0]
            return cell
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
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
}

