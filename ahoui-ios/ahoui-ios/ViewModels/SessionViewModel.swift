import Foundation

class SessionViewModel: ObservableObject {
    @Published var activeSession: Session?
    @Published var errorMessage: String?
    @Published var nextSession: Session?

    private let sessionService = SessionService()

    func fetchActiveSession() {
        sessionService.fetchActiveSession { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let session):
                    self?.activeSession = session
                case .failure(let error):
                    self?.errorMessage = "Erreur lors de la récupération de la session active: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func fetchAllSessions() {
        sessionService.fetchAllSessions { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let sessions):
                    let now = Date()
                    self?.nextSession = sessions
                        .filter { $0.startDate > now }
                        .sorted { $0.startDate < $1.startDate }
                        .first
                case .failure:
                    self?.nextSession = nil
                }
            }
        }
    }
}
