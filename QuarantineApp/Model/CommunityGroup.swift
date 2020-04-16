//
//  CommunityGroup.swift
//  QuarantineApp
//
//  Created by iosdev on 16.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit

class CommunityGroup {
    
//MARK: Properties

var title: String
var image: UIImage?

//MARK: Initialization
init?(title: String, image: UIImage?) {
    
    guard !title.isEmpty else {
    return nil
    }
    
    self.title = title
    self.image = image
    }
}

