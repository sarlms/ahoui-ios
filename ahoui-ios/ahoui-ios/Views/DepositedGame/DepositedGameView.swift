import SwiftUI

struct DepositedGameView: View {
    @StateObject private var viewModel = DepositedGameViewModel(service: DepositedGameService())

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                    ForEach(viewModel.depositedGames) { game in
                        DepositedGameCardView(game: game) // ✅ Using a separate card component
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
            }
            .navigationTitle("Jeux Déposés")
            .onAppear {
                viewModel.fetchAllDepositedGames()
            }
        }
    }
}

struct DepositedGameCardView: View {
    let game: DepositedGame
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(game.gameDescription.name) | \(String(format: "%.2f", game.salePrice))€")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Vendeur")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                Text("Nom : \(game.seller.name)")
                    .font(.system(size: 14))
                Text("Email : \(game.seller.email)")
                    .font(.system(size: 14))
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Session")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                Text("Nom : \(game.session.name)")
                    .font(.system(size: 14))
                Text("Statut : clôturée") // Assuming all sessions are closed
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.pink)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Etiquette")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                Text("\(game.id)")
                    .font(.system(size: 14))
            }
            
            VStack(alignment: .center, spacing: 5) {
                Text("Vendu ?")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                
                Text(game.sold ? "Oui" : "Non")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 80)
                    .background(Color.black)
                    .cornerRadius(20)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
        .padding()
    }
}
