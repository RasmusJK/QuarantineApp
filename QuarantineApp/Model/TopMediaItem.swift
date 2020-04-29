//
//  TopMediaItem.swift
//  QuarantineApp
//
//  Created by iosdev on 28.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import Foundation

class TopMediaItem {
    let title : String
    let descOrDev : String
    let avgOrRating : String
    let imgurl : String
    let type : String
    
    init(title: String, descOrDev : String, avgOrRating : String, imgurl : String, type : String) {
        self.title = title
        self.descOrDev = descOrDev
        self.avgOrRating = avgOrRating
        self.imgurl = imgurl
        self.type = type
    }
}
