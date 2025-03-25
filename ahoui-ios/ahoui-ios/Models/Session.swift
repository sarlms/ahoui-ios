import Foundation

/// Represents a session entity in the backend
struct Session: Codable, Identifiable {
    let id: String
    let name: String
    let location: String
    let description: String?
    let startDate: String
    let endDate: String
    let depositFee: Int
    let depositFeeLimitBeforeDiscount: Int
    let depositFeeDiscount: Int
    let saleComission: Int
    let managerId: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case name, location, description, startDate, endDate, depositFee, depositFeeLimitBeforeDiscount, depositFeeDiscount, saleComission, managerId
        case v = "__v"
    }
}

