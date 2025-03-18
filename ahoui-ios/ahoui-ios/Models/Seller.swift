import Foundation

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
        case id = "_id"
        case seller = "sellerId"
        case session = "sessionId"
        case gameDescription = "gameDescriptionId"
        case salePrice
        case forSale
        case pickedUp
        case sold
    }
}

// 🔹 Nested struct for seller details
struct SellerDepositedGameSellerInfo: Codable {
    let id: String
    let name: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case email
    }
}

// 🔹 Nested struct for session details
struct SellerDepositedGameSessionInfo: Codable {
    let id: String
    let name: String
    let startDate: String
    let endDate: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case startDate
        case endDate
    }
}

// 🔹 Nested struct for game description
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
        case id = "_id"
        case name
        case publisher
        case description
        case photoURL
        case minPlayers
        case maxPlayers
        case ageRange
    }
}
