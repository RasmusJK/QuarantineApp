//
//  CreateReviewViewController.swift
//  QuarantineApp
//
//  Created by iosdev on 23.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit
import os.log

class CreateReviewViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    //MARK: Properties
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var titleInputField: UITextField!
    @IBOutlet weak var reviewInputField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var review: UserReview?
    var category:String = ""
    var reviewTitle:String = ""
    var reviewText:String = ""
    
    
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
            reviewText = textField.text ?? "No review"
        }
        print("current title is: \(reviewTitle) and current review is: \(reviewText)")
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
        
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        review = UserReview(category: category, title: reviewTitle, username: "defaultuser", review: reviewText)
    }
    
}
