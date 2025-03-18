import SwiftUI

struct SellerDetailView: View {
    @EnvironmentObject var viewModel: SellerViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode // ✅ Used to go back after delete
    let sellerId: String

    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var amountOwed = ""

    @StateObject private var depositedGameViewModel = DepositedGameViewModel(service: DepositedGameService())
    @StateObject private var transactionViewModel = TransactionViewModel(service: TransactionService())
    @StateObject private var refundViewModel = RefundViewModel(service: RefundService())


    @State private var selectedOption = "Jeux déposés"
    let options = ["Jeux déposés", "Transactions", "Remboursements"]

    var amountOwedDouble: Double {
        Double(amountOwed) ?? 0.0
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack {
                Text("Détails du vendeur")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(.black)

                if let seller = viewModel.selectedSeller {
                    VStack {
                        InputField(title: "Nom", text: $name, placeholder: "")
                        InputField(title: "Email", text: $email, placeholder: "")
                        InputField(title: "Numéro de téléphone", text: $phone, placeholder: "")
                        InputField(title: "Montant dû (€)", text: $amountOwed, placeholder: "0")

                        HStack {
                            Button(action: updateSellerDetails) {
                                Text("Enregistrer")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 100)
                                    .background(Color.blue)
                                    .cornerRadius(15)
                            }

                            Button(action: deleteSeller) {
                                Text("Supprimer")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 100)
                                    .background(Color.red)
                                    .cornerRadius(15)
                            }

                            Button(action: refundSeller) {
                                Text("Rembourser")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(seller.amountOwed > 0 ? Color.green : Color.gray)
                                    .cornerRadius(10)
                            }
                            .disabled(seller.amountOwed == 0)
                        }
                    }
                    .padding()
                    .frame(width: 300, height: 317)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))

                    // 🔹 Dropdown menu
                    Picker("Sélectionner", selection: $selectedOption) {
                        ForEach(options, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .frame(width: 200)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .onChange(of: selectedOption) { newValue in
                        if newValue == "Jeux déposés" {
                            depositedGameViewModel.fetchDepositedGamesBySeller(sellerId: sellerId)
                        } else if newValue == "Transactions" {
                            transactionViewModel.fetchTransactionsBySeller(sellerId: sellerId)
                        } else if newValue == "Remboursements" {
                            refundViewModel.fetchRefundsBySeller(sellerId: sellerId)
                        }
                    }


                    // 🔹 Display Deposited Games when "Jeux déposés" is selected
                    if selectedOption == "Jeux déposés" {
                        if depositedGameViewModel.isLoading {
                            ProgressView("Chargement des jeux déposés...")
                        } else if let errorMessage = depositedGameViewModel.errorMessage {
                            Text("Erreur: \(errorMessage)").foregroundColor(.red)
                        } else if depositedGameViewModel.depositedGames.isEmpty {
                            Text("Aucun jeu déposé trouvé pour ce vendeur.")
                                .foregroundColor(.gray)
                        } else {
                            ScrollView {
                                VStack(spacing: 15) {
                                    ForEach(depositedGameViewModel.depositedGames) { game in
                                        DepositedGameView(game: game) // ✅ Display deposited games
                                    }
                                }
                                .padding(.top, 10)
                            }
                        }
                    }
                    if selectedOption == "Transactions" {
                        if transactionViewModel.isLoading {
                            ProgressView("Chargement des transactions...")
                        } else if let errorMessage = transactionViewModel.errorMessage {
                            Text("Erreur: \(errorMessage)").foregroundColor(.red)
                        } else if transactionViewModel.transactions.isEmpty {
                            Text("Aucune transaction trouvée.").foregroundColor(.gray)
                        } else {
                            ScrollView {
                                VStack(spacing: 15) {
                                    ForEach(transactionViewModel.transactions) { transaction in
                                        TransactionView(transaction: transaction)
                                    }
                                }
                                .padding(.top, 10)
                            }
                        }
                    }
                    if selectedOption == "Remboursements" {
                        if refundViewModel.isLoading {
                            ProgressView("Chargement des remboursements...")
                        } else if let errorMessage = refundViewModel.errorMessage {
                            Text("Erreur: \(errorMessage)").foregroundColor(.red)
                        } else if refundViewModel.refunds.isEmpty {
                            Text("Aucun remboursement trouvé.").foregroundColor(.gray)
                        } else {
                            ScrollView {
                                VStack(spacing: 15) {
                                    ForEach(refundViewModel.refunds, id: \.refundDate) { refund in
                                        RefundView(refund: refund)
                                    }
                                }
                                .padding(.top, 10)
                            }
                        }
                    }


                } else {
                    ProgressView("Chargement...")
                }
            }
            .padding()
            .onAppear {
                viewModel.fetchSeller(id: sellerId)
                sessionViewModel.loadActiveSession()
                
                // Fetch deposited games, transactuin and refunds immediately when the page loads
                depositedGameViewModel.fetchDepositedGamesBySeller(sellerId: sellerId)
                transactionViewModel.fetchTransactionsBySeller(sellerId: sellerId)
            }

            .onReceive(viewModel.$selectedSeller) { seller in
                if let seller = seller {
                    name = seller.name
                    email = seller.email
                    phone = seller.phone
                    amountOwed = String(format: "%.2f", seller.amountOwed)
                }
            }
        }
    }

    func updateSellerDetails() {
        let updatedSeller = Seller(id: sellerId, name: name, email: email, phone: phone, amountOwed: amountOwedDouble)
        viewModel.updateSeller(id: sellerId, updatedSeller: updatedSeller)
        presentationMode.wrappedValue.dismiss()
    }

    func deleteSeller() {
        viewModel.deleteSeller(id: sellerId)
        presentationMode.wrappedValue.dismiss()
    }

    func refundSeller() {
        guard let activeSession = sessionViewModel.activeSession else {
            viewModel.errorMessage = "Aucune session active trouvée."
            return
        }

        guard let managerId = authViewModel.managerId else {
            viewModel.errorMessage = "Utilisateur non authentifié."
            return
        }

        viewModel.refundSeller(
            sellerId: sellerId,
            refundAmount: amountOwedDouble,
            authViewModel: authViewModel,
            sessionViewModel: sessionViewModel
        )

        presentationMode.wrappedValue.dismiss()
    }
}



struct ActionButton: View {
    var title: String
    var color: Color

    var body: some View {
        Button(action: { /* Handle action */ }) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(color)
                .padding()
                .frame(width: 90)
                .background(Color.white.opacity(0.5))
                .cornerRadius(15)
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(color, lineWidth: 1))
        }
    }
}

