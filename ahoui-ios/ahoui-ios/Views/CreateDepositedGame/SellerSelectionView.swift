import SwiftUI

struct SellerSelectionView: View {
    @ObservedObject var sellerViewModel: SellerViewModel
    @Binding var showSellerDropdown: Bool
    @State private var showNewSellerView = false


    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                Text("Vendeur")
                    .font(.custom("Poppins-SemiBold", size: 20))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // Carte blanche semi-transparente
                VStack(alignment: .leading, spacing: 10) {
                    Group {
                        // Adresse email
                        Text("Adresse email")
                            .font(.custom("Poppins-SemiBold", size: 15))
                            .foregroundColor(.black)
                        
                        ZStack(alignment: .trailing) {
                            TextField("Tapez l’email du vendeur", text: $sellerViewModel.searchText, onEditingChanged: { isEditing in
                                showSellerDropdown = isEditing
                                if isEditing {
                                    sellerViewModel.selectedSeller = nil
                                }
                            })
                            .font(.custom("Poppins-LightItalic", size: 13))
                            .padding(.horizontal)
                            .frame(height: 35)
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            
                            Image(systemName: "chevron.down")
                                .padding(.trailing, 10)
                                .foregroundColor(.black)
                        }
                        
                        // Dropdown suggestions
                        if showSellerDropdown && !sellerViewModel.filteredEmails.isEmpty {
                            VStack(spacing: 5) {
                                ForEach(sellerViewModel.filteredEmails, id: \.self) { email in
                                    Text(email)
                                        .font(.custom("Poppins-LightItalic", size: 13))
                                        .padding(8)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.white)
                                        .cornerRadius(4)
                                        .onTapGesture {
                                            sellerViewModel.selectedEmail = email
                                            sellerViewModel.searchText = email
                                            sellerViewModel.fetchSellerByEmail(email: email)
                                            showSellerDropdown = false
                                        }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(4)
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
                        }
                    }
                    
                    // Si vendeur sélectionné
                    if let seller = sellerViewModel.selectedSeller {
                        Group {
                            Text("IdVendeur")
                                .font(.custom("Poppins-SemiBold", size: 15))
                            Text(seller.id)
                                .font(.custom("Poppins-LightItalic", size: 13))
                                .padding(.horizontal)
                                .frame(height: 35)
                                .background(Color.white.opacity(0.5))
                                .cornerRadius(4)
                                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
                            
                            Text("Nom Prénom")
                                .font(.custom("Poppins-SemiBold", size: 15))
                            Text(seller.name)
                                .font(.custom("Poppins-LightItalic", size: 13))
                                .padding(.horizontal)
                                .frame(height: 35)
                                .background(Color.white.opacity(0.5))
                                .cornerRadius(4)
                                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
                            
                            Text("Num téléphone")
                                .font(.custom("Poppins-SemiBold", size: 15))
                            Text(seller.phone)
                                .font(.custom("Poppins-LightItalic", size: 13))
                                .padding(.horizontal)
                                .frame(height: 35)
                                .background(Color.white.opacity(0.5))
                                .cornerRadius(4)
                                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
                        }
                    }
                    
                    // Lien de création de vendeur
                    Text("Créer un nouveau vendeur ?")
                        .font(.custom("Poppins-SemiBoldItalic", size: 13))
                        .underline()
                        .foregroundColor(.black)
                        .padding(.top, 5)
                        .onTapGesture {
                            showNewSellerView = true
                        }

                    
                }
                .padding()
                .frame(width: 340)
                .background(Color.white.opacity(0.5))
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showNewSellerView) {
            NewSellerView()
                .environmentObject(sellerViewModel)
        }
    }
}
