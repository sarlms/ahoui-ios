import Foundation

// Represents the client in the database
struct Client: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    let phone: String
    let address: String

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case name
        case email
        case phone
        case address
    }
}
