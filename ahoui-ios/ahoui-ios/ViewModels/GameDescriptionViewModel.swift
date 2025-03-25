import Foundation

class GameDescriptionViewModel: ObservableObject {
    @Published var gameDescriptions: [GameDescription] = []
    @Published var selectedGameDescription: GameDescription?
    @Published var selectedGames: [GameDescription] = []  // Liste des jeux sélectionnés
    @Published var uniqueGameNames: [String] = []
    @Published var selectedName: String?
    @Published var searchText: String = "" {
        didSet {
            if searchText.isEmpty {
                selectedGameDescription = nil
            }
        }
    }
    
    var filteredNames: [String] {
        if searchText.isEmpty {
            return uniqueGameNames
        } else {
            return uniqueGameNames.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    private let service: GameDescriptionService
    
    init(service: GameDescriptionService) {
        self.service = service
        fetchGameDescriptions()  // Chargement immédiat
    }
    
    func fetchGameDescriptions() {
        service.fetchAllGames { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let games):
                    self?.gameDescriptions = games
                    self?.uniqueGameNames = Array(Set(games.map { $0.name })).sorted()
                case .failure(let error):
                    print("Erreur lors de la récupération des jeux : \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchGameByName(name: String) {
        guard let game = gameDescriptions.first(where: { $0.name == name }) else {
            return
        }
        selectedGameDescription = game
    }
    
    func addGameToSelection() {
        guard let game = selectedGameDescription, !selectedGames.contains(where: { $0.id == game.id }) else { return }
        selectedGames.append(game)  // Ajout du jeu sélectionné
        searchText = ""  // Réinitialisation du champ
        selectedGameDescription = nil
    }
    
    func removeGameFromSelection(game: GameDescription) {
        selectedGames.removeAll { $0.id == game.id }  // Suppression d’un jeu de la liste
    }
    
    func getGameDescriptionId(byName name: String) -> String? {
        return gameDescriptions.first(where: { $0.name == name })?.id
    }
    
    func createGame(description: GameDescriptionCreation, completion: @escaping (Bool) -> Void) {
            service.createGameDescription(description) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let newGame):
                        self?.gameDescriptions.append(newGame)
                        self?.uniqueGameNames.append(newGame.name)
                        completion(true)
                    case .failure(let error):
                        print("Failed to create game: (error.localizedDescription)")
                        completion(false)
                    }
                }
            }
        }
}
