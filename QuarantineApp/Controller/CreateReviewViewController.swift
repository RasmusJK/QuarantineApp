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
    
    var review: UserReview?
    var category:String = ""
    var rating: String = ""
    var reviewTitle:String = ""
    var reviewText2:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleInputField.delegate = self
        reviewInputField.delegate = self
        categoryPicker.delegate = self
        
    }
    
    var categoriesForPicker = ["Books", "Games", "Movies"]
    
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
        else {
            reviewText2 = textField.text ?? "No review"
        }
        print("current title is: \(reviewTitle) and current review is: \(reviewText2)")
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
        let reviewItem = reviewTitle
        let reviewRating = "5"
        let reviewText = reviewText2
        let reviewUser = "testuser"
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
    
}
