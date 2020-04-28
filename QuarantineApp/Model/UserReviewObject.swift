//
//  UserReviewObject.swift
//  QuarantineApp
//
//  Created by iosdev on 28.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import Foundation

struct UserReviewObject: Decodable{
    
    let id: String
    
    var reviewRating = "",
    reviewItem = "",
    reviewUser = "",
    reviewText = ""
    }
    
    /*
    var rating: String
    var reviewItem: String
    var reviewUser: String
    var reviewText: String
    
    private enum CodingKeys: String, CodingKey {
        
        case rating      = "reviewRating"
        case reviewItem    = "reviewItem"
        case reviewUser       = "reviewUser"
        case reviewText       = "reviewText"
    }
 

} */
