//
//  CreateChatMessageViewController.swift
//  QuarantineApp
//
//  Created by iosdev on 4.5.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit
import os.log
import Firebase
import FirebaseFirestore
import FirebaseAuth

class CreateChatMessageViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var chatMessageInputField: UITextField!
    @IBOutlet weak var chatRoomPicker: UIPickerView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var userLabel: UILabel!
    
    var message: ChatMessage?
    var chatRoom:String = "Helsinki"
    var chatUser: String = "no user"
    var chatMessageText:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        chatRoomPicker.delegate = self
        chatMessageInputField.delegate = self
        
        chatMessageInputField.becomeFirstResponder()
        
        // create the alert
        
        if Auth.auth().currentUser!.email != nil {
            chatUser = (Auth.auth().currentUser?.email?.replacingOccurrences(of: "@quarantodo.info", with: ""))!
            userLabel.text = chatUser
        } else {
            
            performSegue(withIdentifier: "toAuth", sender: nil)
            
        }
        
        updateSaveButtonState()
        print("\(Auth.auth().currentUser!.email ?? "Anonymous")")
        
    }
    
    var categoriesForPicker = ["Helsinki", "Vantaa", "Espoo", "Tampere"]
    
    //MARK: UITextField Delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        chatMessageText = textField.text ?? "No title"
        
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
        chatRoom = categoriesForPicker[row]
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //MARK: Firebase User review testing
        let db = Firestore.firestore()
        let chatRoom2 = chatRoom
        let chatText = chatMessageInputField.text ?? "No message"
        
        //Add
        db.collection("chat").document("\(Int64(NSDate().timeIntervalSince1970 * 1000))").setData([
            "chatRoom": chatRoom2,
            "chatUser": chatUser,
            "chatText": chatText,
        ])
        
        //Get
        db.collection("chat").whereField("chatText", isEqualTo: chatText).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting Firestore data: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    print("id: \(doc.documentID), data: \(doc.data())")
                }
            }
        }
        
        //   review = UserReview(title: reviewTitle, rating: "5", username: "defaultuser", review: reviewText2)
    }
    
    private func updateSaveButtonState() {
        saveButton.isEnabled = Auth.auth().currentUser!.email != nil
    }
    
}
