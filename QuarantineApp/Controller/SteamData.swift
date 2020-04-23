// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let steamData = try? newJSONDecoder().decode(SteamData.self, from: jsonData)

import Foundation

// MARK: - SteamDataValue
struct SteamDataValue: Codable {
    let appid: Int
    let name, developer, publisher, scoreRank: String
    let positive, negative, userscore: Int
    let owners: Owners
    let averageForever, average2Weeks, medianForever, median2Weeks: Int
    let price, initialprice, discount: String

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

enum Owners: String, Codable {
    case the100000000200000000 = "100,000,000 .. 200,000,000"
    case the1000000020000000 = "10,000,000 .. 20,000,000"
    case the2000000050000000 = "20,000,000 .. 50,000,000"
    case the20000005000000 = "2,000,000 .. 5,000,000"
    case the500000010000000 = "5,000,000 .. 10,000,000"
}

typealias SteamData = [String: SteamDataValue]

