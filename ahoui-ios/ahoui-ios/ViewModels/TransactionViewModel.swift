import Foundation

class TransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var transactionsList: [TransactionList] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

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
}
