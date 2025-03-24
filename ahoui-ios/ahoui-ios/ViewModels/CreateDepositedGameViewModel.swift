import Foundation

class CreateDepositedGameViewModel: ObservableObject {
    @Published var gameContainers: [GameDeposited] = [GameDeposited()]
    @Published var totalDepositFee: Double = 0
    @Published var totalDiscount: Double = 0
    @Published var totalAfterDiscount: Double = 0
    @Published var payments: [DepositFeePayment] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = DepositFeePaymentService()

    let depositedGameService = DepositedGameService()
    let paymentService = DepositFeePaymentService()

    func addGame(session: Session) {
        gameContainers.append(GameDeposited())
        updateTotals(session: session)
    }

    func removeGame(id: UUID, session: Session) {
        gameContainers.removeAll { $0.id == id }
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
        gameDescriptionViewModel: GameDescriptionViewModel,
        token: String
    )
    {
        // 🔍 Récupération du managerId et token
        guard let managerId = UserDefaults.standard.string(forKey: "managerId") else {
            print("❌ managerId manquant")
            return
        }

        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("❌ Token manquant")
            return
        }

        print("🔐 managerId = \(managerId)")
        print("🔐 token = \(token)")
        print("🎯 sellerId = \(sellerId)")
        print("🎯 sessionId = \(session.id)")

        // 🔁 Création de chaque jeu
        for game in gameContainers {
            guard let gameDescriptionId = gameDescriptionViewModel.gameDescriptions.first(where: { $0.name == game.name })?.id else {
                print("❌ Jeu non trouvé dans la base : \(game.name)")
                continue
            }

            let depositedGameData: [String: Any] = [
                "sellerId": sellerId,
                "sessionId": session.id,
                "gameDescriptionId": gameDescriptionId,
                "salePrice": Double(game.salePrice) ?? 0,
                "forSale": game.isForSale
            ]

            print("📦 Envoi DepositedGame : \(depositedGameData)")

            depositedGameService.createDepositedGame(data: depositedGameData) { result in
                switch result {
                case .success:
                    print("✅ Jeu déposé ajouté : \(game.name)")
                case .failure(let error):
                    print("❌ Erreur lors de l’ajout du jeu : \(error.localizedDescription)")
                }
            }
        }

        let isoFormatter = ISO8601DateFormatter()
        let currentDateString = isoFormatter.string(from: Date()) // date actuelle en ISO 8601

        let payment = DepositFeePaymentRequest(
            sessionId: session.id,
            sellerId: sellerId,
            depositFeePayed: totalAfterDiscount,
            depositDate: currentDateString
        )


        print("💰 Envoi du paiement avec TOKEN : \(token)")

        paymentService.createPayment(payment: payment, token: token) { result in
            switch result {
            case .success:
                print("✅ Paiement enregistré avec succès")
            case .failure(let error):
                print("❌ Erreur lors du paiement : \(error.localizedDescription)")
            }
        }
    }
}
