import Foundation

class SessionViewModel: ObservableObject {
    @Published var activeSession: Session?
    @Published var activeSessionId: String?
    @Published var nextSession: Session?
    
    private let sessionService = SessionService()

    func loadActiveSession() {
        sessionService.fetchActiveSession { [weak self] session in
            DispatchQueue.main.async {
                self?.activeSession = session
            }
        }
    }

    func loadActiveSessionId() {
        sessionService.fetchActiveSessionId { [weak self] sessionId in
            DispatchQueue.main.async {
                self?.activeSessionId = sessionId
            }
        }
    }
    
    func loadNextSession() {
        sessionService.fetchNextSession { [weak self] session in
            DispatchQueue.main.async {
                self?.nextSession = session
            }
        }
    }
}
