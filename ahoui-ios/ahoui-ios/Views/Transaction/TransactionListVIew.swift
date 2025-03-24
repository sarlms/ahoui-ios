import SwiftUI

struct TransactionListView: View {
    @StateObject private var viewModel = TransactionViewModel(service: TransactionService())
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @State private var showFilters = false
    @State private var isMenuOpen = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Spacer().frame(height: 80)

                    Text("Transactions")
                        .font(.custom("Poppins-SemiBold", size: 25))
                        .foregroundColor(.black)

                    Button(action: {
                        withAnimation {
                            showFilters.toggle()
                        }
                    }) {
                        HStack(spacing: 6) {
                            Text("FILTRER")
                                .font(.custom("Poppins-Bold", size: 15))

                            Image(systemName: showFilters ? "chevron.up" : "chevron.down")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(width: 120, height: 33)
                        .background(Color.black)
                        .cornerRadius(15)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.black, lineWidth: 1))
                    }

                    // 🔹 Filtres
                    if showFilters {
                        VStack(alignment: .leading, spacing: 10) {
                            CustomFilterField(title: "Nom de la session", text: $viewModel.searchSessionName)
                            CustomFilterField(title: "ID transaction", text: $viewModel.searchTransactionId)
                            CustomFilterField(title: "Nom du client", text: $viewModel.searchClientEmail)
                            CustomFilterField(title: "Nom du vendeur", text: $viewModel.searchSellerEmail)
                            CustomFilterField(title: "Nom du jeu", text: $viewModel.searchGameName)

                            HStack(spacing: 10) {
                                Spacer()
                                Button(action: {
                                    viewModel.applyFilters()
                                }) {
                                    Text("Appliquer")
                                        .font(.custom("Poppins-Bold", size: 14))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 8)
                                        .background(Color.black)
                                        .cornerRadius(15)
                                }

                                Button(action: {
                                    viewModel.resetFilters()
                                }) {
                                    Text("Réinitialiser")
                                        .font(.custom("Poppins-Bold", size: 14))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 8)
                                        .background(Color.gray)
                                        .cornerRadius(15)
                                }
                                Spacer()
                            }
                            .padding(.top, 5)
                        }
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
                        .padding(.horizontal, 25)
                    }

                    // 🔹 Liste des transactions
                    LazyVStack(alignment: .center, spacing: 20) {
                        if viewModel.isLoading {
                            ProgressView()
                        } else if viewModel.transactionsList.isEmpty {
                            Text("Aucune transaction disponible")
                                .foregroundColor(.gray)
                                .font(.custom("Poppins-SemiBold", size: 14))
                        } else {
                            ForEach(viewModel.filteredTransactions) { transaction in
                                TransactionCard(transaction: transaction)
                                    .padding(.horizontal, 25)
                                    .frame(width: 350)
                            }
                        }
                    }

                    // 🔹 Message d’erreur
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.custom("Poppins-SemiBold", size: 14))
                            .padding()
                    }
                }
                .padding(.bottom, 80)
            }
            .background(Color(red: 1, green: 0.965, blue: 0.922))
            .onAppear {
                Task {
                    await viewModel.fetchAllTransactions()
                }
            }
            .navigationBarBackButtonHidden(true)
            .overlay(
                NavBarView(isMenuOpen: $isMenuOpen)
                    .environmentObject(navigationViewModel)
            )
        }
    }
}


struct TransactionCard: View {
    let transaction: TransactionList

    var formattedDate: String {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // gère les fractions de secondes
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "fr_FR")
        outputFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        if let date = inputFormatter.date(from: transaction.transactionDate) {
            return outputFormatter.string(from: date)
        }
        return transaction.transactionDate
    }


    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Text("ID :")
                    .font(.custom("Poppins-Bold", size: 17))
                Text(transaction.id)
                    .font(.custom("Poppins-Bold", size: 17))
            }

            HStack {
                Text("Date :")
                    .font(.custom("Poppins-SemiBold", size: 13))
                Text(formattedDate)
                    .font(.custom("Poppins-Light", size: 13))
            }

            HStack {
                Text("Jeu :")
                    .font(.custom("Poppins-SemiBold", size: 13))
                Text(transaction.label.gameDescription.name)
                    .font(.custom("Poppins-Light", size: 13))
            }

            HStack {
                Text("Prix de vente :")
                    .font(.custom("Poppins-SemiBold", size: 13))
                Text("\(String(format: "%.2f", transaction.label.salePrice))€")
                    .font(.custom("Poppins-Light", size: 13))
            }

            HStack {
                Text("Nom client :")
                    .font(.custom("Poppins-SemiBold", size: 13))
                Text(transaction.client.name)
                    .font(.custom("Poppins-Light", size: 13))
            }

            HStack {
                Text("Email client :")
                    .font(.custom("Poppins-SemiBold", size: 13))
                Text(transaction.client.email)
                    .font(.custom("Poppins-Light", size: 13))
            }

            HStack {
                Text("Nom vendeur :")
                    .font(.custom("Poppins-SemiBold", size: 13))
                Text(transaction.seller.name)
                    .font(.custom("Poppins-Light", size: 13))
            }

            HStack {
                Text("Email vendeur :")
                    .font(.custom("Poppins-SemiBold", size: 13))
                Text(transaction.seller.email)
                    .font(.custom("Poppins-Light", size: 13))
            }

            HStack {
                Text("Session :")
                    .font(.custom("Poppins-SemiBold", size: 13))
                Text(transaction.session.name)
                    .font(.custom("Poppins-Light", size: 13))
            }

            HStack {
                Text("Manager en charge :")
                    .font(.custom("Poppins-SemiBold", size: 13))
                Text("\(transaction.manager.firstName) \(transaction.manager.lastName)")
                    .font(.custom("Poppins-Light", size: 13))
            }
        }
        .foregroundColor(.black)
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
        .frame(minWidth: 340, maxWidth: 340)
    }
}




struct CustomFilterField: View {
    let title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.custom("Poppins-SemiBold", size: 14))
                .foregroundColor(.black)

            TextField("Tapez \(title.lowercased())", text: $text)
                .padding(.horizontal)
                .frame(height: 35)
                .background(Color.white.opacity(0.5))
                .cornerRadius(5)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 1))
                .font(.custom("Poppins-LightItalic", size: 14))
        }
    }
}

