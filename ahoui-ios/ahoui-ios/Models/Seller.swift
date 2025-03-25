import Foundation

/// Represents a seller in the system
struct Seller: Identifiable, Codable {
    let id: String
    var name: String
    var email: String
    var phone: String
    var amountOwed: Double

    enum CodingKeys: String, CodingKey {
        case id = "_id"  // Map "_id" from JSON to "id" in Swift
        case name
        case email
        case phone
        case amountOwed
    }
}

/// Represents a deposited game belonging to a seller (used when viewing a seller’s deposited games)
struct SellerDepositedGameSeller: Identifiable, Codable {
    let id: String
    let seller: SellerDepositedGameSellerInfo
    let session: SellerDepositedGameSessionInfo
    let gameDescription: SellerDepositedGameGameDescriptionInfo
    let salePrice: Double
    let forSale: Bool
    let pickedUp: Bool
    let sold: Bool

    // ✅ Map `_id` from MongoDB to `id`
    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case seller = "sellerId" // Reference to seller object
        case session = "sessionId" // Reference to session object
        case gameDescription = "gameDescriptionId" // Reference to game description object
        case salePrice
        case forSale
        case pickedUp
        case sold
    }
}

// MARK: - Nested Info Models

/// Basic seller info used in a deposited game object
struct SellerDepositedGameSellerInfo: Codable {
    let id: String
    let name: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case name
        case email
    }
}

/// Session info used in a deposited game object
struct SellerDepositedGameSessionInfo: Codable {
    let id: String
    let name: String
    let startDate: String
    let endDate: String

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case name
        case startDate
        case endDate
    }
}

/// Game description info used in a deposited game object
struct SellerDepositedGameGameDescriptionInfo: Codable {
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
