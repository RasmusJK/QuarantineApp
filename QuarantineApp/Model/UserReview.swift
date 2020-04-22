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

    var category: String
    var title: String
    var username: String
    var review: String

//MARK: Initialization
    init?(category: String, title: String, username: String, review: String) {
    
    guard !category.isEmpty else {
        return nil
    }
        
    guard !title.isEmpty else {
    return nil
    }
        
    guard !username.isEmpty else {
    return nil
    }
        
    guard !review.isEmpty else {
    return nil
    }
    
    self.category = category
    self.title = title
    self.username = username
    self.review = review
        
    }
}
