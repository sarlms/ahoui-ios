import SwiftUI

struct ListeManagersView: View {
    @StateObject private var viewModel = ManagerViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Chargement des managers...")
                } else if !viewModel.managers.isEmpty {
                    List(viewModel.managers) { manager in
                        VStack(alignment: .leading) {
                            Text("(manager.firstName) (manager.lastName)")
                                .font(.headline)
                            Text("📧 (manager.email)")
                            Text("📞 (manager.phone)")
                            Text("📍 (manager.address)")
                            Text(manager.admin ? "👑 Admin: Oui" : "👤 Admin: Non")
                        }
                        .padding()
                    }
                } else {
                    Text("Aucun manager disponible")
                        .foregroundColor(.gray)
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Liste des Managers")
            .toolbar {
                Button("🔄 Actualiser") {
                    Task {
                        await viewModel.fetchManagers()
                    }
                }
            }
        }
        .task {
            await viewModel.fetchManagers()
        }
    }
}
