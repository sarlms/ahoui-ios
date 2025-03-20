import SwiftUI

struct TransactionListView: View {
    @StateObject private var viewModel = TransactionViewModel(service: TransactionService())
    @State private var showFilters = false

    var body: some View {
        NavigationView {
            VStack {
                // 🔹 Title
                Text("Transactions")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 20)

                // 🔹 Filter Button
                Button(action: {
                    withAnimation {
                        showFilters.toggle()
                    }
                }) {
                    Text("FILTRER")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 120)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(25)
                }
                .padding(.bottom, 10)

                // 🔹 Filter Input Fields (Shown when `showFilters` is true)
                if showFilters {
                    VStack(spacing: 10) {
                        FilterTextField(title: "Transaction ID", text: $viewModel.searchTransactionId)
                        FilterTextField(title: "Nom du Client", text: $viewModel.searchClientName)
                        FilterTextField(title: "Nom du Vendeur", text: $viewModel.searchSellerName)
                        FilterTextField(title: "Nom du Jeu", text: $viewModel.searchGameName)
                        FilterTextField(title: "Nom de la Session", text: $viewModel.searchSessionName)

                        Button(action: {
                            viewModel.applyFilters()
                        }) {
                            Text("APPLIQUER FILTRES")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 200)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.black, lineWidth: 1))
                    .padding(.bottom, 10)
                }

                // 🔹 Transactions List
                ScrollView {
                    LazyVStack(spacing: 20) {
                        if viewModel.isLoading {
                            ProgressView()
                        } else if viewModel.transactionsList.isEmpty {
                            Text("Aucune transaction disponible")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(viewModel.filteredTransactions) { transaction in
                                TransactionCard(transaction: transaction)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
                .padding(.top, 10)

                // 🔹 Error Message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .background(Color(red: 1, green: 0.965, blue: 0.922).edgesIgnoringSafeArea(.all))
            .onAppear {
                Task {
                    await viewModel.fetchAllTransactions()
                }
            }
        }
    }
}

struct TransactionCard: View {
    let transaction: TransactionList

    // 🔹 Format the transaction date
    var formattedDate: String {
        let inputFormatter = ISO8601DateFormatter()
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy HH:mm"

        if let date = inputFormatter.date(from: transaction.transactionDate) {
            return outputFormatter.string(from: date)
        }
        return transaction.transactionDate
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Transaction ID
            Text("ID : \(transaction.id)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.black)

            // Date
            Text("Date : \(formattedDate)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)

            // Game Name
            Text("Jeu : \(transaction.label.gameDescription.name)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)

            // Sale Price
            Text("Prix de vente : \(String(format: "%.2f", transaction.label.salePrice))€")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)

            // Client Info
            Text("Nom client : \(transaction.client.name)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)

            Text("Email client : \(transaction.client.email)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)

            // Seller Info
            Text("Nom vendeur : \(transaction.seller.name)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)

            Text("Email vendeur : \(transaction.seller.email)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)

            // Session Name
            Text("Session : \(transaction.session.name)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)

            // Manager in Charge
            Text("Manager en charge : \(transaction.manager.firstName) \(transaction.manager.lastName)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
    }
}


// 🔹 Generic Filter Input Component
struct FilterTextField: View {
    let title: String
    @Binding var text: String

    var body: some View {
        TextField(title, text: $text)
            .padding()
            .background(Color.white.opacity(0.5))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
            .frame(width: 250)
    }
}
