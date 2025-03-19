//
//  CartViewModel.swift
//  session
//
//  Created by etud on 19/03/2025.
//
import Foundation

// ✅ Création d'une structure identifiable pour gérer les erreurs
struct ErrorMessage: Identifiable {
    let id = UUID() // Identifiant unique pour SwiftUI
    let message: String
}

class CartViewModel: ObservableObject {
    @Published var cartItems: [DepositedGame] = []
    @Published var errorMessage: ErrorMessage?
    
    //let utiles au finalize checkout
    private let cartService = CartService.shared
    private let transactionService = TransactionService()
    private let sessionService = SessionService()
    private let sellerService = SellerService()
    private let depositedGameService = DepositedGameService()
    private let authViewModel = AuthViewModel()

    /// 🔹 Calcule automatiquement le total des jeux dans le panier
    var totalPrice: Double {
        return cartItems.reduce(0) { $0 + $1.salePrice }
    }

    func addGameToCart(byId id: String) {
        let depositedGameURL = "https://ahoui-back.cluster-ig4.igpolytech.fr/depositedGame/\(id)"

        guard let url = URL(string: depositedGameURL) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = ErrorMessage(message: "Erreur de récupération : \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    self.errorMessage = ErrorMessage(message: "Aucune donnée reçue.")
                    return
                }

                do {
                    let depositedGame = try JSONDecoder().decode(DepositedGame.self, from: data)

                    if !depositedGame.forSale {
                        self.errorMessage = ErrorMessage(message: "❌ Ce jeu n'est pas à vendre.")
                        return
                    }

                    if self.cartItems.contains(where: { $0.id == depositedGame.id }) {
                        self.errorMessage = ErrorMessage(message: "❌ Ce jeu est déjà dans le panier.")
                        return
                    }

                    self.cartService.addToCart(game: depositedGame)
                    self.cartItems = self.cartService.getCartItems()
                } catch {
                    self.errorMessage = ErrorMessage(message: "❌ Erreur de décodage des données.")
                }
            }
        }.resume()
    }

    func removeFromCart(game: DepositedGame) {
        cartService.removeFromCart(game: game)
        cartItems = cartService.getCartItems()
    }
    
    /// 🔹 Finaliser l'encaissement
    func finalizeCheckout(clientId: String?) {
        print("🔹 Début de finalizeCheckout")

        // 🔹 Récupérer le managerId depuis UserDefaults
        guard let managerId = UserDefaults.standard.string(forKey: "managerId") else {
            DispatchQueue.main.async {
                self.errorMessage = ErrorMessage(message: "❌ Impossible de récupérer le manager.")
            }
            print("❌ Erreur : managerId introuvable")
            return
        }
        print("✅ Manager ID récupéré depuis UserDefaults : \(managerId)")

        guard !cartItems.isEmpty else {
            DispatchQueue.main.async {
                self.errorMessage = ErrorMessage(message: "❌ Votre panier est vide.")
            }
            print("❌ Le panier est vide, abandon de la transaction.")
            return
        }

        guard let clientId = clientId else {
            DispatchQueue.main.async {
                self.errorMessage = ErrorMessage(message: "❌ Veuillez sélectionner un client.")
            }
            print("❌ Aucun client sélectionné, abandon de la transaction.")
            return
        }

        print("✅ Client sélectionné : \(clientId)")

        // 🟢 Récupérer la session active
        sessionService.fetchActiveSessionId { sessionId in
            guard let sessionId = sessionId else {
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: "❌ Aucune session active trouvée.")
                }
                print("❌ Session active introuvable")
                return
            }

            print("✅ ID de la session active : \(sessionId)")

            // 🔹 Construire les transactions
            let transactions = self.cartItems.map { game in
                let transaction = TransactionRequest(
                    labelId: game.id,
                    sessionId: sessionId,
                    sellerId: game.seller?.id ?? "",
                    clientId: clientId,
                    managerId: managerId
                )
                print("📩 Transaction créée : \(transaction)")
                return transaction
            }

            // 🔹 Envoyer les transactions au backend
            self.transactionService.createMultipleTransactions(transactions: transactions) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        print("✅ Transactions envoyées avec succès.")
                        self.updateSoldGamesAndSellers()
                        self.cartItems.removeAll() // ✅ Vider le panier après validation
                    case .failure(let error):
                        self.errorMessage = ErrorMessage(message: "❌ Erreur lors de la validation: \(error.localizedDescription)")
                        print("❌ Erreur lors de la création des transactions : \(error.localizedDescription)")
                    }
                }
            }
        }
    }




    /// 🔹 Mettre à jour les jeux vendus et le montant des vendeurs
    private func updateSoldGamesAndSellers() {
        print("🔹 Début de la mise à jour des jeux vendus et des montants des vendeurs")

        for game in cartItems {
            print("📌 Tentative de marquage comme vendu du jeu : \(game.id) - \(game.gameDescription.name)")

            depositedGameService.markAsSold(gameId: game.id) { result in
                switch result {
                case .success:
                    print("✅ Jeu marqué comme vendu : \(game.id)")
                case .failure(let error):
                    print("❌ Erreur : Impossible de marquer le jeu comme vendu : \(game.id) - \(error.localizedDescription)")
                }
            }

            if let sellerId = game.seller?.id, let commission = game.session?.saleComission {
                let amountToAdd = game.salePrice - (game.salePrice * Double(commission) / 100)
                print("📌 Ajout du montant \(amountToAdd) au vendeur \(sellerId)")

                sellerService.updateSellerAmountOwed(sellerId: sellerId, amount: amountToAdd) { result in
                    switch result {
                    case .success:
                        print("✅ Montant mis à jour pour le vendeur : \(sellerId)")
                    case .failure(let error):
                        print("❌ Erreur : Impossible de mettre à jour le montant du vendeur : \(sellerId) - \(error.localizedDescription)")
                    }
                }
            }
        }
    }

}
