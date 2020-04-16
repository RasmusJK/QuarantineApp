//
//  CovidData.swift
//  QuarantineApp
//
//  Created by iosdev on 16.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import Foundation

struct CovidData: Codable {
    var cases: Int
    var deaths: Int
    var recovered: Int
}
