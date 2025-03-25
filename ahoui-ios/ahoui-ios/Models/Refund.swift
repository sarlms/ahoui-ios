import Foundation

/*
struct Refund: Codable {
    let sellerId: String
    let sessionId: String
    let managerId: String
    let refundAmount: Double
    let refundDate: String
} */

/// Represents a refund record returned by the backend
struct Refund: Codable, Identifiable {
    let id: String
    let sellerId: SellerInfo
    let sessionId: SessionInfo?
    let managerId: ManagerInfo
    let refundAmount: Double
    let refundDate: String

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case sellerId
        case sessionId
        case managerId
        case refundAmount
        case refundDate
    }
}

/// Represents the data needed to create a refund (used in POST requests)
struct CreateRefund: Codable {
    let sellerId: String
    let sessionId: String
    let managerId: String
    let refundAmount: Double
    let refundDate: String
}

/// Minimal information about a seller, used in refund records
struct SellerInfo: Codable {
    let id: String
    let name: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case name
        case email
    }
}

/// Minimal information about a session, used in refund records
struct SessionInfo: Codable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case name
    }
}

/// Minimal information about a manager, used in refund records
struct ManagerInfo: Codable {
    let id: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case email
    }
}
