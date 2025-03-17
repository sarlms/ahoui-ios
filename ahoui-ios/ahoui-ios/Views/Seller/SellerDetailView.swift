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

    var amountOwedDouble: Double {
        Double(amountOwed) ?? 0.0
    }

    var body: some View {
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
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 100)
                                .background(seller.amountOwed > 0 ? Color.green : Color.gray)
                                .cornerRadius(15)
                        }
                        .disabled(seller.amountOwed == 0)
                    }
                }
                .padding()
                .frame(width: 300, height: 317)
                .background(Color.white.opacity(0.5))
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
            } else {
                ProgressView("Chargement...")
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchSeller(id: sellerId)
            sessionViewModel.fetchActiveSession()
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

    func updateSellerDetails() {
        let updatedSeller = Seller(id: sellerId, name: name, email: email, phone: phone, amountOwed: amountOwedDouble)
        viewModel.updateSeller(id: sellerId, updatedSeller: updatedSeller)
        presentationMode.wrappedValue.dismiss() // ✅ Navigate back to SellerListView after update
    }

    func deleteSeller() {
        viewModel.deleteSeller(id: sellerId)
        presentationMode.wrappedValue.dismiss() // ✅ Navigate back after delete
    }
    
    func refundSeller() {
        guard let activeSession = sessionViewModel.activeSession else {
            viewModel.errorMessage = "Aucune session active trouvée."
            return
        }

        guard let managerId = authViewModel.managerId else { // ✅ Access managerId from authViewModel
            viewModel.errorMessage = "Utilisateur non authentifié."
            return
        }

        // ✅ Corrected method call with the right parameters
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

struct DepositedGameView: View {
    var body: some View {
        VStack {
            Text("UNO - Deluxe | 12€")
                .font(.system(size: 14, weight: .bold))
            Text("Session: Février - Clôturée")
            Text("Vendu: Non, Disponible: Non, Récupéré: Oui")
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(20)
    }
}
