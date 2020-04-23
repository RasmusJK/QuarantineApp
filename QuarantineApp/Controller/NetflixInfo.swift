//
//  NetflixInfo.swift
//  QuarantineApp
//
//  Created by Topias Peiponen on 22.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import Foundation

/**
    Struct for storing all data gathered from the Netflix API
 */
// MARK: - Netflix
struct NetflixInfo: Codable {
    let elapse: Double?
    let results: [Result]?
}

// MARK: - Result
struct Result: Codable {
    let vtype: String?
    let img: String?
    let nfid: Int?
    let imdbid: String?
    let title : String?
    let clist : String?
    let poster: String?
    let imdbrating: Double?
    let top250Tv: Int?
    let synopsis: String?
    let titledate : String?
    let avgrating: Double?
    let year : Int?
    let runtime : Int?
    let top250 : Int?
    let id : Int?
    

    enum CodingKeys: String, CodingKey {
        case vtype, img, nfid, imdbid, title, clist, poster, imdbrating
        case top250Tv = "top250tv"
        case synopsis, titledate, avgrating, year, runtime, top250, id
    }
}
