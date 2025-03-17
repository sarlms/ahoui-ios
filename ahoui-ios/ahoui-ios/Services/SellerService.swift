import Foundation

class SellerService {
    private let baseURL = "https://ahoui-back.cluster-ig4.igpolytech.fr/seller"
    
    // Static Bearer Token (Replace with your actual token)
    private let bearerToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MjRkZGQ2MzVlNzZiMmU1OTUzZjk0NCIsImVtYWlsIjoic2FyYWhAZ21haWwuY29tIiwiaWF0IjoxNzQyMjA4MzQ2LCJleHAiOjE3NDIyMTEzNDZ9.OfVxjQR11jlqvvRftTZwQP3jMsuHMAm540e2Ya0k_y4"

    // Function to create an authenticated request
    private func createRequest(url: URL, method: String, body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = body
        return request
    }

    func fetchSellers(completion: @escaping (Result<[Seller], Error>) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        let request = createRequest(url: url, method: "GET")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error fetching sellers: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("❌ No data received")
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            // ✅ Debug: Print raw response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("✅ Raw JSON Response: \(jsonString)")
            }

            do {
                let sellers = try JSONDecoder().decode([Seller].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(sellers))
                }
            } catch {
                print("❌ Decoding error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }


    func fetchSeller(id: String, completion: @escaping (Result<Seller, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        let request = createRequest(url: url, method: "GET")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            do {
                let seller = try JSONDecoder().decode(Seller.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(seller))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func deleteSeller(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        let request = createRequest(url: url, method: "DELETE")

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            DispatchQueue.main.async {
                completion(.success(()))
            }
        }.resume()
    }
    
    func updateSeller(id: String, updatedSeller: Seller, completion: @escaping (Result<Seller, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }

        do {
            let jsonData = try JSONEncoder().encode(updatedSeller)
            var request = createRequest(url: url, method: "PUT", body: jsonData)

            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                    return
                }
                do {
                    let updatedSeller = try JSONDecoder().decode(Seller.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(updatedSeller))
                    }
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    func createSeller(_ seller: Seller, completion: @escaping (Result<Seller, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)") else { return } // ✅ Ensure correct API endpoint

        let sellerData = ["name": seller.name, "email": seller.email, "phone": seller.phone, "amountOwed": seller.amountOwed] as [String : Any]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: sellerData, options: [])
            var request = createRequest(url: url, method: "POST", body: jsonData)

            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                    return
                }
                do {
                    let createdSeller = try JSONDecoder().decode(Seller.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(createdSeller))
                    }
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    func createRefund(refund: Refund, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let url = URL(string: "\(baseURL)/refund") else { return }
            
            do {
                let jsonData = try JSONEncoder().encode(refund)
                let request = createRequest(url: url, method: "POST", body: jsonData)
                
                URLSession.shared.dataTask(with: request) { _, _, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(()))
                        }
                    }
                }.resume()
            } catch {
                completion(.failure(error))
            }
        }

}
