import Foundation

/// Represents a game description in the database
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
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case name
        case publisher
        case description
        case photoURL
        case minPlayers
        case maxPlayers
        case ageRange
    }
}

/// Represents the creation of a game description
struct GameDescriptionCreation: Codable {
    let name: String
    let publisher: String
    let description: String
    let photoURL: String
    let minPlayers: Int
    let maxPlayers: Int
    let ageRange: String
}
