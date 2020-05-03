//
//  ProfileViewController.swift
//  QuarantineApp
//
//  Created by iosdev on 14.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser?.email != nil {
            usernameLabel.text = Auth.auth().currentUser?.email?.replacingOccurrences(of: "@quarantodo.info", with: "") ?? "Anonymous"
        } else {
            performSegue(withIdentifier: "toAuth", sender: nil)
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func logoutButton(_ sender: UIButton) {
        //Logout from firebase
        do {
            try Auth.auth().signOut()
        } catch let err as NSError {
            print ("Auth: \(err)")
        }
        print("Auth: Logged out")
        performSegue(withIdentifier: "toAuth", sender: nil)
    }
    
}
