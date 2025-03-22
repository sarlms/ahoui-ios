import SwiftUI

struct CreateDepositedGameView: View {
    @StateObject private var sellerViewModel = SellerViewModel()
    @StateObject private var gameDescriptionViewModel = GameDescriptionViewModel(service: GameDescriptionService())
    @StateObject private var sessionViewModel = SessionViewModel()
    @StateObject private var depositedGameViewModel = CreateDepositedGameViewModel()
    @StateObject private var authViewModel = AuthViewModel()

    @State private var showSellerDropdown = false
    @State private var showGameDropdown = false

    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @State private var isMenuOpen = false
    @State private var shouldNavigate = false
    @StateObject private var viewModel = CreateDepositedGameViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 1, green: 0.965, blue: 0.922)
                    .ignoresSafeArea()
                
                ScrollView {
                    Color(red: 1, green: 0.965, blue: 0.922)
                        .ignoresSafeArea()
                    VStack(spacing: 20) {
                        Text("Déposer un jeu")
                            .font(.custom("Poppins-Bold", size: 25))
                            .foregroundColor(.black)
                            .padding(.top, 50)
                        
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
                            ForEach($depositedGameViewModel.gameContainers) { $game in
                                GameSelectionView(
                                    game: $game,
                                    gameDescriptionViewModel: gameDescriptionViewModel,
                                    removeAction: {
                                        if let session = sessionViewModel.activeSession {
                                            depositedGameViewModel.removeGame(id: game.id, session: session)
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
                                .foregroundColor(.black)
                                .padding()
                                .frame(width: 150, height: 50)
                                .background(Color.white.opacity(0.5))
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                        }
                        .padding(.top, 0)
                        
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
                                shouldNavigate = true // 🔁 Déclenche la navigation
                            
                            
                        }) {
                            Text("VALIDER")
                                .font(.custom("Poppins-Bold", size: 16))
                                .padding()
                                .frame(width: 110)
                                .background(Color(red: 0.05, green: 0.61, blue: 0.043))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, 10)
                        
                    }
                    .padding()
                    .navigationDestination(isPresented: $shouldNavigate) {
                        DepositedGameView()
                    }
                }
                .onAppear {
                    gameDescriptionViewModel.fetchGameDescriptions()
                    sessionViewModel.loadActiveSession()
                    if let session = sessionViewModel.activeSession {
                        depositedGameViewModel.initializeTotals(with: session)
                    }
                }
                .navigationBarBackButtonHidden(true)
                .background(Color(red: 1, green: 0.965, blue: 0.922))
                .overlay(
                    NavBarView(isMenuOpen: $isMenuOpen)
                        .environmentObject(viewModel)
                )
            }
        }
    }
}
