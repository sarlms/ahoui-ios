import SwiftUI

struct CreateDepositedGameView: View {
    @StateObject private var sellerViewModel = SellerViewModel()
    @StateObject private var gameDescriptionViewModel = GameDescriptionViewModel(service: GameDescriptionService())
    @StateObject private var sessionViewModel = SessionViewModel()
    @StateObject private var depositedGameViewModel = CreateDepositedGameViewModel()
    @StateObject private var authViewModel = AuthViewModel()

    @State private var showSellerDropdown = false
    @State private var showGameDropdown = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                SellerSelectionView(
                    sellerViewModel: sellerViewModel,
                    showSellerDropdown: $showSellerDropdown
                )
                .onAppear {
                    sellerViewModel.fetchSellers()
                    sellerViewModel.fetchUniqueSellerEmails()
                    sessionViewModel.loadActiveSession()
                }

                if let session = sessionViewModel.activeSession {
                    SessionInfoView(session: session)
                }

                VStack {
                    ForEach($depositedGameViewModel.gameContainers.indices, id: \.self) { index in
                        GameSelectionView(
                            game: $depositedGameViewModel.gameContainers[index],
                            gameDescriptionViewModel: gameDescriptionViewModel,
                            removeAction: {
                                if let session = sessionViewModel.activeSession {
                                    depositedGameViewModel.removeGame(at: index, session: session)
                                }
                            }
                        )
                    }
                }

                Button(action: {
                    if let session = sessionViewModel.activeSession {
                        depositedGameViewModel.addGame(session: session)
                    }
                }) {
                    Text("+ Ajouter un jeu")
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .padding()
                        .frame(width: 200)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                }
                .padding(.top, 10)

                if let session = sessionViewModel.activeSession {
                    TotalFeesView(viewModel: depositedGameViewModel, session: session)
                }

                // 🔘 Bouton VALIDER
                Button(action: {
                    print("🔍 SESSION : \(sessionViewModel.activeSession?.id ?? "nil")")
                    print("🔍 SELLER ID : \(sellerViewModel.selectedSeller?.id ?? "nil")")
                    print("🔍 MANAGER ID : \(UserDefaults.standard.string(forKey: "managerId") ?? "nil")")
                    print("🔍 TOKEN : \(UserDefaults.standard.string(forKey: "token") ?? "nil")")

                    guard
                        let session = sessionViewModel.activeSession,
                        let sellerId = sellerViewModel.selectedSeller?.id,
                        let managerId = UserDefaults.standard.string(forKey: "managerId"),
                        let token = UserDefaults.standard.string(forKey: "token")
                    else {
                        print("❌ Données manquantes pour soumettre")
                        return
                    }

                    print("✅ Toutes les données sont disponibles, on envoie !")

                    depositedGameViewModel.submitDepositedGames(
                        session: session,
                        sellerId: sellerId,
                        gameDescriptionViewModel: gameDescriptionViewModel,
                        token: token
                    )


                }) {
                    Text("Valider")
                        .font(.custom("Poppins-Bold", size: 16))
                        .padding()
                        .frame(width: 200)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 10)

            }
            .padding()
        }
        .onAppear {
            gameDescriptionViewModel.fetchGameDescriptions()
            sessionViewModel.loadActiveSession()
            if let session = sessionViewModel.activeSession {
                depositedGameViewModel.initializeTotals(with: session)
            }
        }
    }
}
