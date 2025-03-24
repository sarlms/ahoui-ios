import SwiftUI

struct SellerListView: View {
    @StateObject private var viewModel = SellerViewModel()
    @State private var searchText = ""
    @State private var showNewSellerView = false
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @State private var isMenuOpen = false

    var filteredSellers: [Seller] {
        if searchText.isEmpty {
            return viewModel.sellers
        } else {
            return viewModel.sellers.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 1, green: 0.965, blue: 0.922)
                    .ignoresSafeArea()

                VStack {
                    Text("Liste des vendeurs")
                        .font(.custom("Poppins-SemiBold", size: 25))
                        .foregroundColor(.black)
                        .padding(.top, 160)

                    Spacer(minLength: 20)

                    Button(action: { showNewSellerView = true }) {
                        Text("Créer un nouveau vendeur")
                            .font(.custom("Poppins-Medium", size: 13))
                            .foregroundColor(Color(red: 1, green: 0.424, blue: 0.553))
                            .padding()
                            .frame(width: 220, height: 40)
                            .background(Color(red: 1, green: 0.985, blue: 0.962))
                            .cornerRadius(20)
                            .overlay(RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(red: 1, green: 0.424, blue: 0.553), lineWidth: 1))
                    }
                    .padding(.horizontal, 80)
                    .sheet(isPresented: $showNewSellerView) {
                        NewSellerView()
                            .environmentObject(viewModel)
                    }

                    Spacer(minLength: 20)

                    HStack {
                        TextField("", text: $searchText, prompt: Text("Rechercher un vendeur").italic().font(.custom("Poppins-Italic", size: 12)))
                            .padding(8)
                            .background(Color(red: 1, green: 0.985, blue: 0.962))
                            .cornerRadius(15)
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.black, lineWidth: 1))
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 4)

                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 50)

                    Spacer(minLength: 10)

                    ScrollView {
                        LazyVStack(spacing: 20) {
                            if filteredSellers.isEmpty {
                                Text("Aucun vendeur disponible")
                                    .font(.custom("Poppins", size: 13))
                                    .foregroundColor(.gray)
                            } else {
                                ForEach(filteredSellers) { seller in
                                    SellerCardView(seller: seller)
                                        .padding(.horizontal, 40)
                                }
                            }
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
                viewModel.fetchSellers()
            }
        }
    }
}


struct SellerCardView: View {
    let seller: Seller

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(seller.name)
                .font(.custom("Poppins-SemiBold", size: 15))
                .foregroundColor(.black)

            InfoRow(label: "Email", value: seller.email)
            InfoRow(label: "Téléphone", value: seller.phone)
            InfoRow(label: "Montant dû", value: String(format: "%.2f €", seller.amountOwed))

            HStack {
                Spacer()
                NavigationLink(destination: SellerDetailView(sellerId: seller.id)) {
                    Text("Éditer")
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(Color(red: 1, green: 0.424, blue: 0.553))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color(red: 1, green: 0.424, blue: 0.553), lineWidth: 1))
                }
            }
            .padding(.top, 5)
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
    }
}


