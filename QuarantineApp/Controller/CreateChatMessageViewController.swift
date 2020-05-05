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
        
        let db = Firestore.firestore()
        
        //Add
        db.collection("chat").document("\(Int64(NSDate().timeIntervalSince1970 * 1000))").setData([
            "chatRoom": chatRoom,
            "chatUser": chatUser,
            "chatText": chatMessageText,
        ])
    }
    
    private func updateSaveButtonState() {
        saveButton.isEnabled = Auth.auth().currentUser!.email != nil
    }
    
}
