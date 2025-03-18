import Foundation

class TransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
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
}
