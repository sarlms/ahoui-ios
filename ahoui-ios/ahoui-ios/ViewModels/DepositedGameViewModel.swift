import Foundation

class DepositedGameViewModel: ObservableObject {
    @Published var depositedGames: [DepositedGame] = [] // for all deposited games
    @Published var depositedGamesForSeller: [SellerDepositedGameSeller] = [] // for a specific seller
    @Published var isLoading = false
    @Published var errorMessage: String? // store error messages for UI display
    @Published var selectedGame: DepositedGame? // store the selected game
    @Published var searchText: String = "" // filtering by text
    @Published var selectedSortOption: SortOption = .mostRecent // store selected option for filter
    @Published var selectedSessionId: String? = nil // store selected session for filter

    private let service: DepositedGameService
    
    private let isoDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()


    init(service: DepositedGameService) {
        self.service = service
    }

    /// Fetch deposited games for a specific seller by id
    func fetchDepositedGamesBySeller(sellerId: String) {
        isLoading = true
        errorMessage = nil
        print("Fetching deposited games for seller \(sellerId)...") // debugging

        service.fetchDepositedGamesBySeller(sellerId: sellerId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let games):
                    print("Successfully fetched \(games.count) games for seller") // debugging
                    print(games)
                    self?.depositedGamesForSeller = games // store them separately
                case .failure(let error):
                    print("Error fetching seller games: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    /// Fetch all deposited games
    func fetchAllDepositedGames() {
        isLoading = true
        errorMessage = nil
        print("Fetching all deposited games...") // debugging

        service.fetchAllDepositedGames { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let games):
                    print("Successfully fetched \(games.count) total games") // debugging
                    self?.depositedGames = games // store all deposited games
                case .failure(let error):
                    print("❌ Error fetching all games: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Fetch a single deposited game by id
    func fetchDepositedGameById(gameId: String) {
        isLoading = true
        errorMessage = nil
        print("Fetching deposited game with ID: \(gameId)...") // debugging

        service.fetchDepositedGameById(gameId: gameId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let game):
                    print("Successfully fetched game: \(game.gameDescription.name)") // debugging
                    self?.selectedGame = game
                case .failure(let error):
                    print("Error fetching game by ID: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Sorting options
    enum SortOption: String, CaseIterable {
        case mostRecent = "Plus récent"
        case priceAscending = "Prix croissant"
        case priceDescending = "Prix décroissant"
    }

    // Filter games by search AND selected session
    var filteredGames: [DepositedGame] {
        let filteredBySession = selectedSessionId == nil
            ? depositedGames
            : depositedGames.filter { $0.session?.id == selectedSessionId }

        let filteredBySearch = searchText.isEmpty
            ? filteredBySession
            : filteredBySession.filter { $0.gameDescription.name.lowercased().contains(searchText.lowercased()) }

        return sortGames(filteredBySearch)
    }

    /// Sorts games based on selected option
    private func sortGames(_ games: [DepositedGame]) -> [DepositedGame] {
        switch selectedSortOption {
        case .mostRecent:
            return games.sorted { $0.id > $1.id } // Assuming recent games have higher IDs
        case .priceAscending:
            return games.sorted { $0.salePrice < $1.salePrice }
        case .priceDescending:
            return games.sorted { $0.salePrice > $1.salePrice }
        }
    }
    
    /// Fetch the status of a session
    func getSessionStatus(for session: Session?) -> String {
        guard let session = session,
              let start = isoDateFormatter.date(from: session.startDate),
              let end = isoDateFormatter.date(from: session.endDate) else {
            return "unknown"
        }

        let now = Date()
        if now < start { return "to come" }
        if now > end { return "ended" }
        return "ongoing"
    }

    /// Update the availibility of a game
    func toggleAvailability(_ game: DepositedGame) {
        let updated = ["forSale": game.forSale]
        
        service.updateDepositedGame(id: game.id, with: updated) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Avaibility updated")
                    self.fetchAllDepositedGames()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

}
