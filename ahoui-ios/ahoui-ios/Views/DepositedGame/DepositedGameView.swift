import SwiftUI

struct DepositedGameView: View {
    @StateObject private var viewModel = DepositedGameViewModel(service: DepositedGameService())
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @State private var isMenuOpen = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 1, green: 0.965, blue: 0.922)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    Text("Jeux déposés")
                        .font(.custom("Poppins-SemiBold", size: 25))
                        .foregroundColor(.black)
                        .padding(.top, 40)

                    HStack(spacing: 12) {
                        Picker("Session", selection: .constant("")) {
                            Text("Toutes les sessions")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 157, height: 26)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))

                        Picker("Vendeur", selection: .constant("")) {
                            Text("Tous les vendeurs")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 157, height: 26)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
                    }

                    ScrollView {
                        if viewModel.isLoading {
                            ProgressView("Chargement des jeux déposés...")
                        } else if let errorMessage = viewModel.errorMessage {
                            Text("❌ Erreur: \(errorMessage)").foregroundColor(.red)
                        } else if viewModel.depositedGames.isEmpty {
                            Text("⚠️ Aucun jeu déposé trouvé.")
                                .font(.custom("Poppins", size: 16))
                                .foregroundColor(.gray)
                        } else {
                            VStack(spacing: 20) {
                                ForEach(viewModel.depositedGames) { game in
                                    DepositedGameCardView(game: game)
                                }
                            }
                            .padding(.top, 10)
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 24)

                NavBarView(isMenuOpen: $isMenuOpen)
                    .environmentObject(navigationViewModel)
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                viewModel.fetchAllDepositedGames()
            }
        }
    }
}


struct DepositedGameCardView: View {
    let game: DepositedGame

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(game.gameDescription.name) | \(String(format: "%.0f", game.salePrice))€")
                .font(.custom("Poppins-SemiBold", size: 18))
                .foregroundColor(.black)

            VStack(alignment: .leading, spacing: 6) {
                Text("Vendeur")
                    .font(.custom("Poppins-SemiBold", size: 15))
                Text("Nom : \(game.seller?.name ?? "N/A")")
                    .font(.custom("Poppins-Bold", size: 12))
                Text("Email : \(game.seller?.email ?? "N/A")")
                    .font(.custom("Poppins-Bold", size: 12))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Session")
                    .font(.custom("Poppins-SemiBold", size: 15))
                Text("Nom : \(game.session?.name ?? "N/A")")
                    .font(.custom("Poppins-Bold", size: 12))
                Text("Statut : clôturée")
                    .font(.custom("Poppins-Bold", size: 12))
                    .foregroundColor(.pink)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Etiquette")
                    .font(.custom("Poppins-SemiBold", size: 15))
                Text(game.id)
                    .font(.custom("Poppins-Light", size: 12))
            }

            VStack(spacing: 6) {
                Text("Vendu ?")
                    .font(.custom("Poppins-SemiBold", size: 18))

                Text(game.sold ? "Oui" : "Non")
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 20)
                    .background(Color.black)
                    .cornerRadius(20)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
    }
}
