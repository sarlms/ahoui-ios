import SwiftUI

struct NavBarView: View {
    @Binding var isMenuOpen: Bool
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var shouldNavigateToSellerList = false
    @State private var shouldNavigateToDepositedGames = false
    @State private var shouldNavigateToCart = false
    @State private var shouldNavigateToClientList = false
    @State private var shouldNavigateToManagerList = false
    @State private var shouldNavigateToTransactions = false
    @State private var shouldNavigateToCreateDepositedGame = false // ✅ Ajout pour + DÉPÔT
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
                    VStack(spacing: 13) {
                        menuButton(title: "SESSIONS")
                        menuButton(title: "CATALOGUE")

                        if viewModel.isAuthenticated {
                            menuButton(title: "+ SESSION")

                            Button(action: {
                                shouldNavigateToDepositedGames = true
                            }) {
                                navButtonTitle("JEUX DEPOSÉS")
                            }
                            .navigationDestination(isPresented: $shouldNavigateToDepositedGames) {
                                DepositedGameView()
                            }

                            Button(action: {
                                shouldNavigateToCreateDepositedGame = true
                            }) {
                                navButtonTitle("+ DÉPÔT")
                            }
                            .navigationDestination(isPresented: $shouldNavigateToCreateDepositedGame) {
                                CreateDepositedGameView()
                            }

                            menuButton(title: "+ JEU")

                            Button(action: {
                                shouldNavigateToCart = true
                            }) {
                                navButtonTitle("ENCAISSEMENT")
                            }
                            .navigationDestination(isPresented: $shouldNavigateToCart) {
                                CartView().environmentObject(viewModel)
                            }

                            Button(action: {
                                shouldNavigateToTransactions = true
                            }) {
                                navButtonTitle("TRANSACTIONS")
                            }
                            .navigationDestination(isPresented: $shouldNavigateToTransactions) {
                                TransactionListView()
                            }

                            menuButton(title: "TRÉSORERIE")

                            VStack(spacing: 5) {
                                Button(action: {
                                    withAnimation {
                                        isDropdownOpen.toggle()
                                    }
                                }) {
                                    HStack {
                                        Text("USER MANAGEMENT")
                                            .font(.custom("Poppins", size: 17))
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                            .frame(width: 200)
                                            .padding()
                                            .background(Color(red: 1, green: 0.98, blue: 0.95))
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.black, lineWidth: 1)
                                            )
                                        Image(systemName: isDropdownOpen ? "chevron.up" : "chevron.down")
                                            .foregroundColor(.black)
                                    }
                                }

                                if isDropdownOpen {
                                    VStack {
                                        NavigationLink(destination: SellerListView().environmentObject(viewModel)) {
                                            dropdownButtonTitle("Sellers")
                                        }

                                        NavigationLink(destination: ClientListView().environmentObject(viewModel)) {
                                            dropdownButtonTitle("Clients")
                                        }

                                        NavigationLink(destination: ManagerListView().environmentObject(viewModel)) {
                                            dropdownButtonTitle("Managers")
                                        }
                                    }
                                }
                            }

                            Button(action: {
                                viewModel.logout()
                            }) {
                                Text("Déconnexion ?")
                                    .font(.custom("Poppins-SemiBold", size: 20))
                                    .foregroundColor(.black)
                                    .underline()
                                    .padding(.top, 10)
                            }
                        } else {
                            NavigationLink(destination: LoginView().environmentObject(viewModel)) {
                                Text("Connexion ?")
                                    .font(.custom("Poppins-SemiBold", size: 20))
                                    .foregroundColor(.black)
                                    .underline()
                                    .padding(.top, 10)
                            }
                        }
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.9)
                    .background(Color(red: 1, green: 0.965, blue: 0.922))
                    .border(Color.black, width: 1)
                    .offset(y: isMenuOpen ? 0 : UIScreen.main.bounds.height)
                    .animation(.easeInOut(duration: 0.4), value: isMenuOpen)
                }
            } // ✅ Fin de NavigationStack
        }
        .overlay(
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
                        .padding(.top, 50)
                }
                
                Spacer()

                Image("logoAHOUI")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .padding(.top, 50)

                Spacer()
                
                Image("logoFLEUR")
                    .resizable()
                    .frame(width: 50, height: 40)
                    .padding(.trailing, 20)
                    .padding(.top, 40)
            }
            .frame(height: 110)
            .background(Color(red: 1, green: 0.965, blue: 0.922))
            .border(Color.black, width: 1)
            .ignoresSafeArea(edges: .top),
            alignment: .top
        )
    }
    
    /// ✅ Fonction générique pour créer un bouton de menu sans navigation
    func menuButton(title: String) -> some View {
        Button(action: {
            print("\(title) tapped")
        }) {
            navButtonTitle(title)
        }
    }

    /// ✅ Fonction pour le style des boutons
    func navButtonTitle(_ title: String) -> some View {
        Text(title)
            .font(.custom("Poppins", size: 17))
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
            .font(.custom("Poppins", size: 15))
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
