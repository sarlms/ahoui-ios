import Foundation

class SessionListViewModel: ObservableObject {
    @Published var sessions: [Session] = []

    private let sessionService = SessionService()

    func loadSessions() {
        sessionService.fetchSessions { [weak self] sessions in
            DispatchQueue.main.async {
                self?.sessions = sessions
            }
        }
    }
}
