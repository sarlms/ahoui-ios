import SwiftUI

struct DepositedGameView: View {
    @StateObject private var viewModel = DepositedGameViewModel(service: DepositedGameService())

    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView("Chargement des jeux déposés...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("❌ Erreur: \(errorMessage)").foregroundColor(.red)
                } else if viewModel.depositedGames.isEmpty {
                    Text("⚠️ Aucun jeu déposé trouvé.").font(.headline).foregroundColor(.gray)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(viewModel.depositedGames) { game in
                            DepositedGameCardView(game: game) // ✅ FIXED: Now passing DepositedGame
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Jeux Déposés")
            .onAppear {
                print("🔹 DepositedGameView appeared") // ✅ Debugging
                viewModel.fetchAllDepositedGames()
            }
        }
    }
}


struct DepositedGameCardView: View {
    let game: DepositedGame // ✅ FIX: Use DepositedGame

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ID: \(game.id)") // ✅ Debugging: Ensure each game has an ID
                .font(.caption)
                .foregroundColor(.gray)
            
            Text("\(game.gameDescription.name) | \(String(format: "%.2f", game.salePrice))€")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Vendeur")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                Text("Nom : \(game.seller!.name)")
                    .font(.system(size: 14))
                Text("Email : \(game.seller!.email)")
                    .font(.system(size: 14))
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Session")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                Text("Nom : \(game.session!.name)")
                    .font(.system(size: 14))
                Text("Statut : clôturée")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.pink)
            }
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
        .padding()
    }
}
