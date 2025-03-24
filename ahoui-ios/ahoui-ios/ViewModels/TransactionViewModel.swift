import Foundation

class TransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var transactionsList: [TransactionList] = []
    @Published var filteredTransactions: [TransactionList] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Filter inputs
    @Published var searchTransactionId = ""
    @Published var searchClientEmail = ""
    @Published var searchSellerEmail = ""
    @Published var searchGameName = ""
    @Published var searchSessionName = ""

    private let service: TransactionService

    init(service: TransactionService) {
        self.service = service
    }

    // ✅ Fetch transactions for a seller
    func fetchTransactionsBySeller(sellerId: String) {
        isLoading = true
        errorMessage = nil

        service.fetchTransactionsBySeller(sellerId: sellerId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let transactions):
                    self?.transactions = transactions
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // ✅ Fetch all transactions
    func fetchAllTransactions() async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }

        do {
            let transactions = try await service.fetchAllTransactions()
            await MainActor.run {
                self.transactionsList = transactions
                self.filteredTransactions = transactions
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Error fetching transactions: \(error.localizedDescription)"
            }
        }

        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    func applyFilters() {
        filteredTransactions = transactionsList.filter { transaction in
            (searchTransactionId.isEmpty || transaction.id.contains(searchTransactionId)) &&
            (searchClientEmail.isEmpty || transaction.client.email.lowercased().contains(searchClientEmail.lowercased())) &&
            (searchSellerEmail.isEmpty || transaction.seller.email.lowercased().contains(searchSellerEmail.lowercased())) &&
            (searchGameName.isEmpty || transaction.label.gameDescription.name.lowercased().contains(searchGameName.lowercased())) &&
            (searchSessionName.isEmpty || transaction.session.name.lowercased().contains(searchSessionName.lowercased()))
        }
    }
    
    func resetFilters() {
        searchTransactionId = ""
        searchClientEmail = ""
        searchSellerEmail = ""
        searchGameName = ""
        searchSessionName = ""
        filteredTransactions = transactionsList
    }

}
