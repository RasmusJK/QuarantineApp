//
//  UserReview.swift
//  QuarantineApp
//
//  Created by iosdev on 22.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit

class UserReview {
    
//MARK: Properties

    var title: String
    var rating: String
    var username: String
    var review: String

//MARK: Initialization
    init?(title: String, rating: String, username: String, review: String) {
   
    guard !title.isEmpty else {
    return nil
    }
        
    guard !rating.isEmpty else {
    return nil
    }
        
    guard !username.isEmpty else {
    return nil
    }
        
    guard !review.isEmpty else {
    return nil
    }
    
    self.title = title
    self.rating = rating
    self.username = username
    self.review = review
        
    }
}
