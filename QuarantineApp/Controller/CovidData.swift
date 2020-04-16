//
//  CovidData.swift
//  QuarantineApp
//
//  Created by iosdev on 16.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import Foundation

struct CovidData: Codable {
    let country: String
    let cases, todayCases, deaths, todayDeaths: Int
    let recovered: Int?
    let active, critical, casesPerOneMillion, deathsPerOneMillion: Int
    let totalTests, testsPerOneMillion: Int
}
