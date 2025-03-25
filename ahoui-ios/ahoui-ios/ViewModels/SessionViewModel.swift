import Foundation

class SessionViewModel: ObservableObject {
    @Published var activeSession: Session?
    @Published var activeSessionId: String?
    @Published var nextSession: Session?
    @Published var sessions: [Session] = []
    @Published var selectedSessionId: String? = nil
    
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
                UserDefaults.standard.set(sessionId, forKey: "sessionId")
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
    
    func formatDate(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // Ajout du support pour les millisecondes
        
        if let date = isoFormatter.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "fr_FR") // Français
            formatter.dateFormat = "dd/MM/yyyy HH:mm" // Format voulu
            return formatter.string(from: date)
        }
        
        // Si le format ISO ne fonctionne pas, essayons un autre format courant
        let alternativeFormatter = DateFormatter()
        alternativeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = alternativeFormatter.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "fr_FR")
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            return formatter.string(from: date)
        }

        return dateString // Si aucun format ne fonctionne, on retourne la date brute
    }

    func loadSessions() {
        sessionService.fetchSessions { [weak self] fetchedSessions in
            DispatchQueue.main.async {
                self?.sessions = fetchedSessions
            }
        }
    }

}
