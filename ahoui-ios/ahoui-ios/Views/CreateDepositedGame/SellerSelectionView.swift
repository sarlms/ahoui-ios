import SwiftUI

struct SellerSelectionView: View {
    @ObservedObject var sellerViewModel: SellerViewModel
    @Binding var showSellerDropdown: Bool

    var body: some View {
        VStack {
            Text("Sélectionner un vendeur")
                .font(.title2)
                .fontWeight(.semibold)

            TextField("Rechercher un email", text: $sellerViewModel.searchText, onEditingChanged: { isEditing in
                showSellerDropdown = isEditing
                if isEditing {
                    sellerViewModel.selectedSeller = nil
                }
            })
            .padding()
            .background(Color.white.opacity(0.5))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
            .frame(width: 250)

            if showSellerDropdown && !sellerViewModel.filteredEmails.isEmpty {
                ScrollView {
                    VStack(spacing: 5) {
                        ForEach(sellerViewModel.filteredEmails, id: \.self) { email in
                            Text(email)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(5)
                                .onTapGesture {
                                    sellerViewModel.selectedEmail = email
                                    sellerViewModel.searchText = email
                                    sellerViewModel.fetchSellerByEmail(email: email)
                                    showSellerDropdown = false
                                }
                        }
                    }
                    .frame(width: 250)
                }
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
            }

            if let seller = sellerViewModel.selectedSeller {
                VStack(alignment: .leading, spacing: 5) {
                    Text("ID: \(seller.id)").font(.subheadline).fontWeight(.bold)
                    Text("Nom: \(seller.name)").font(.subheadline)
                    Text("Téléphone: \(seller.phone)").font(.subheadline)
                }
                .padding()
                .frame(width: 250)
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
            }

            Text("Créer un nouveau Vendeur ?")
                .font(.headline)
                .underline()
                .fontWeight(.bold)
                .foregroundColor(.black)
                .onTapGesture {
                    print("Créer un nouveau vendeur - Action à implémenter")
                }
                .padding(.top, 5)
        }
    }
}
