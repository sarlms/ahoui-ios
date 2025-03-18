import Foundation

class DepositedGameViewModel: ObservableObject {
    @Published var depositedGames: [DepositedGame] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: DepositedGameService

    init(service: DepositedGameService) {
        self.service = service
    }

    func fetchDepositedGamesBySeller(sellerId: String) {
        isLoading = true
        errorMessage = nil

        service.fetchDepositedGamesBySeller(sellerId: sellerId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let games):
                    self?.depositedGames = games
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
