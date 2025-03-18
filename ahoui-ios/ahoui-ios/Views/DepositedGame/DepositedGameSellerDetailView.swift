import SwiftUI

struct DepositedGameSellerDetailView: View {
    let game: DepositedGame

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // ✅ Use gameDescription.name instead of gameDescriptionId
            Text("\(game.gameDescription.name) | \(String(format: "%.2f", game.salePrice))€")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)

            // ✅ Use session.name instead of sessionId
            VStack(alignment: .leading, spacing: 5) {
                Text("Session")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                
                Text("Nom : \(game.session.name)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.black)

                Text("Statut : clôturée") // Assuming all sessions are closed
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.pink)
            }

            // Game status details
            VStack(alignment: .leading, spacing: 5) {
                Text("Status du jeu")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)

                Text("Vendu : \(game.sold ? "Oui" : "Non")")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.black)

                Text("Disponible : \(game.forSale ? "Oui" : "Non")")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.black)

                Text("Récupéré : \(game.pickedUp ? "Oui" : "Non")")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.black)
            }
        }
        .padding()
        .frame(width: 300)
        .background(Color.white.opacity(0.5))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
    }
}
