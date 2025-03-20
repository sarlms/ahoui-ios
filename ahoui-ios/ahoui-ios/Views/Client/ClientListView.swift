import SwiftUI

struct ClientListView: View {
    @StateObject private var viewModel = ClientViewModel(service: ClientService())
    @State private var searchText = ""
    @State private var showNewClientView = false

    var filteredClients: [Client] {
        if searchText.isEmpty {
            return viewModel.clients
        } else {
            return viewModel.clients.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("Liste des clients")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(.black)
                
                Button(action: { showNewClientView = true }) {
                    Text("Créer un nouveau client")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.green)
                        .padding()
                        .frame(width: 220)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(15)
                        .overlay(RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.green, lineWidth: 1))
                }
                .sheet(isPresented: $showNewClientView) {
                    NewClientView()
                        .environmentObject(viewModel)
                }

                TextField("Rechercher un client", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .overlay(
                        HStack {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.trailing, 10)
                        }
                    )
                    .padding(.horizontal)

                ScrollView {
                    VStack {
                        ForEach(filteredClients) { client in
                            NavigationLink(destination: ClientDetailView(client: client)) {
                                ClientCardView(client: client)
                            }
                            .buttonStyle(PlainButtonStyle()) // Removes link styling
                        }
                    }
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
            .onAppear {
                viewModel.fetchClients()
            }
        }
    }
}


struct ClientCardView: View {
    let client: Client

    var body: some View {
        VStack(alignment: .leading) {
            Text(client.name)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
            
            Text("Email : \(client.email)")
                .font(.system(size: 14))
                .foregroundColor(.black)

            Text("Téléphone : \(client.phone)")
                .font(.system(size: 14))
                .foregroundColor(.black)

            Text("Adresse : \(client.address)")
                .font(.system(size: 14))
                .foregroundColor(.black)
        }
        .padding()
        .frame(width: 300, height: 140)
        .background(Color.white.opacity(0.9))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
    }
}
