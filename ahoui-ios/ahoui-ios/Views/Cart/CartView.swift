import SwiftUI

struct CartView: View {
    @StateObject private var viewModel = CartViewModel()
    @StateObject private var clientViewModel = ClientViewModel(service: ClientService())

    @State private var gameIdInput: String = ""
    @State private var showDropdown = false

    var body: some View {
        ScrollView { // 🟢 Toute la page est scrollable
            VStack(spacing: 20) {
                // 📌 Sélection du client
                VStack {
                    Text("Sélectionner un client")
                        .font(.title2)
                        .fontWeight(.semibold)

                    TextField("Rechercher un email", text: $clientViewModel.searchText, onEditingChanged: { isEditing in
                        showDropdown = isEditing
                        if isEditing {
                            clientViewModel.selectedClient = nil
                        }
                    })
                    .padding()
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                    .frame(width: 250)

                    if showDropdown && !clientViewModel.filteredEmails.isEmpty {
                        ScrollView {
                            VStack(spacing: 5) {
                                ForEach(clientViewModel.filteredEmails, id: \.self) { email in
                                    Text(email)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white)
                                        .cornerRadius(5)
                                        .onTapGesture {
                                            clientViewModel.selectedEmail = email
                                            clientViewModel.searchText = email
                                            clientViewModel.fetchClientByEmail(email: email)
                                            showDropdown = false
                                        }
                                }
                            }
                            .frame(width: 250)
                        }
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                    }

                    if let client = clientViewModel.selectedClient {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("ID: \(client.id)").font(.subheadline).fontWeight(.bold)
                            Text("Nom: \(client.name)").font(.subheadline)
                            Text("Téléphone: \(client.phone)").font(.subheadline)
                        }
                        .padding()
                        .frame(width: 250)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                    }

                    Text("Créer un nouveau client ?")
                        .font(.headline)
                        .underline()
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .onTapGesture {
                            print("Créer un nouveau client - Action à implémenter")
                        }
                        .padding(.top, 5)
                }
                .onAppear {
                    clientViewModel.fetchClients()
                    clientViewModel.fetchUniqueClientEmails()
                }

                // 📌 Scanner un article
                VStack {
                    Text("Scanner un article")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 10)

                    TextField("ID du jeu (étiquette)", text: $gameIdInput)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
                        .frame(width: 235)
                        .padding(.bottom, 5)

                    Button(action: {
                        viewModel.addGameToCart(byId: gameIdInput)
                        gameIdInput = ""
                    }) {
                        Text("AJOUTER")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 150)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 10)
                }
                .frame(width: 284, height: 156)
                .background(Color.white.opacity(0.5))
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))

                // 📌 Affichage du panier
                Text("Panier")
                    .font(.title2)
                    .fontWeight(.semibold)

                VStack {
                    ForEach(viewModel.cartItems) { game in
                        CartItemView(game: game, viewModel: viewModel)
                            .padding(.horizontal, 10)
                    }
                }

                // 📌 Affichage du total
                if !viewModel.cartItems.isEmpty {
                    VStack {
                        Divider()
                        HStack {
                            Text("Total :")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(viewModel.totalPrice, specifier: "%.2f") €")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    // 📌 Bouton "VALIDER"
                    Button(action: {
                        viewModel.finalizeCheckout(clientId: clientViewModel.selectedClient?.id)
                    }) {
                        Text("VALIDER")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.top, 10)
                }
            }
            .padding()
        }
        .alert(item: $viewModel.errorMessage) { error in
            Alert(title: Text("Erreur"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
        .navigationTitle("Panier")
    }
}

struct CartItemView: View {
    let game: DepositedGame
    @ObservedObject var viewModel: CartViewModel

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: game.gameDescription.photoURL)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(game.gameDescription.name).font(.headline)
                Text("Éditeur: \(game.gameDescription.publisher)").font(.subheadline).foregroundColor(.gray)
                Text("\(game.salePrice, specifier: "%.2f") €").font(.headline).foregroundColor(.green)
            }

            Spacer()

            Button(action: {
                viewModel.removeFromCart(game: game)
            }) {
                Image(systemName: "trash").foregroundColor(.red)
            }
        }
        .padding()
    }
}
