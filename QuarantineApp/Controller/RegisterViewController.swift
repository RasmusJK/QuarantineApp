//
//  RegisterViewController.swift
//  QuarantineApp
//
//  Created by Topias Peiponen on 17.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

//Register to firebase
class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self
        confirmField.delegate = self
    }
    
    @IBAction func toLogin(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: FirebaseAuth
    func registerUser(registerEmail: String, registerPassword: String) {
        //hardcoding email since firebase requires it
        Auth.auth().createUser(withEmail: ("\(registerEmail)@quarantodo.info"), password: registerPassword) { authResult, error in
            guard error == nil else {
                let alertController = UIAlertController(title: "Register error", message: error!.localizedDescription.replacingOccurrences(of: "email address", with: "username"), preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            self.performSegue(withIdentifier: "registerToMain", sender: nil)
        }
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        if passwordField.text == confirmField.text {
            registerUser(registerEmail: usernameField.text!, registerPassword: passwordField.text!)
        } else {
            let alertController = UIAlertController(title: "Register error", message: "Passwords did not match", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func guestButton(_ sender: UIButton) {
        //Sing anonymously to firebase
        Auth.auth().signInAnonymously() { (authResult, error) in
            guard (authResult?.user) != nil else { return }
            self.performSegue(withIdentifier: "registerToMain", sender: nil)
        }
    }
}
