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
