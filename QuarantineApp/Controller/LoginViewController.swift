//
//  LoginViewController.swift
//  QuarantineApp
//
//  Created by Topias Peiponen on 17.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self
    }
    
    @IBAction func toRegister(_ sender: UIButton) {
        performSegue(withIdentifier: "ToRegisterSegue", sender: self)
    }
    
    //MARK: FirebaseAuth
    func loginUser(loginEmail: String, loginPassword: String) {
        Auth.auth().signIn(withEmail: ("\(loginEmail)@quarantodo.info"), password: loginPassword) { [weak self] authResult, error in
            guard error == nil else {
                let alertController = UIAlertController(title: "Login error", message: error!.localizedDescription.replacingOccurrences(of: "email address", with: "username"), preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                self!.present(alertController, animated: true, completion: nil)
                return
            }
            self!.performSegue(withIdentifier: "loginToMain", sender: nil)
        }
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        loginUser(loginEmail: usernameField.text!, loginPassword: passwordField.text!)
    }
    
    @IBAction func guestButton(_ sender: UIButton) {
        Auth.auth().signInAnonymously() { (authResult, error) in
            guard (authResult?.user) != nil else { return }
            self.performSegue(withIdentifier: "loginToMain", sender: nil)
        }
    }
}
