struct Manager: Identifiable, Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phone: String
    let address: String
    let admin: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id" // ✅ Tells Swift to use _id from JSON
        case firstName, lastName, email, phone, address, admin
    }
}

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
