import Foundation

struct Refund: Codable {
    let sellerId: String
    let sessionId: String
    let managerId: String
    let refundAmount: Double
    let refundDate: String
}
