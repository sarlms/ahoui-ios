import SwiftUI

struct ManagerListView: View {
    @StateObject private var viewModel = ManagerViewModel()
    @State private var searchText = ""
    @State private var isPresentingNewManagerView = false

    var filteredManagers: [Manager] {
        if searchText.isEmpty {
            return viewModel.managers
        } else {
            return viewModel.managers.filter {
                $0.firstName.lowercased().contains(searchText.lowercased()) ||
                $0.lastName.lowercased().contains(searchText.lowercased()) ||
                $0.email.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Title
                Text("Liste des managers")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.top, 20)
                
                Spacer(minLength: 20)

                // Create Manager Button
                Button(action: {
                    isPresentingNewManagerView = true
                }) {
                    Text("Créer un nouveau manager")
                        .font(Font.custom("Poppins-Medium", size: 12))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.05, green: 0.61, blue: 0.04))
                        .padding()
                        .frame(width: 220, height: 40)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
                }
                .padding(.horizontal, 80)
                .sheet(isPresented: $isPresentingNewManagerView) {
                    NewManagerView(viewModel: viewModel) // ✅ Pass shared viewModel
                }
                
                Spacer(minLength: 20)

                // Search Bar
                HStack {
                    TextField("", text: $searchText, prompt: Text("Rechercher un manager").italic()) // Placeholder in italic
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth: 1) // Thin black border
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 4) // Bottom shadow

                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 50)

                
                Spacer(minLength: 10)

                // List of Managers
                ScrollView {
                    LazyVStack(spacing: 20) {
                        if filteredManagers.isEmpty {
                            Text("Aucun manager disponible")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(filteredManagers) { manager in
                                ManagerCard(manager: manager)
                                    .padding(.horizontal, 40)
                            }
                        }
                    }
                }
                .padding(.top, 10)

                // Error Message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .background(Color(red: 1, green: 0.965, blue: 0.922).edgesIgnoringSafeArea(.all))
            .onAppear {
                Task {
                    await viewModel.fetchManagers()
                }
            }
        }
    }
}

struct ManagerCard: View {
    let manager: Manager

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(manager.firstName) \(manager.lastName)")
                .font(.headline)
                .foregroundColor(.black)
            
            InfoRow(label: "Email", value: manager.email)
            InfoRow(label: "Téléphone", value: manager.phone)
            InfoRow(label: "Adresse", value: manager.address)
            InfoRow(label: "Admin", value: manager.admin ? "Oui" : "Non")

            HStack {
                Spacer()
                NavigationLink(destination: EditManagerView(manager: manager)) {
                    Text("Éditer")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.green)
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

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text("\(label) :")
                .font(.system(size: 12, weight: .bold))
            Text(value)
                .font(.system(size: 12))
        }
        .foregroundColor(.black)
    }
}
