import SwiftUI

class CreateDepositedGameViewModel: ObservableObject {
    @Published var gameContainers: [GameDeposited] = [GameDeposited()] // ✅ Premier jeu par défaut
    @Published var totalDepositFee: Double = 0
    @Published var totalDiscount: Double = 0
    @Published var totalAfterDiscount: Double = 0

    func initializeTotals(with session: Session) {
        totalDepositFee = Double(session.depositFee)
        totalAfterDiscount = Double(session.depositFee)
    }

    func updateTotals(session: Session?) {
        guard let session = session else { return }

        let depositFee = session.depositFee
        let depositFeeLimitBeforeDiscount = session.depositFeeLimitBeforeDiscount
        let depositFeeDiscount = session.depositFeeDiscount

        totalDepositFee = Double(gameContainers.count) * Double(depositFee)
        let eligibleForDiscount = gameContainers.count >= depositFeeLimitBeforeDiscount
        totalDiscount = eligibleForDiscount ? (totalDepositFee * Double(depositFeeDiscount)) / 100 : 0
        totalAfterDiscount = totalDepositFee - totalDiscount
    }

    func addGame() {
        gameContainers.append(GameDeposited())
        updateTotals(session: SessionViewModel().activeSession) // ✅ Met à jour les totaux à chaque ajout
    }

    func removeGame(at index: Int) {
        if gameContainers.count > 1 {
            gameContainers.remove(at: index)
            updateTotals(session: SessionViewModel().activeSession) // ✅ Met à jour les totaux à chaque suppression
        }
    }
}
