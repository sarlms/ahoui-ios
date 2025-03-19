import Foundation

struct DepositedGame: Identifiable, Codable {
    let id: String
    let seller: DepositedGameSellerInfo?
    let session: DepositedGameSessionInfo?
    let gameDescription: DepositedGameDescriptionInfo
    let salePrice: Double
    let forSale: Bool
    let pickedUp: Bool
    let sold: Bool

    // ✅ Map `_id` from MongoDB to `id`
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case seller = "sellerId" // ✅ Correct mapping
        case session = "sessionId" // ✅ Correct mapping
        case gameDescription = "gameDescriptionId" // ✅ Correct mapping
        case salePrice
        case forSale
        case pickedUp
        case sold
    }
}

// 🔹 Nested struct for seller details
struct DepositedGameSellerInfo: Codable {
    let id: String
    let name: String
    let email: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case email
    }
}

// 🔹 Nested struct for session details
struct DepositedGameSessionInfo: Codable {
    let id: String
    let name: String
    let saleComission: Int? // ✅ Removed startDate and endDate (they were missing in API)

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case saleComission
    }
}

// 🔹 Nested struct for game description
struct DepositedGameDescriptionInfo: Codable {
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
