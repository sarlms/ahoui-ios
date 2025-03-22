import Foundation

class SessionService {
    private let baseURL = "https://ahoui-back.cluster-ig4.igpolytech.fr/session"

    // Récupère toutes les sessions
    func fetchSessions(completion: @escaping ([Session]) -> Void) {
        guard let url = URL(string: baseURL) else {
            print("❌ URL invalide")
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Erreur de requête :", error.localizedDescription)
                completion([])
                return
            }

            guard let data = data else {
                print("❌ Aucune donnée reçue")
                completion([])
                return
            }

            do {
                let decodedSessions = try JSONDecoder().decode([Session].self, from: data)

                // 🔽 Trie les sessions par date de début décroissante
                let sortedSessions = decodedSessions.sorted {
                    let date1 = isoDateFormatter.date(from: $0.startDate) ?? Date.distantPast
                    let date2 = isoDateFormatter.date(from: $1.startDate) ?? Date.distantPast
                    return date1 > date2
                }

                DispatchQueue.main.async {
                    completion(sortedSessions)
                }
            } catch {
                print("❌ Erreur de décodage :", error.localizedDescription)
                completion([])
            }
        }.resume()
    }


    // Récupère la session actuellement ouverte (si elle existe)
    func fetchActiveSession(completion: @escaping (Session?) -> Void) {
        guard let url = URL(string: "\(baseURL)/active") else {
            print("❌ URL invalide")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Erreur de requête :", error.localizedDescription)
                completion(nil)
                return
            }

            guard let data = data else {
                print("❌ Aucune donnée reçue")
                completion(nil)
                return
            }

            do {
                let sessions = try JSONDecoder().decode([Session].self, from: data)
                let activeSession = sessions.first // Il ne doit y avoir qu'une seule session active
                DispatchQueue.main.async {
                    completion(activeSession)
                }
            } catch {
                print("❌ Erreur de décodage :", error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }

    // Récupère uniquement l'identifiant de la session active
    func fetchActiveSessionId(completion: @escaping (String?) -> Void) {
        fetchActiveSession { session in
            if let session = session {
                print("✅ ID de la session active :", session.id)
                completion(session.id)
            } else {
                print("⚠️ Impossible de récupérer l'ID de la session active")
                completion(nil)
            }
        }
    }

    // Récupère la prochaine session à venir (la plus proche dans le futur)
    func fetchNextSession(completion: @escaping (Session?) -> Void) {
        guard let url = URL(string: "\(baseURL)/upcoming") else {
            print("❌ URL invalide")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Erreur de requête :", error.localizedDescription)
                completion(nil)
                return
            }

            guard let data = data else {
                print("❌ Aucune donnée reçue")
                completion(nil)
                return
            }

            do {
                let sessions = try JSONDecoder().decode([Session].self, from: data)
                let nextSession = sessions.first  // La prochaine session (la plus proche dans le futur)
                DispatchQueue.main.async {
                    completion(nextSession)
                }
            } catch {
                print("❌ Erreur de décodage :", error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }

    // Vérifie si une session est clôturée
    func isSessionClosed(_ session: Session) -> Bool {
        let today = Date()
        let endDate = isoDateFormatter.date(from: session.endDate) ?? Date.distantPast
        return today > endDate
    }

    // Formate une date ISO en "9 février 2025"
    func formatDate(_ dateString: String) -> String {
        if let date = isoDateFormatter.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "fr_FR")
            formatter.dateFormat = "dd MMMM yyyy"
            return formatter.string(from: date)
        }
        return dateString
    }
    
    // Formate une heure ISO en "HH:mm" (ex: 14:30)
    func formatTime(_ timeString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = isoFormatter.date(from: timeString) {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "fr_FR")
            formatter.dateFormat = "HH:mm" // Format 24h
            return formatter.string(from: date)
        }

        return timeString // Retourne la valeur brute en cas d'échec
    }

    
    
    // Fusionne une date et une heure en un format ISO8601 complet
    func mergeDateAndTime(date: Date, time: Date) -> String {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!

        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)

        var mergedComponents = DateComponents()
        mergedComponents.year = dateComponents.year
        mergedComponents.month = dateComponents.month
        mergedComponents.day = dateComponents.day
        mergedComponents.hour = timeComponents.hour
        mergedComponents.minute = timeComponents.minute

        if let mergedDate = calendar.date(from: mergedComponents) {
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return isoFormatter.string(from: mergedDate)
        }
        return ""
    }

    // Fonction pour créer une session
    func createSession(sessionData: [String: Any], authToken: String, completion: @escaping (Bool, String) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(false, "URL invalide")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: sessionData, options: [])
        } catch {
            completion(false, "Erreur lors de la conversion des données")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "Erreur réseau : \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, "Réponse invalide")
                return
            }

            if httpResponse.statusCode == 201 {
                completion(true, "Session créée avec succès")
            } else {
                completion(false, "Erreur serveur (Code \(httpResponse.statusCode))")
            }
        }.resume()
    }
    
    
    // Supprime une session spécifique
    func deleteSession(sessionId: String, authToken: String?, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(sessionId)") else {
            print("❌ URL invalide")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        // Ajout du token d'authentification pour vérifier que seul un manager peut supprimer
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("❌ Aucun token d'authentification fourni")
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Erreur lors de la suppression :", error.localizedDescription)
                completion(false)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Réponse invalide du serveur")
                completion(false)
                return
            }

            if httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    print("✅ Session supprimée avec succès")
                    completion(true)
                }
            } else {
                print("❌ Erreur serveur lors de la suppression (Code \(httpResponse.statusCode))")
                completion(false)
            }
        }.resume()
    }
}


// Formatter ISO 8601
private let isoDateFormatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter
}()
