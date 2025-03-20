import Foundation

struct Transaction: Identifiable, Codable {
    let id: String
    let label: TransactionLabelInfo  // ✅ Local struct inside Transaction
    let session: TransactionSessionInfo  // ✅ Local struct inside Transaction
    let sellerId: String  // ✅ Keep as String (to avoid conflicts)
    let client: TransactionClientInfo  // ✅ Local struct inside Transaction
    let manager: TransactionManagerInfo  // ✅ Local struct inside Transaction
    let transactionDate: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case label = "labelId"
        case session = "sessionId"
        case sellerId = "sellerId"
        case client = "clientId"
        case manager = "managerId"
        case transactionDate
    }
}

// 🔹 Fix: Create a struct for Seller Info
struct TransactionSellerInfo: Codable {
    let id: String
    let name: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case email
    }
}

// 🔹 Local struct for LabelInfo (to avoid modifying existing GameDescriptionInfo)
struct TransactionLabelInfo: Codable {
    let id: String
    let salePrice: Double
    let gameDescription: TransactionGameDescriptionInfo  // ✅ Local struct

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case salePrice
        case gameDescription = "gameDescriptionId"
    }
}

// 🔹 Local struct for SessionInfo (to avoid breaking other uses)
struct TransactionSessionInfo: Codable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}

// 🔹 Local struct for Client (instead of using `Client`)
struct TransactionClientInfo: Codable {
    let id: String
    let name: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
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
        case id = "_id"
        case firstName
        case lastName
    }
}

// 🔹 Local struct for GameDescription (instead of modifying `GameDescriptionInfo`)
struct TransactionGameDescriptionInfo: Codable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}

struct TransactionList: Identifiable, Codable {
    let id: String
    let label: TransactionLabelInfo  // ✅ Struct for labelId
    let session: TransactionSessionInfo  // ✅ Struct for sessionId
    let seller: TransactionSellerInfo  // ✅ Fix: seller is an object, not a string
    let client: TransactionClientInfo  // ✅ Struct for clientId
    let manager: TransactionManagerInfo  // ✅ Struct for managerId
    let transactionDate: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case label = "labelId"
        case session = "sessionId"
        case seller = "sellerId"  // ✅ Fix: match JSON response
        case client = "clientId"
        case manager = "managerId"
        case transactionDate
    }
}
