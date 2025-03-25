import Foundation

class CartService {
    static let shared = CartService()
    private init() {}

    @Published private(set) var cartItems: [DepositedGame] = []

    /// POST request to add a game to the cart if it is not already inside the cart
    func addToCart(game: DepositedGame) {
        guard game.forSale else {
            print("Ce jeu n'est pas en vente.")
            return
        }
        
        guard !game.sold else {
            print("Ce jeu est déjà vendu.")
            return
        }

        if cartItems.contains(where: { $0.id == game.id }) {
            print("Ce jeu est déjà dans le panier.")
            return
        }

        cartItems.append(game)
        print("Jeu ajouté au panier : \(game.gameDescription.name)")
    }

    /// DELETE request to remove a game from the cart
    func removeFromCart(game: DepositedGame) {
        cartItems.removeAll { $0.id == game.id }
        print("Jeu retiré du panier : \(game.gameDescription.name)")
    }

    /// get the cart items
    func getCartItems() -> [DepositedGame] {
        return cartItems
    }
}
