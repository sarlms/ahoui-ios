import Foundation

class ClientViewModel: ObservableObject {
    @Published var clients: [Client] = [] // store fetched clients
    @Published var selectedClient: Client? // store the selected client for page navigation
    @Published var isLoading = false
    @Published var errorMessage: String?

    
    // used for email text filtering
    @Published var uniqueClientEmails: [String] = []
    @Published var selectedEmail: String?
    @Published var searchText: String = "" {
        didSet {
            if searchText.isEmpty {
                selectedClient = nil // delete the selected client if input is empty
            }
        }
    }
    // for email text filtering
    var filteredEmails: [String] {
        if searchText.isEmpty {
            return uniqueClientEmails
        } else {
            return uniqueClientEmails.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    

    private let service: ClientService

    init(service: ClientService) {
        self.service = service
    }

    /// Fetch all clients
    func fetchClients() {
        isLoading = true
        errorMessage = nil

        service.fetchClients { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let clients):
                    print("Successfully fetched \(clients.count) clients")
                    self?.clients = clients
                case .failure(let error):
                    print("Error fetching clients: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    /// Fetch a single client by id
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
    
    /// Create a client
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
    
    /// Fetch all client emails
    func fetchUniqueClientEmails() {
        isLoading = true
        errorMessage = nil

        service.fetchClients { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let clients):
                    let emails = Set(clients.map { $0.email }) // fetch unique emails
                    self?.uniqueClientEmails = Array(emails).sorted()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Update client details
    func updateClient(client: Client, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil

        service.updateClient(clientId: client.id, client: client) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let updatedClient):
                    if let index = self?.clients.firstIndex(where: { $0.id == updatedClient.id }) {
                        self?.clients[index] = updatedClient
                    }
                    self?.selectedClient = updatedClient
                    completion(true) // Notify success
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(false) // Notify failure
                }
            }
        }
    }
    
    /// Delete a client by id
    func deleteClient(clientId: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil

        service.deleteClient(clientId: clientId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.clients.removeAll { $0.id == clientId } // Remove client from list
                    self?.selectedClient = nil
                    completion(true)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
    
    /// Fetch a client by email
    func fetchClientByEmail(email: String) {
        guard let client = clients.first(where: { $0.email == email }) else {
            service.fetchClients { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let fetchedClients):
                        if let foundClient = fetchedClients.first(where: { $0.email == email }) {
                            self?.selectedClient = foundClient
                        }
                    case .failure(let error):
                        self?.errorMessage = "Error fetching the client : \(error.localizedDescription)"
                    }
                }
            }
            return
        }

        selectedClient = client
    }

}
