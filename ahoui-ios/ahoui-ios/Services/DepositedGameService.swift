import Foundation

class DepositedGameService {
    private let baseURL = "https://ahoui-back.cluster-ig4.igpolytech.fr/depositedGame"

    func createDepositedGame(data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        guard let jsonData = try? JSONSerialization.data(withJSONObject: data) else {
            completion(.failure(NSError(domain: "Invalid JSON", code: -2)))
            return
        }

        let request = NetworkHelper.createRequest(url: url, method: "POST", body: jsonData, requiresAuth: true)

        URLSession.shared.dataTask(with: request) { _, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }.resume()
    }

    func fetchAllDepositedGames(completion: @escaping (Result<[DepositedGame], Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        let request = NetworkHelper.createRequest(url: url, method: "GET", requiresAuth: true)

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "No data received", code: -2)))
                    return
                }

                do {
                    let games = try JSONDecoder().decode([DepositedGame].self, from: data)
                    completion(.success(games))
                } catch {
                    print("❌ JSON Decoding Error for ALL games: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    func fetchDepositedGamesBySeller(sellerId: String, completion: @escaping (Result<[SellerDepositedGameSeller], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/seller/\(sellerId)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        let request = NetworkHelper.createRequest(url: url, method: "GET", requiresAuth: true)

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "No data received", code: -2)))
                    return
                }

                do {
                    let games = try JSONDecoder().decode([SellerDepositedGameSeller].self, from: data)
                    completion(.success(games))
                } catch {
                    print("❌ JSON Decoding Error for SELLER games: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    func markAsSold(gameId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(gameId)") else { return }

        let requestBody = ["forSale": false, "sold": true]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(.failure(NSError(domain: "Encoding error", code: -3)))
            return
        }

        let request = NetworkHelper.createRequest(url: url, method: "PUT", body: jsonData, requiresAuth: true)

        URLSession.shared.dataTask(with: request) { _, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
        }.resume()
    }

    func fetchDepositedGameById(gameId: String, completion: @escaping (Result<DepositedGame, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(gameId)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        let request = NetworkHelper.createRequest(url: url, method: "GET", requiresAuth: true)

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "No data received", code: -2)))
                    return
                }

                do {
                    let game = try JSONDecoder().decode(DepositedGame.self, from: data)
                    completion(.success(game))
                } catch {
                    print("JSON Decoding Error for game by ID: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    func updateDepositedGame(id: String, with fields: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/depositedGame/\(id)") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        guard let jsonData = try? JSONSerialization.data(withJSONObject: fields) else {
            completion(.failure(NSError(domain: "Encoding error", code: -3, userInfo: nil)))
            return
        }

        let request = NetworkHelper.createRequest(url: url, method: "PATCH", body: jsonData, requiresAuth: true)

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            completion(.success(()))
        }.resume()
    }
}
