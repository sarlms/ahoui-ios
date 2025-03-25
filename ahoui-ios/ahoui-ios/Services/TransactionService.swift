import Foundation

class TransactionService {
    private let baseURL = "https://ahoui-back.cluster-ig4.igpolytech.fr/transaction"
    
    //on récup le token sauvegardé après la connexion
    private var authToken: String? {
        return UserDefaults.standard.string(forKey: "token")
    }

    private func createRequest(url: URL, method: String, body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = authToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("Aucun token trouvé dans UserDefaults")
        }

        request.httpBody = body
        return request
    }

    /// GET request to fetch all transactions
    func fetchAllTransactions() async throws -> [TransactionList] {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }

        let request = createRequest(url: url, method: "GET")
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([TransactionList].self, from: data)
    }

    /// GET request to fetch transactions by seller
    func fetchTransactionsBySeller(sellerId: String, completion: @escaping (Result<[Transaction], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/seller/\(sellerId)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        let request = createRequest(url: url, method: "GET")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "No data received", code: -2, userInfo: nil)))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let transactions = try decoder.decode([Transaction].self, from: data)
                    completion(.success(transactions))
                } catch {
                    print("Decoding Error: \(error.localizedDescription)")
                    print("Raw JSON: \(String(data: data, encoding: .utf8) ?? "Invalid JSON")")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    /// POST request to create many transactions at once
    func createMultipleTransactions(transactions: [TransactionRequest], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            print("Erreur : URL invalide")
            return
        }
        
        // Boucle sur chaque transaction pour les envoyer individuellement
        let dispatchGroup = DispatchGroup()
        var hasError = false

        for transaction in transactions {
            dispatchGroup.enter()  // Début d'une requête
            
            guard let jsonData = try? JSONEncoder().encode(transaction) else {
                print("Erreur lors de l'encodage JSON pour \(transaction)")
                hasError = true
                dispatchGroup.leave()
                continue
            }

            print("Envoi d'une transaction unique : \(String(data: jsonData, encoding: .utf8) ?? "JSON invalide")")

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            if let token = authToken {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            } else {
                print("Aucun token trouvé dans UserDefaults")
            }

            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { data, response, error in
                defer { dispatchGroup.leave() }  // Fin de la requête

                if let error = error {
                    print("Erreur réseau lors de l'envoi : \(error.localizedDescription)")
                    hasError = true
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("Réponse HTTP : \(httpResponse.statusCode)")
                }

                if let data = data {
                    print("Réponse du serveur : \(String(data: data, encoding: .utf8) ?? "Impossible d'afficher la réponse")")
                }
            }.resume()
        }

        // Notifier quand toutes les requêtes sont terminées
        dispatchGroup.notify(queue: .main) {
            if hasError {
                completion(.failure(NSError(domain: "Une ou plusieurs transactions ont échoué", code: -5, userInfo: nil)))
            } else {
                completion(.success(()))
            }
        }
    }


    
}

struct TransactionRequest: Codable {
    let labelId: String
    let sessionId: String
    let sellerId: String
    let clientId: String
    let managerId: String
    
    enum CodingKeys: String, CodingKey {
        case labelId = "labelId"
        case sessionId = "sessionId"
        case sellerId = "sellerId"
        case clientId = "clientId"
        case managerId = "managerId"
    }
}
