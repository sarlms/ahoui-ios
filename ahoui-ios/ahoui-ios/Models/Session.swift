import Foundation

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
        case id = "_id"
        case name, location, description, startDate, endDate, depositFee, depositFeeLimitBeforeDiscount, depositFeeDiscount, saleComission, managerId
        case v = "__v"
    }
}
