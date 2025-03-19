//
//  CheckoutService.swift
//  
//
//  Created by etud on 19/03/2025.
//

import Foundation

class CartService {
    static let shared = CartService()
    private init() {}

    @Published private(set) var cartItems: [DepositedGame] = []

    /// Ajouter un jeu au panier s'il est à vendre et n'est pas déjà présent
    func addToCart(game: DepositedGame) {
        guard game.forSale else {
            print("❌ Ce jeu n'est pas en vente.")
            return
        }
        
        guard !game.sold else {
            print("❌ Ce jeu est déjà vendu.")
            return
        }

        if cartItems.contains(where: { $0.id == game.id }) {
            print("❌ Ce jeu est déjà dans le panier.")
            return
        }

        cartItems.append(game)
        print("✅ Jeu ajouté au panier : \(game.gameDescription.name)")
    }

    /// Supprimer un jeu du panier
    func removeFromCart(game: DepositedGame) {
        cartItems.removeAll { $0.id == game.id }
        print("🗑️ Jeu retiré du panier : \(game.gameDescription.name)")
    }

    /// Récupérer les jeux dans le panier
    func getCartItems() -> [DepositedGame] {
        return cartItems
    }
}
