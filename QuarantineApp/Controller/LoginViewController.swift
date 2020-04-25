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

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self
        //Updates auth changes
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("Auth uid: \(auth.currentUser?.uid ?? "no uid"), username: \(auth.currentUser?.email?.replacingOccurrences(of: "@quarantodo.info", with: "") ?? "no name")")
        }
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
            //Remove auth handler
            Auth.auth().removeStateDidChangeListener(self!.handle!)
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        loginUser(loginEmail: usernameField.text!, loginPassword: passwordField.text!)
    }
    
    @IBAction func guestButton(_ sender: UIButton) {
        Auth.auth().signInAnonymously() { (authResult, error) in
            guard (authResult?.user) != nil else { return }
            Auth.auth().removeStateDidChangeListener(self.handle!)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
