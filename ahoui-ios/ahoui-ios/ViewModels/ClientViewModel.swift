import Foundation

class ClientViewModel: ObservableObject {
    @Published var clients: [Client] = []
    @Published var selectedClient: Client?
    @Published var isLoading = false
    @Published var errorMessage: String?

    
    //utilisé pour commencer à taper l'email du client dans le Cart
    @Published var uniqueClientEmails: [String] = []
    @Published var selectedEmail: String?
    @Published var searchText: String = "" {
        didSet {
            if searchText.isEmpty {
                selectedClient = nil // Effacer le client sélectionné si l'input est vidé
            }
        }
    }
    
    
    //utilisé pour commencer à taper l'email du client dans le Cart
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
    
    
    //utilisée dans Cart (encaissement)
    func fetchUniqueClientEmails() {
        isLoading = true
        errorMessage = nil

        service.fetchClients { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let clients):
                    let emails = Set(clients.map { $0.email }) // Récupérer les emails uniques
                    self?.uniqueClientEmails = Array(emails).sorted()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    
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
                        self?.errorMessage = "❌ Impossible de récupérer le client : \(error.localizedDescription)"
                    }
                }
            }
            return
        }

        selectedClient = client
    }


    

}
