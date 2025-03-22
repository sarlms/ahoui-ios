import SwiftUI

struct ClientSelectionView: View {
    @ObservedObject var clientViewModel: ClientViewModel
    @Binding var showDropdown: Bool

    var body: some View {
        VStack(spacing: 5) {
            Text("Client")
                .font(.custom("Poppins-SemiBold", size: 20))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)

            VStack(alignment: .leading, spacing: 10) {
                Text("Adresse email")
                    .font(.custom("Poppins-SemiBold", size: 15))
                    .foregroundColor(.black)

                ZStack(alignment: .trailing) {
                    TextField("Tapez l'email du client", text: $clientViewModel.searchText, onEditingChanged: { isEditing in
                        showDropdown = isEditing
                        if isEditing {
                            clientViewModel.selectedClient = nil
                        }
                    })
                    .font(.custom("Poppins-LightItalic", size: 13))
                    .padding(.horizontal)
                    .frame(height: 35)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(4)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))

                    Image(systemName: "chevron.down")
                        .padding(.trailing, 10)
                        .foregroundColor(.black)
                }

                if showDropdown && !clientViewModel.filteredEmails.isEmpty {
                    ScrollView {
                        VStack(spacing: 5) {
                            ForEach(clientViewModel.filteredEmails, id: \.self) { email in
                                Text(email)
                                    .font(.custom("Poppins-LightItalic", size: 13))
                                    .padding(8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .cornerRadius(4)
                                    .onTapGesture {
                                        clientViewModel.selectedEmail = email
                                        clientViewModel.searchText = email
                                        clientViewModel.fetchClientByEmail(email: email)
                                        showDropdown = false
                                    }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
                    }
                }

                if let client = clientViewModel.selectedClient {
                    Group {
                        Text("IdClient")
                            .font(.custom("Poppins-SemiBold", size: 15))
                        Text(client.id)
                            .font(.custom("Poppins-LightItalic", size: 13))
                            .padding(.horizontal)
                            .frame(height: 35)
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(4)
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))

                        Text("Nom Prenom")
                            .font(.custom("Poppins-SemiBold", size: 15))
                        Text(client.name)
                            .font(.custom("Poppins-LightItalic", size: 13))
                            .padding(.horizontal)
                            .frame(height: 35)
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(4)
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))

                        Text("Num téléphone")
                            .font(.custom("Poppins-SemiBold", size: 15))
                        Text(client.phone)
                            .font(.custom("Poppins-LightItalic", size: 13))
                            .padding(.horizontal)
                            .frame(height: 35)
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(4)
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
                    }
                }

                Text("Créer un nouveau client ?")
                    .font(.custom("Poppins-SemiBoldItalic", size: 13))
                    .underline()
                    .foregroundColor(.black)
                    .padding(.top, 5)
                    .onTapGesture {
                        print("Action de création d’un nouveau client")
                    }
            }
            .padding()
            .frame(width: 340)
            .background(Color.white.opacity(0.5))
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
        }
        .onAppear {
            clientViewModel.fetchClients()
            clientViewModel.fetchUniqueClientEmails()
        }
    }
}
