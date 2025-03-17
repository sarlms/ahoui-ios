import SwiftUI

struct SellerListView: View {
    @StateObject private var viewModel = SellerViewModel()
    @State private var searchText = ""
    @State private var showNewSellerView = false // ✅ Track navigation state

    var filteredSellers: [Seller] {
        if searchText.isEmpty {
            return viewModel.sellers
        } else {
            return viewModel.sellers.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("Liste des vendeurs")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(.black)
                
                Button(action: { showNewSellerView = true }) { // ✅ Show NewSellerView
                    Text("Créer un nouveau vendeur")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 1, green: 0.424, blue: 0.553))
                        .padding()
                        .frame(width: 200)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(15)
                        .overlay(RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(red: 1, green: 0.424, blue: 0.553), lineWidth: 1))
                }
                .sheet(isPresented: $showNewSellerView) { // ✅ Open sheet for NewSellerView
                    NewSellerView()
                        .environmentObject(viewModel)
                }

                TextField("Rechercher un vendeur", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                ScrollView {
                    VStack {
                        ForEach(filteredSellers) { seller in
                            NavigationLink(destination: SellerDetailView(sellerId: seller.id)
                                .environmentObject(viewModel)) {
                                SellerCardView(seller: seller)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                viewModel.fetchSellers()
            }
        }
    }
}

struct SellerCardView: View {
    let seller: Seller

    var body: some View {
        VStack(alignment: .leading) {
            Text(seller.name)
                .font(.system(size: 14, weight: .bold))
            Text("Email : \(seller.email)")
                .font(.system(size: 12, weight: .bold))
            Text("Téléphone : \(seller.phone)")
                .font(.system(size: 12, weight: .bold))
            Text("Montant dû : \(seller.amountOwed, specifier: "%.2f")€")
                .font(.system(size: 12, weight: .bold))
        }
        .padding()
        .frame(width: 284, height: 142)
        .background(Color.white.opacity(0.5))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
    }
}

