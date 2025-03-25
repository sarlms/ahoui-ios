import Foundation

class RefundViewModel: ObservableObject {
    @Published var refunds: [Refund] = [] // store the refunds
    @Published var isLoading = false // store state of the refund
    @Published var errorMessage: String? // store error messages for UI display

    private let service: RefundService

    init(service: RefundService) {
        self.service = service
    }

    /// Fetch refunds for a specific seller by id
    func fetchRefundsBySeller(sellerId: String) {
        isLoading = true
        errorMessage = nil

        service.fetchRefundsBySeller(sellerId: sellerId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let refunds):
                    self?.refunds = refunds
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    /// Fetch all the refunds made
    func fetchAllRefunds() {
        isLoading = true
        errorMessage = nil

        service.fetchAllRefunds { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let refunds):
                    self?.refunds = refunds
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

}
