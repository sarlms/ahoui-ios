import Foundation

class DepositedGameViewModel: ObservableObject {
    @Published var depositedGames: [DepositedGame] = [] // ✅ For all deposited games
    @Published var depositedGamesForSeller: [SellerDepositedGameSeller] = [] // ✅ For a specific seller
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: DepositedGameService

    init(service: DepositedGameService) {
        self.service = service
    }

    /// 🔹 Fetch deposited games for a specific seller
    func fetchDepositedGamesBySeller(sellerId: String) {
        isLoading = true
        errorMessage = nil
        print("Fetching deposited games for seller \(sellerId)...") // ✅ Debugging

        service.fetchDepositedGamesBySeller(sellerId: sellerId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let games):
                    print("✅ Successfully fetched \(games.count) games for seller") // ✅ Debugging
                    print(games)
                    self?.depositedGamesForSeller = games // ✅ Store them separately
                case .failure(let error):
                    print("❌ Error fetching seller games: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    /// 🔹 Fetch all deposited games (for the full database)
    func fetchAllDepositedGames() {
        isLoading = true
        errorMessage = nil
        print("Fetching all deposited games...") // ✅ Debugging

        service.fetchAllDepositedGames { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let games):
                    print("✅ Successfully fetched \(games.count) total games") // ✅ Debugging
                    self?.depositedGames = games // ✅ Store all deposited games
                case .failure(let error):
                    print("❌ Error fetching all games: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
