//
//  ChatMessage.swift
//  QuarantineApp
//
//  Created by iosdev on 4.5.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit

class ChatMessage: Codable {
    
    //MARK: Properties
    
    var chatRoom: String
    var chatUsername: String
    var chatMessage: String
    
    //MARK: Initialization
    init?(chatRoom: String, chatUsername: String, chatMessage: String) {
        
        guard !chatRoom.isEmpty else {
            return nil
        }
        
        guard !chatUsername.isEmpty else {
            return nil
        }
        
        guard !chatMessage.isEmpty else {
            return nil
        }
        
        self.chatRoom = chatRoom
        self.chatUsername = chatUsername
        self.chatMessage = chatMessage
    }
}
