import Foundation

/// Represents a cart item
struct CartItem: Identifiable {
    let id: String
    let game: DepositedGame
}
