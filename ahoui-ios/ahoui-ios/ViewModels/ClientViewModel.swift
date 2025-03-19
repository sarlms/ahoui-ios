import Foundation

class ClientViewModel: ObservableObject {
    @Published var clients: [Client] = []
    @Published var selectedClient: Client?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: ClientService

    init(service: ClientService) {
        self.service = service
    }

    /// 🔹 Fetch all clients
    func fetchClients() {
        isLoading = true
        errorMessage = nil

        service.fetchClients { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let clients):
                    print("✅ Successfully fetched \(clients.count) clients")
                    self?.clients = clients
                case .failure(let error):
                    print("❌ Error fetching clients: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    /// 🔹 Fetch a single client by ID
    func fetchClientById(clientId: String) {
        isLoading = true
        errorMessage = nil

        service.fetchClientById(clientId: clientId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let client):
                    self?.selectedClient = client
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func createClient(client: Client) {
        service.createClient(client: client) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newClient):
                    self?.clients.append(newClient)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

}
