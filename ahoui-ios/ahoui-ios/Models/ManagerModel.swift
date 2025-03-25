import Foundation

/// Represents a manager entity returned by the backend
struct Manager: Identifiable, Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phone: String
    let address: String
    let admin: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Maps the JSON field "_id" to the Swift property "id" because of MongoDB
        case firstName, lastName, email, phone, address, admin
    }
}

/// Represents the data required to create a new manager (used in POST requests)
struct CreateManager: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let phone: String
    let address: String
    let password: String
    let admin: Bool

    enum CodingKeys: String, CodingKey {
        case firstName, lastName, email, phone, address, password, admin
    }
}

/// Represents the data used to update an existing manager (used in PUT requests)
struct UpdateManager: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let phone: String
    let address: String
    let admin: Bool

    enum CodingKeys: String, CodingKey {
        case firstName, lastName, email, phone, address, admin
    }
}
