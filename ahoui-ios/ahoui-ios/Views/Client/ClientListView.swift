import SwiftUI

struct ClientListView: View {
    @StateObject private var viewModel = ClientViewModel(service: ClientService())
    @State private var searchText = ""
    @State private var showNewClientView = false
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @State private var isMenuOpen = false

    var filteredClients: [Client] {
        if searchText.isEmpty {
            return viewModel.clients
        } else {
            return viewModel.clients.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 1, green: 0.965, blue: 0.922)
                    .ignoresSafeArea()

                VStack {
                    Text("Liste des clients")
                        .font(.custom("Poppins-SemiBold", size: 25))
                        .foregroundColor(.black)
                        .padding(.top, 160)

                    Spacer(minLength: 20)

                    Button(action: { showNewClientView = true }) {
                        Text("Créer un nouveau client")
                            .font(.custom("Poppins-Medium", size: 13))
                            .foregroundColor(Color(red: 0.05, green: 0.61, blue: 0.04))
                            .padding()
                            .frame(width: 220, height: 40)
                            .background(Color(red: 1, green: 0.985, blue: 0.962))
                            .cornerRadius(20)
                            .overlay(RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(red: 0.05, green: 0.61, blue: 0.04), lineWidth: 1))
                    }
                    .padding(.horizontal, 80)
                    .sheet(isPresented: $showNewClientView) {
                        NewClientView()
                            .environmentObject(viewModel)
                    }

                    Spacer(minLength: 20)

                    HStack {
                        TextField("", text: $searchText, prompt: Text("Rechercher un client").italic().font(.custom("Poppins-Italic", size: 12)))
                            .padding(8)
                            .background(Color(red: 1, green: 0.985, blue: 0.962))
                            .cornerRadius(15)
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.black, lineWidth: 1))
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 4)

                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 50)

                    Spacer(minLength: 10)

                    ScrollView {
                        LazyVStack(spacing: 20) {
                            if filteredClients.isEmpty {
                                Text("Aucun client disponible")
                                    .font(.custom("Poppins", size: 13))
                                    .foregroundColor(.gray)
                            } else {
                                ForEach(filteredClients) { client in
                                    ClientCardView(client: client)
                                        .padding(.horizontal, 40)
                                }
                            }
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 24)

                NavBarView(isMenuOpen: $isMenuOpen)
                    .environmentObject(navigationViewModel)
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                viewModel.fetchClients()
            }
        }
    }
}


struct ClientCardView: View {
    let client: Client

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(client.name)
                .font(.custom("Poppins-SemiBold", size: 15))
                .foregroundColor(.black)

            InfoRow(label: "Email", value: client.email)
            InfoRow(label: "Téléphone", value: client.phone)
            InfoRow(label: "Adresse", value: client.address)

            HStack {
                Spacer()
                NavigationLink(destination: ClientDetailView(client: client)) {
                    Text("Éditer")
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(.green)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.green, lineWidth: 1))
                }
            }
            .padding(.top, 5)
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
    }
}

