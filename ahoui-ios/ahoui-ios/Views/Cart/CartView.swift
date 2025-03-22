import SwiftUI

struct CartView: View {
    @StateObject private var viewModel = CartViewModel()
    @StateObject private var clientViewModel = ClientViewModel(service: ClientService())
    
    @State private var gameIdInput: String = ""
    @State private var showDropdown = false
    
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @State private var isMenuOpen = false
    @State private var shouldNavigate = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 1, green: 0.965, blue: 0.922)
                    .ignoresSafeArea()
                ScrollView {
                    Color(red: 1, green: 0.965, blue: 0.922)
                        .ignoresSafeArea()
                    VStack(spacing: 20) {
                        Text("Encaisser un client")
                            .font(.custom("Poppins-Bold", size: 25))
                            .foregroundColor(.black)
                            .padding(.top, 50)
                        ClientSelectionView(clientViewModel: clientViewModel, showDropdown: $showDropdown)
                        
                        ScanGameView(gameIdInput: $gameIdInput, viewModel: viewModel)
                        
                        VStack {
                            ForEach(viewModel.cartItems) { game in
                                CartItemView(game: game, viewModel: viewModel)
                                    .padding(.horizontal, 10)
                            }
                        }
                        
                        if !viewModel.cartItems.isEmpty {
                            VStack {
                                Divider()
                                HStack {
                                    Text("Total :")
                                        .font(.custom("Poppins-Bold", size: 20))
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text("\(viewModel.totalPrice, specifier: "%.2f") €")
                                        .font(.custom("Poppins-Bold", size: 20))
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.5))
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
                            }
                            .padding(.horizontal)
                            
                            Button(action: {
                                viewModel.finalizeCheckout(clientId: clientViewModel.selectedClient?.id)
                                shouldNavigate = true
                            }) {
                                Text("VALIDER")
                                    .font(.custom("Poppins-Bold", size: 20))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 150)
                                    .cornerRadius(20)
                                    .background(Color(red: 0.05, green: 0.61, blue: 0.043))
                            }
                            .padding(.top, 10)
                        }
                    }
                    .padding()
                    .navigationDestination(isPresented: $shouldNavigate) {
                        TransactionListView()
                    }
                    .alert(item: $viewModel.errorMessage) { error in
                        Alert(title: Text("Erreur"), message: Text(error.message), dismissButton: .default(Text("OK")))
                    }
                }
                .navigationBarBackButtonHidden(true)
                .background(Color(red: 1, green: 0.965, blue: 0.922))
                .overlay(
                    NavBarView(isMenuOpen: $isMenuOpen)
                        .environmentObject(navigationViewModel)
                )
            }
        }
    }
}
