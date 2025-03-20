import Foundation

class SellerViewModel: ObservableObject {
    @Published var sellers: [Seller] = []
    @Published var selectedSeller: Seller?
    @Published var errorMessage: String? // Store error messages for UI feedback
    @Published var managerId: String? // ✅ Doit être rempli par l'application

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

    // Filtrer les emails
    var filteredEmails: [String] {
        if searchText.isEmpty {
            return uniqueSellerEmails
        } else {
            return uniqueSellerEmails.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }

    
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
    
    func refundSeller(sellerId: String, refundAmount: Double, authViewModel: AuthViewModel, sessionViewModel: SessionViewModel) {
            refundService.createRefund(sellerId: sellerId, refundAmount: refundAmount, authViewModel: authViewModel, sessionViewModel: sessionViewModel) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        print("✅ Remboursement réussi pour le vendeur \(sellerId)")
                        if let seller = self?.selectedSeller {
                            let updatedSeller = Seller(id: seller.id, name: seller.name, email: seller.email, phone: seller.phone, amountOwed: 0)
                            self?.updateSeller(id: sellerId, updatedSeller: updatedSeller)
                        }
                    case .failure(let error):
                        self?.errorMessage = "Erreur de remboursement: \(error.localizedDescription)"
                    }
                }
            }
        }
    
    func fetchUniqueSellerEmails() {
        sellerService.fetchSellers { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let sellers):
                    let emails = Set(sellers.map { $0.email })
                    self?.uniqueSellerEmails = Array(emails).sorted()
                case .failure(let error):
                    self?.errorMessage = "Erreur lors de la récupération des emails: \(error.localizedDescription)"
                }
            }
        }
    }

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
                        self?.errorMessage = "❌ Impossible de récupérer le vendeur : \(error.localizedDescription)"
                    }
                }
            }
            return
        }
        selectedSeller = seller
    }
}
