import Foundation

/// Represents a deposit fee payment in the database
struct DepositFeePayment: Codable, Identifiable {
    let id: String
    let sellerId: SellerInfoDepositFeePayment
    let sessionId: SessionInfoDepositFeePayment?
    let managerId: ManagerInfoDepositFeePayment
    let depositFeePayed: Double
    let depositDate: String

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case sellerId
        case sessionId
        case managerId
        case depositFeePayed
        case depositDate
    }
}

/// Nested struct for the info of a seller
struct SellerInfoDepositFeePayment: Codable {
    let id: String
    let name: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case name
        case email
    }
}

/// Nested struct for the info of a session
struct SessionInfoDepositFeePayment: Codable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case name
    }
}

/// Nested struct for the info of a manager
struct ManagerInfoDepositFeePayment: Codable {
    let id: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case email
    }
}
