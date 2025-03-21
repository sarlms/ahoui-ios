import Foundation

/*
struct Refund: Codable {
    let sellerId: String
    let sessionId: String
    let managerId: String
    let refundAmount: Double
    let refundDate: String
} */

struct CreateRefund: Codable {
    let sellerId: String
    let sessionId: String
    let managerId: String
    let refundAmount: Double
    let refundDate: String
}

struct Refund: Codable, Identifiable {
    let id: String
    let sellerId: SellerInfo
    let sessionId: SessionInfo?
    let managerId: ManagerInfo
    let refundAmount: Double
    let refundDate: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case sellerId
        case sessionId
        case managerId
        case refundAmount
        case refundDate
    }
}

struct SellerInfo: Codable {
    let id: String
    let name: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case email
    }
}

struct SessionInfo: Codable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}

struct ManagerInfo: Codable {
    let id: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email
    }
}
