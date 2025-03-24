import SwiftUI

struct CatalogueGameDetailView: View {
    @ObservedObject var viewModel: DepositedGameViewModel
    let gameId: String

    var body: some View {
        ZStack {
            Color(red: 1, green: 0.965, blue: 0.922)
                .edgesIgnoringSafeArea(.all)

            if let game = viewModel.selectedGame {
                VStack(spacing: 12) {
                    Text("\(game.gameDescription.name) : \(game.gameDescription.publisher)")
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)

                    AsyncImage(url: URL(string: game.gameDescription.photoURL)) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 241, height: 246)
                    } placeholder: {
                        Color.gray.opacity(0.3)
                            .frame(width: 241, height: 246)
                    }
                    .cornerRadius(10)

                    Text(game.sold ? "Vendu" : "Pas vendu")
                        .font(.custom("Poppins-Bold", size: 12))
                        .foregroundColor(game.sold ? .red : .green)

                    Text("Vendeur : \(game.seller?.name ?? "N/A")")
                        .font(.custom("Poppins-Bold", size: 12))
                        .foregroundColor(.black)

                    Text("Session : \(game.session?.name ?? "N/A") (\(game.session == nil ? "" : "Clôturée"))")
                        .font(.custom("Poppins-Bold", size: 12))
                        .foregroundColor(.black)

                    Text("Tranche d’âge : \(game.gameDescription.ageRange)")
                        .font(.custom("Poppins-Bold", size: 12))
                        .foregroundColor(.black)

                    Text("Nombre de joueurs : \(game.gameDescription.minPlayers) - \(game.gameDescription.maxPlayers)")
                        .font(.custom("Poppins-Bold", size: 12))
                        .foregroundColor(.black)

                    Text(game.gameDescription.description)
                        .font(.custom("Poppins-Regular", size: 11))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .frame(width: 291)

                    Text("\(game.salePrice, specifier: "%.0f")€")
                        .font(.custom("Montserrat-SemiBold", size: 30))
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 4)
                .padding()
            } else if viewModel.isLoading {
                ProgressView("Chargement du jeu...")
            } else {
                Text("Aucun jeu trouvé")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            viewModel.fetchDepositedGameById(gameId: gameId)
        }
    }
}
