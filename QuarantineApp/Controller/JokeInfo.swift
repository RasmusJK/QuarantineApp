//
//  JokeInfo.swift
//  QuarantineApp
//
//  Created by Roope Vaarama on 21.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import Foundation
// MARK: - Jokes
struct JokeInfo: Codable {
    let category: String
    let type: String
    let joke: String?
    let setup: String?
    let delivery: String?
    let flags: Flags
    let id: Int
    let error: Bool

    enum CodingKeys: String, CodingKey {
        case category = "category"
        case type = "type"
        case joke = "joke"
        case setup = "setup"
        case delivery = "delivery"
        case flags = "flags"
        case id = "id"
        case error = "error"
    }
}
// MARK: - Flags
struct Flags: Codable {
    let nsfw: Bool
    let religious: Bool
    let political: Bool
    let racist: Bool
    let sexist: Bool
    
    enum CodingKeys: String, CodingKey {
        case nsfw = "nsfw"
        case religious = "religious"
        case political = "political"
        case racist = "racist"
        case sexist = "sexist"
    }
}
