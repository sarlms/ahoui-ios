import Foundation

class SellerViewModel: ObservableObject {
    @Published var sellers: [Seller] = []
    @Published var selectedSeller: Seller? // store the selected seller for navigation
    @Published var errorMessage: String? // store error messages for UI feedback
    @Published var managerId: String? // has to be filled
    private let sellerService = SellerService()
    private let refundService = RefundService()
    
    // Utilisé pour la recherche d'email
    @Published var uniqueSellerEmails: [String] = []
    @Published var selectedEmail: String?
    @Published var searchText: String = "" {
        didSet {
            if searchText.isEmpty {
                selectedSeller = nil
            }
        }
    }

    // filter emails
    var filteredEmails: [String] {
        if searchText.isEmpty {
            return uniqueSellerEmails
        } else {
            return uniqueSellerEmails.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }

    /// Create a seller
    func createSeller(seller: Seller) {
        sellerService.createSeller(seller) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newSeller):
                    self?.sellers.append(newSeller)
                case .failure(let error):
                    self?.errorMessage = "Failed to create seller: \(error.localizedDescription)"
                }
            }
        }
    }
    
    /// Update a seller by id
    func updateSeller(id: String, updatedSeller: Seller) {
        sellerService.updateSeller(id: id, updatedSeller: updatedSeller) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedSeller):
                    if let index = self?.sellers.firstIndex(where: { $0.id == id }) {
                        self?.sellers[index] = updatedSeller
                    }
                    self?.selectedSeller = updatedSeller
                case .failure(let error):
                    self?.errorMessage = "Failed to update seller: \(error.localizedDescription)"
                }
            }
        }
    }

    /// Fetch all sellers
    func fetchSellers() {
        sellerService.fetchSellers { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let sellers):
                    self?.sellers = sellers
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch sellers: \(error.localizedDescription)"
                    print("Error fetching sellers: \(error.localizedDescription)")
                }
            }
        }
    }

    /// Fetch a seller by id
    func fetchSeller(id: String) {
        sellerService.fetchSeller(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let seller):
                    self?.selectedSeller = seller
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch seller: \(error.localizedDescription)"
                    print("Error fetching seller: \(error.localizedDescription)")
                }
            }
        }
    }

    /// Delete a seller by id
    func deleteSeller(id: String) {
        sellerService.deleteSeller(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.sellers.removeAll { $0.id == id }
                    self?.selectedSeller = nil
                case .failure(let error):
                    self?.errorMessage = "Failed to delete seller: \(error.localizedDescription)"
                    print("Error deleting seller: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// Create a refund for a seller
    func refundSeller(sellerId: String, refundAmount: Double, authViewModel: AuthViewModel, sessionViewModel: SessionViewModel) {
            refundService.createRefund(sellerId: sellerId, refundAmount: refundAmount, authViewModel: authViewModel, sessionViewModel: sessionViewModel) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        print("Refund successful for seller: \(sellerId)")
                        if let seller = self?.selectedSeller {
                            let updatedSeller = Seller(id: seller.id, name: seller.name, email: seller.email, phone: seller.phone, amountOwed: 0)
                            self?.updateSeller(id: sellerId, updatedSeller: updatedSeller)
                        }
                    case .failure(let error):
                        self?.errorMessage = "Failed to refund the seller: \(error.localizedDescription)"
                    }
                }
            }
        }
    
    /// Fetch all seller emails
    func fetchUniqueSellerEmails() {
        sellerService.fetchSellers { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let sellers):
                    let emails = Set(sellers.map { $0.email })
                    self?.uniqueSellerEmails = Array(emails).sorted()
                case .failure(let error):
                    self?.errorMessage = "Failed to get the emails: \(error.localizedDescription)"
                }
            }
        }
    }

    /// Fetch a seller by email
    func fetchSellerByEmail(email: String) {
        guard let seller = sellers.first(where: { $0.email == email }) else {
            sellerService.fetchSellers { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let fetchedSellers):
                        if let foundSeller = fetchedSellers.first(where: { $0.email == email }) {
                            self?.selectedSeller = foundSeller
                        }
                    case .failure(let error):
                        self?.errorMessage = "Failed to fetch seller: \(error.localizedDescription)"
                    }
                }
            }
            return
        }
        selectedSeller = seller
    }
}
