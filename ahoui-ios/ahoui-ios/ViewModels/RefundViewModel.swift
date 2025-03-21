import Foundation

class RefundViewModel: ObservableObject {
    @Published var refunds: [Refund] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: RefundService

    init(service: RefundService) {
        self.service = service
    }

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
