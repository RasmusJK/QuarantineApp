//
//  CreateReviewViewController.swift
//  QuarantineApp
//
//  Created by iosdev on 23.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit
import os.log
import Firebase
import FirebaseFirestore
import FirebaseAuth

class CreateReviewViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    //MARK: Properties
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var titleInputField: UITextField!
    @IBOutlet weak var reviewInputField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var ratingInputField: UITextField!
    
    
    var review: UserReview?
    var category:String = "Books"
    var rating: String = ""
    var reviewTitle:String = ""
    var reviewText2:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleInputField.delegate = self
        reviewInputField.delegate = self
        categoryPicker.delegate = self
        ratingInputField.delegate = self
        
        titleInputField.becomeFirstResponder()
        reviewInputField.becomeFirstResponder()
        ratingInputField.becomeFirstResponder()
        
        // create the alert
        
        if Auth.auth().currentUser!.email != nil {
                      let alert = UIAlertController(title: "Welcome logged in user!", message: "User reviews are now behind a login functionality.", preferredStyle: UIAlertController.Style.alert)

                      // add an action (button)
                      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                      // show the alert
                      self.present(alert, animated: true, completion: nil)
        } else {
            
            performSegue(withIdentifier: "toAuth", sender: nil)
            
        }
        
        updateSaveButtonState()
        print("\(Auth.auth().currentUser!.email)")
        
    }
    
    var categoriesForPicker = ["Books", "Games", "Movies", "TV Series"]
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: UITextField Delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.restorationIdentifier == "titleInput" {
            reviewTitle = textField.text ?? "No title"
        }
        else if textField.restorationIdentifier == "reviewInput" {
            reviewText2 = textField.text ?? "No review"
        }
        else if textField.restorationIdentifier == "ratingInput"{
            rating = textField.text ?? "-"
        }
        print("current title is: \(reviewTitle) and current review is: \(reviewText2) and current rating is: \(rating)")
    }
    
    
    //MARK: Picker view methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesForPicker.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return "\(categoriesForPicker[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let pickedCategory = categoriesForPicker[row] as String
            print("currently picked category for review: \(pickedCategory)")
            category = categoriesForPicker[row]
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //MARK: Firebase User review testing
        let db = Firestore.firestore()
        let reviewItem = titleInputField.text ?? "No title"
        let reviewRating = ratingInputField.text ?? "-"
        let reviewText = reviewInputField.text ?? "No review"
        let reviewUser = Auth.auth().currentUser!.email!.replacingOccurrences(of: "@quarantodo.info", with: "")
        let reviewCategory = category
        
        //Add
        db.collection("reviews").addDocument(data: [
            "reviewItem": reviewItem,
            "reviewRating": reviewRating,
            "reviewText": reviewText,
            "reviewUser": reviewUser,
            "reviewCategory": reviewCategory
        ])
        
        //Get
        db.collection("reviews").whereField("reviewItem", isEqualTo: reviewItem).getDocuments() { (querySnapshot, err) in
        if let err = err {
        print("Error getting Firestore data: \(err)")
        } else {
        for doc in querySnapshot!.documents {
        print("id: \(doc.documentID), data: \(doc.data())")
        }
        }
        }
        
       /* super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        */
        
     //   review = UserReview(title: reviewTitle, rating: "5", username: "defaultuser", review: reviewText2)
    }
    
    private func updateSaveButtonState() {
        saveButton.isEnabled = Auth.auth().currentUser!.email != nil
    }
    
}
