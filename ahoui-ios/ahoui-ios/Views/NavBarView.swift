import SwiftUI

struct NavBarView: View {
    @Binding var isMenuOpen: Bool
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var shouldNavigateToSellerList = false
    @State private var shouldNavigateToHome = false
    @State private var shouldNavigateToDepositedGames = false
    @State private var shouldNavigateToCart = false
    @State private var shouldNavigateToClientList = false
    @State private var shouldNavigateToManagerList = false
    @State private var shouldNavigateToTransactions = false
    @State private var shouldNavigateToTreasury = false
    @State private var shouldNavigateToCreateDepositedGame = false
    @State private var shouldNavigateToCreateGameDescription = false
    @State private var shouldNavigateToSessionList = false
    @State private var shouldNavigateToCreateSession = false
    @State private var shouldNavigateToCatalogue = false
    
    @State private var isDropdownOpen = false

    var body: some View {
        ZStack {
            if isMenuOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isMenuOpen.toggle()
                        }
                    }
            }

            NavigationStack {
                VStack {
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    VStack(spacing: 9) {
                        // 🔹 Sessions et Catalogue
                        sectionTitle("Sessions et catalogue")
                        buttonRow([
                            ("SESSIONS", $shouldNavigateToSessionList, AnyView(SessionListView())),
                            ("CATALOGUE", $shouldNavigateToCatalogue, AnyView(CatalogueView(
                                viewModel: DepositedGameViewModel(service: DepositedGameService()),
                                sessionViewModel: SessionViewModel()
                            )))
                        ])

                        if viewModel.isAuthenticated {
                            singleButton("+ SESSION", $shouldNavigateToCreateSession, AnyView(CreateSessionView()))

                            // 🔹 Jeux et Dépôts
                            sectionTitle("Jeux et nouveaux dépôts")
                            buttonRow([
                                ("+ JEU", $shouldNavigateToCreateGameDescription, AnyView(CreateGameDescriptionView(viewModel: GameDescriptionViewModel(service: GameDescriptionService())))),
                                ("+ DÉPÔT", $shouldNavigateToCreateDepositedGame, AnyView(CreateDepositedGameView()))
                            ])
                            singleButton("JEUX DÉPOSÉS", $shouldNavigateToDepositedGames, AnyView(DepositedGameView()))

                            // 🔹 Encaissements et Transactions
                            sectionTitle("Encaissements et comptabilité")
                            buttonRow([
                                ("ENCAISSEMENT", $shouldNavigateToCart, AnyView(CartView())),
                                ("TRANSACTIONS", $shouldNavigateToTransactions, AnyView(TransactionListView()))
                            ])
                            singleButton("TRÉSORERIE", $shouldNavigateToTreasury, AnyView(TreasuryView()))

                            // 🔹 Gestion des Participants
                            sectionTitle("Gestion des humains")
                            buttonRow([
                                ("VENDEURS", $shouldNavigateToSellerList, AnyView(SellerListView())),
                                ("CLIENTS", $shouldNavigateToClientList, AnyView(ClientListView()))
                            ])
                            singleButton("GESTIONNAIRES", $shouldNavigateToManagerList, AnyView(ManagerListView()))

                            Button(action: {
                                viewModel.logout()
                            }) {
                                Text("Déconnexion ?")
                                    .font(.custom("Poppins-SemiBold", size: 20))
                                    .foregroundColor(.black)
                                    .underline()
                                    .padding(.top, 30)
                            }
                        } else {
                            NavigationLink(destination: LoginView()
                                .navigationBarBackButtonHidden(true)
                                .environmentObject(viewModel)) {
                                Text("Connexion ?")
                                    .font(.custom("Poppins-SemiBold", size: 20))
                                    .foregroundColor(.black)
                                    .underline()
                                    .padding(.top, 30)
                            }
                        }
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 1)
                    .background(Color(red: 1, green: 0.965, blue: 0.922))
                    .border(Color.black, width: 1)
                    .offset(y: isMenuOpen ? 0 : UIScreen.main.bounds.height)
                    .animation(.easeInOut(duration: 0.4), value: isMenuOpen)
                }
                .navigationBarBackButtonHidden(true)
            } // ✅ Fin de NavigationStack
        }
        .overlay(
            ZStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            isMenuOpen.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                            .padding(.top, 80)
                    }

                    Spacer()

                    Image("logoFLEUR")
                        .resizable()
                        .frame(width: 40, height: 30)
                        .padding(.trailing, 20)
                        .padding(.top, 80)
                }

                NavigationLink(destination: HomeView().environmentObject(viewModel),
                               isActive: $shouldNavigateToHome) {
                    EmptyView()
                }

                Button(action: {
                    shouldNavigateToHome = true
                }) {
                    Image("logoAHOUI")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .padding(.top, 80)
                }
            }
            .frame(height: 125)
            .background(Color(red: 1, green: 0.965, blue: 0.922))
            .border(Color.black, width: 1)
            .ignoresSafeArea(edges: .top),
            alignment: .top
        )
    }
    
    /// ✅ Fonction pour créer un titre de section
    func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.custom("Poppins-Light", size: 18))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 15)
    }

    /// ✅ Fonction pour créer une ligne de deux boutons côte à côte
    func buttonRow(_ buttons: [(String, Binding<Bool>, AnyView)]) -> some View {
        HStack(spacing: 15) {
            ForEach(buttons, id: \.0) { (title, isActive, destination) in
                NavigationLink(destination: destination.environmentObject(viewModel), isActive: isActive) {
                    menuButton(title)
                }
            }
        }
    }

    /// ✅ Fonction pour créer un bouton unique centré
    func singleButton(_ title: String, _ isActive: Binding<Bool>, _ destination: AnyView) -> some View {
        NavigationLink(destination: destination.environmentObject(viewModel), isActive: isActive) {
            menuButton(title)
        }
    }

    /// ✅ Fonction pour styliser les boutons
    func menuButton(_ title: String) -> some View {
        Text(title)
            .font(.custom("Poppins", size: 17))
            .fontWeight(.bold)
            .foregroundColor(.black)
            .frame(width: 150, height: 50)
            .background(Color.white.opacity(0.5))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
    }

    /// ✅ Fonction pour le style des boutons
    func navButtonTitle(_ title: String) -> some View {
        Text(title)
            .font(.custom("Poppins-Medium", size: 17))
            .fontWeight(.bold)
            .foregroundColor(.black)
            .frame(width: 200)
            .padding()
            .background(Color(red: 1, green: 0.98, blue: 0.95))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 1))
    }
    
    /// ✅ Function to style dropdown options
    func dropdownButtonTitle(_ title: String) -> some View {
        Text(title)
            .font(.custom("Poppins-Medium", size: 15))
            .foregroundColor(.black)
            .frame(width: 180)
            .padding(8)
            .background(Color(red: 1, green: 0.98, blue: 0.95))
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 1))
    }
}

#Preview {
    NavBarView(isMenuOpen: .constant(true))
        .environmentObject(AuthViewModel())
}
