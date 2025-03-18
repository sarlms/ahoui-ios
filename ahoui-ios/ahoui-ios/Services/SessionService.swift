import Foundation

class SessionService {
    private let baseURL = "https://ahoui-back.cluster-ig4.igpolytech.fr/session/active"

    // Récupère la session active complète
    func fetchActiveSession(completion: @escaping (Session?) -> Void) {
        guard let url = URL(string: baseURL) else {
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
                let activeSession = sessions.first // Il ne peut y avoir qu'une seule session active
                if let session = activeSession {
                    print("✅ Session active récupérée :", session)
                } else {
                    print("⚠️ Aucune session active trouvée")
                }
                completion(activeSession)
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
        guard let url = URL(string: "\(baseURL)/upcoming") else {  // ✅ Endpoint à définir côté backend
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
                completion(nextSession)
            } catch {
                print("❌ Erreur de décodage :", error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
}
