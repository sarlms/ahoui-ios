import Foundation

struct Client: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    let phone: String
    let address: String

    // Map `_id` from MongoDB to `id`
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case email
        case phone
        case address
    }
}
