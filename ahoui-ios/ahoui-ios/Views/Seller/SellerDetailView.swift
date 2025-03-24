import SwiftUI

struct SellerDetailView: View {
    @EnvironmentObject var viewModel: SellerViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
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
            Color(red: 1, green: 0.965, blue: 0.922)
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: 20) {
                    Text("Détails du vendeur")
                        .font(.custom("Poppins-SemiBold", size: 25))
                        .foregroundColor(.black)
                        .padding(.top, 30)

                    if let seller = viewModel.selectedSeller {
                        VStack(alignment: .leading, spacing: 15) {
                            StyledClientInputField(title: "Nom", text: $name)
                            StyledClientInputField(title: "Email", text: $email)
                            StyledClientInputField(title: "Numéro de téléphone", text: $phone)
                            StyledClientInputField(title: "Montant dû (€)", text: $amountOwed)
                        }
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
                        .frame(width: 300)

                        HStack(spacing: 15) {
                            Button(action: updateSellerDetails) {
                                Text("Enregistrer")
                                    .font(.custom("Poppins-Medium", size: 14))
                                    .foregroundColor(.black)
                                    .padding()
                                    .frame(width: 110)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
                            }

                            Button(action: deleteSeller) {
                                Text("Supprimer")
                                    .font(.custom("Poppins-Medium", size: 14))
                                    .foregroundColor(.red)
                                    .padding()
                                    .frame(width: 110)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.red, lineWidth: 1))
                            }

                            Button(action: refundSeller) {
                                Text("Rembourser")
                                    .font(.custom("Poppins-Medium", size: 14))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 110)
                                    .background(seller.amountOwed > 0 ? Color(red: 1, green: 0.65, blue: 0.75) : Color.gray)
                                    .cornerRadius(20)
                            }
                            .disabled(seller.amountOwed == 0)
                        }
                        .padding(.top, 10)

                        Picker("Sélectionner", selection: $selectedOption) {
                            ForEach(options, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .frame(width: 200)
                        .background(Color.white.opacity(0.5))
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

                        VStack(spacing: 15) {
                            if selectedOption == "Jeux déposés" {
                                if depositedGameViewModel.isLoading {
                                    ProgressView("Chargement des jeux déposés...")
                                } else if let errorMessage = depositedGameViewModel.errorMessage {
                                    Text("Erreur: \(errorMessage)").foregroundColor(.red)
                                } else if depositedGameViewModel.depositedGamesForSeller.isEmpty {
                                    Text("⚠️ Aucun jeu déposé trouvé pour ce vendeur.")
                                        .font(.custom("Poppins", size: 13))
                                        .foregroundColor(.gray)
                                } else {
                                    ForEach(depositedGameViewModel.depositedGamesForSeller, id: \.id) { game in
                                        DepositedGameSellerDetailView(game: game)
                                    }
                                }
                            }

                            if selectedOption == "Transactions" {
                                if transactionViewModel.isLoading {
                                    ProgressView("Chargement des transactions...")
                                } else if let errorMessage = transactionViewModel.errorMessage {
                                    Text("Erreur: \(errorMessage)").foregroundColor(.red)
                                } else if transactionViewModel.transactions.isEmpty {
                                    Text("Aucune transaction trouvée.")
                                        .font(.custom("Poppins", size: 13))
                                        .foregroundColor(.gray)
                                } else {
                                    ForEach(transactionViewModel.transactions) { transaction in
                                        TransactionView(transaction: transaction)
                                    }
                                }
                            }

                            if selectedOption == "Remboursements" {
                                if refundViewModel.isLoading {
                                    ProgressView("Chargement des remboursements...")
                                } else if let errorMessage = refundViewModel.errorMessage {
                                    Text("Erreur: \(errorMessage)").foregroundColor(.red)
                                } else if refundViewModel.refunds.isEmpty {
                                    Text("Aucun remboursement trouvé.")
                                        .font(.custom("Poppins", size: 13))
                                        .foregroundColor(.gray)
                                } else {
                                    ForEach(refundViewModel.refunds, id: \.refundDate) { refund in
                                        RefundView(refund: refund)
                                    }
                                }
                            }
                        }
                        .padding(.top, 10)

                    } else {
                        ProgressView("Chargement...")
                    }
                }
                .padding(.bottom, 30)
            }
            .onAppear {
                viewModel.fetchSeller(id: sellerId)
                sessionViewModel.loadActiveSession()
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
