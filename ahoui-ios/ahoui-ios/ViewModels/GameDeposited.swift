import Foundation

struct GameDeposited: Identifiable {
    let id = UUID()
    var name: String = ""
    var salePrice: String = "0"
    var isForSale: Bool = false
}
