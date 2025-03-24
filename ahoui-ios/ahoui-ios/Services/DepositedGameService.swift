import Foundation

class DepositedGameService {
    private let baseURL = "https://ahoui-back.cluster-ig4.igpolytech.fr/depositedGame"
    private let authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MjRkZGQ2MzVlNzZiMmU1OTUzZjk0NCIsImVtYWlsIjoic2FyYWhAZ21haWwuY29tIiwiaWF0IjoxNzQyMzMwMTkzLCJleHAiOjE3NDIzMzMxOTN9.GGuoXkqEwLFcCf_Huy4kMMpq2K9V0rw_st8jeJNx28c"

    private func createRequest(url: URL, method: String, body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = body
        return request
    }
    
    func createDepositedGame(data: [String: Any], token: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        guard let jsonData = try? JSONSerialization.data(withJSONObject: data) else {
            completion(.failure(NSError(domain: "Invalid JSON", code: -2)))
            return
        }

        request.httpBody = jsonData

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


    /// 🔹 Fetch **all** deposited games
    func fetchAllDepositedGames(completion: @escaping (Result<[DepositedGame], Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
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
                    let games = try JSONDecoder().decode([DepositedGame].self, from: data)
                    completion(.success(games))
                } catch {
                    print("❌ JSON Decoding Error for ALL games: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    /// 🔹 Fetch deposited games for a **specific seller**
    func fetchDepositedGamesBySeller(sellerId: String, completion: @escaping (Result<[SellerDepositedGameSeller], Error>) -> Void) {
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
            completion(.failure(NSError(domain: "Encoding error", code: -3, userInfo: nil)))
            return
        }

        var request = createRequest(url: url, method: "PUT", body: jsonData)

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
    
    // Fetch a single deposited game by ID
    func fetchDepositedGameById(gameId: String, completion: @escaping (Result<DepositedGame, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(gameId)") else {
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
                    let game = try JSONDecoder().decode(DepositedGame.self, from: data)
                    completion(.success(game))
                } catch {
                    print("JSON Decoding Error for game by ID: (error.localizedDescription)")
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

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: fields)

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
