import Foundation

struct DepositFeePayment: Codable, Identifiable {
    let id: String
    let sellerId: SellerInfoDepositFeePayment
    let sessionId: SessionInfoDepositFeePayment?
    let managerId: ManagerInfoDepositFeePayment
    let depositFeePayed: Double
    let depositDate: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case sellerId
        case sessionId
        case managerId
        case depositFeePayed
        case depositDate
    }
}

struct SellerInfoDepositFeePayment: Codable {
    let id: String
    let name: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case email
    }
}

struct SessionInfoDepositFeePayment: Codable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}

struct ManagerInfoDepositFeePayment: Codable {
    let id: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email
    }
}
