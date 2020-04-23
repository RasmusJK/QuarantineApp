// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let steamData = try? newJSONDecoder().decode(SteamData.self, from: jsonData)

import Foundation

// MARK: - SteamDataValue
struct SteamDataValue: Codable {
    let appid: Int?
    let name, developer, publisher, scoreRank: String?
    let positive, negative, userscore: Int?
    let owners: String?
    let averageForever, average2Weeks, medianForever, median2Weeks: Int?
    let price, initialprice, discount: String?

    enum CodingKeys: String, CodingKey {
        case appid, name, developer, publisher
        case scoreRank = "score_rank"
        case positive, negative, userscore, owners
        case averageForever = "average_forever"
        case average2Weeks = "average_2weeks"
        case medianForever = "median_forever"
        case median2Weeks = "median_2weeks"
        case price, initialprice, discount
    }
}

typealias SteamData = [String: SteamDataValue]

