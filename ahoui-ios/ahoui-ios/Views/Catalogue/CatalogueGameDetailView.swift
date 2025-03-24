import SwiftUI

struct CatalogueGameDetailView: View {
    @ObservedObject var viewModel: DepositedGameViewModel
    let gameId: String
    @Environment(\.presentationMode) var presentationMode
    @State private var isMenuOpen = false
    @EnvironmentObject var navigationViewModel: NavigationViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 1, green: 0.965, blue: 0.922)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer().frame(height: 150) // 👈 Pour baisser tout le contenu sous la NavBar

                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                            Text("Retour")
                                .foregroundColor(.black)
                                .font(.custom("Poppins-SemiBold", size: 16))
                        }
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    if let game = viewModel.selectedGame {
                        VStack(spacing: 12) {
                            Text("\(game.gameDescription.name) : \(game.gameDescription.publisher)")
                                .font(.custom("Poppins-Bold", size: 18))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.top, 10)

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
                                .font(.custom("Poppins-Medium", size: 11))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .frame(width: 291)

                            Text("\(game.salePrice, specifier: "%.0f")€")
                                .font(.custom("Poppins-Bold", size: 30))
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding()
                    } else if viewModel.isLoading {
                        ProgressView("Chargement du jeu...")
                    } else {
                        Text("Aucun jeu trouvé")
                            .foregroundColor(.red)
                    }

                    Spacer()
                }

                // ✅ NavBar en overlay
                NavBarView(isMenuOpen: $isMenuOpen)
                    .environmentObject(navigationViewModel)
            }
            .onAppear {
                viewModel.fetchDepositedGameById(gameId: gameId)
            }
        }
    }
}
