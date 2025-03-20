import SwiftUI

struct CreateDepositedGameView: View {
    @StateObject private var sellerViewModel = SellerViewModel()
    @StateObject private var gameDescriptionViewModel = GameDescriptionViewModel(service: GameDescriptionService())
    @StateObject private var sessionViewModel = SessionViewModel()
    @StateObject private var depositedGameViewModel = CreateDepositedGameViewModel()

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
                                depositedGameViewModel.removeGame(at: index)
                            }
                        )
                    }
                }

                Button(action: {
                    depositedGameViewModel.addGame()
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
