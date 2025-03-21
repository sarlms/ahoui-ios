import Foundation

class ManagerViewModel: ObservableObject {
    @Published var managers: [Manager] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service = ManagerService() // ✅ Injected service

    /// Fetch managers from the API
    func fetchManagers() async {
        DispatchQueue.main.async { self.isLoading = true }
        
        do {
            let managers = try await service.fetchManagers()
            await MainActor.run {
                self.managers = managers
                self.errorMessage = nil
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to fetch managers: \(error.localizedDescription)"
            }
        }

        DispatchQueue.main.async { self.isLoading = false }
    }

    /// Create a new manager
    func createManager(_ manager: CreateManager) async {
        do {
            try await service.createManager(manager)
            await fetchManagers() // Refresh list after creating a manager
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to create manager: \(error.localizedDescription)"
            }
        }
    }

    /// Update manager
        func updateManager(id: String, updatedManager: UpdateManager) async {
            do {
                try await service.updateManager(id: id, updatedManager: updatedManager)
                await fetchManagers() // Refresh the manager list
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to update manager: \(error.localizedDescription)"
                }
            }
        }
}
