import Foundation

/// Represents a transaction in the backend
struct Transaction: Identifiable, Codable {
    let id: String
    let label: TransactionLabelInfo
    let session: TransactionSessionInfo
    let sellerId: String
    let client: TransactionClientInfo
    let manager: TransactionManagerInfo
    let transactionDate: String

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case label = "labelId" // Reference to label object
        case session = "sessionId" // Reference so session object
        case sellerId = "sellerId" // Reference to seller object
        case client = "clientId" // Reference to client object
        case manager = "managerId" // Reference to manager object
        case transactionDate
    }
}

/// Nested struct for Seller Info
struct TransactionSellerInfo: Codable {
    let id: String
    let name: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case name
        case email
    }
}

/// Local struct for LabelInfo (to avoid modifying existing GameDescriptionInfo)
struct TransactionLabelInfo: Codable {
    let id: String
    let salePrice: Double
    let gameDescription: TransactionGameDescriptionInfo  // Local struct

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case salePrice
        case gameDescription = "gameDescriptionId" // Rerefence to game description object
    }
}

/// Local struct for SessionInfo (to avoid breaking other uses)
struct TransactionSessionInfo: Codable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case name
    }
}

// 🔹 Local struct for Client (instead of using `Client`)
struct TransactionClientInfo: Codable {
    let id: String
    let name: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case name
        case email
    }
}

// 🔹 Local struct for Manager (instead of modifying existing Manager model)
struct TransactionManagerInfo: Codable {
    let id: String
    let firstName: String
    let lastName: String

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case firstName
        case lastName
    }
}

// 🔹 Local struct for GameDescription (instead of modifying `GameDescriptionInfo`)
struct TransactionGameDescriptionInfo: Codable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case name
    }
}

struct TransactionList: Identifiable, Codable {
    let id: String
    let label: TransactionLabelInfo
    let session: TransactionSessionInfo
    let seller: TransactionSellerInfo
    let client: TransactionClientInfo
    let manager: TransactionManagerInfo
    let transactionDate: String

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case label = "labelId" // Reference to label object
        case session = "sessionId" // Reference to session object
        case seller = "sellerId" // Reference to seller object
        case client = "clientId" // Reference to client object
        case manager = "managerId" // Reference to manager object
        case transactionDate
    }
}
