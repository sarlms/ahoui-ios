//
//  GameDescription.swift
//  ahoui-ios
//
//  Created by etud on 20/03/2025.
//

import Foundation

struct GameDescription: Identifiable, Codable {
    let id: String
    let name: String
    let publisher: String
    let description: String
    let photoURL: String
    let minPlayers: Int
    let maxPlayers: Int
    let ageRange: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"  // ✅ Vérifie que l'API envoie bien "_id" et non "id"
        case name
        case publisher
        case description
        case photoURL
        case minPlayers
        case maxPlayers
        case ageRange
    }
}

struct GameDescriptionCreation: Codable {
    let name: String
    let publisher: String
    let description: String
    let photoURL: String
    let minPlayers: Int
    let maxPlayers: Int
    let ageRange: String
}
