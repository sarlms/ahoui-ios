import Foundation

class CreateDepositedGameViewModel: ObservableObject {
    @Published var gameContainers: [GameDeposited] = [GameDeposited()]
    @Published var totalDepositFee: Double = 0
    @Published var totalDiscount: Double = 0
    @Published var totalAfterDiscount: Double = 0

    let depositedGameService = DepositedGameService()
    let paymentService = DepositFeePaymentService()

    func addGame(session: Session) {
        gameContainers.append(GameDeposited())
        updateTotals(session: session)
    }

    func removeGame(at index: Int, session: Session) {
        guard gameContainers.indices.contains(index), gameContainers.count > 1 else { return }
        gameContainers.remove(at: index)
        updateTotals(session: session)
    }

    func initializeTotals(with session: Session) {
        updateTotals(session: session)
    }

    func updateTotals(session: Session) {
        let count = gameContainers.count
        let depositFee = session.depositFee
        let discountThreshold = session.depositFeeLimitBeforeDiscount
        let discountRate = session.depositFeeDiscount

        totalDepositFee = Double(count) * Double(depositFee)
        totalDiscount = count >= discountThreshold ? (totalDepositFee * Double(discountRate)) / 100 : 0
        totalAfterDiscount = totalDepositFee - totalDiscount
    }

    func submitDepositedGames(
        session: Session,
        sellerId: String,
        managerId: String,
        token: String,
        gameDescriptionViewModel: GameDescriptionViewModel
    ) {
        for game in gameContainers {
            guard let gameDescriptionId = gameDescriptionViewModel.gameDescriptions.first(where: { $0.name == game.name })?.id else {
                print("❌ Impossible de trouver l'ID pour le jeu nommé '\(game.name)'")
                continue
            }

            let depositedGameData: [String: Any] = [
                "sellerId": sellerId,
                "sessionId": session.id,
                "gameDescriptionId": gameDescriptionId,
                "salePrice": Double(game.salePrice) ?? 0,
                "forSale": game.isForSale
            ]

            depositedGameService.createDepositedGame(data: depositedGameData, token: token) { result in
                switch result {
                case .success:
                    print("✅ Jeu déposé créé : \(game.name)")
                case .failure(let error):
                    print("❌ Erreur dépôt jeu : \(error)")
                }
            }
        }

        let payment = DepositFeePaymentRequest(
            sessionId: session.id,
            sellerId: sellerId,
            depositFeePayed: totalAfterDiscount
        )

        paymentService.createPayment(payment: payment, token: token) { result in
            switch result {
            case .success:
                print("✅ Paiement des frais de dépôt enregistré.")
            case .failure(let error):
                print("❌ Erreur lors du paiement : \(error.localizedDescription)")
            }
        }
    }
}
