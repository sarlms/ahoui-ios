import Foundation

class ManagerViewModel: ObservableObject {
    @Published var managers: [Manager] = [] // to store the fetched managers
    @Published var isLoading: Bool = false // indicates if the data is being fetched
    @Published var errorMessage: String? // stores error messages to display in the UI

    private let service = ManagerService() // Injected service

    /// Fetch all managers
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

    /// Create a manager
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

    /// Update a manager by id
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
    
    /// Delete a manager by id
    func deleteManager(id: String) async {
        do {
            try await service.deleteManager(id: id)
            await fetchManagers() // Refresh the manager list after deletion
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to delete manager: \(error.localizedDescription)"
            }
        }
    }
}
