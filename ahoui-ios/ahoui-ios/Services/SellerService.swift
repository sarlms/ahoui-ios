import Foundation

class SellerService {
    
    private let baseURL = "https://ahoui-back.cluster-ig4.igpolytech.fr/seller"

    /// GET request to fetch all sellers
    func fetchSellers(completion: @escaping (Result<[Seller], Error>) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        let request = NetworkHelper.createRequest(url: url, method: "GET")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching sellers: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            // Debug: Print raw response
            if let jsonString = String(data: data, encoding: .utf8) {
                //print("Raw JSON Response: \(jsonString)")
            }

            do {
                let sellers = try JSONDecoder().decode([Seller].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(sellers))
                }
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }

    /// GET request to fetch a single seller by id
    func fetchSeller(id: String, completion: @escaping (Result<Seller, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        let request = NetworkHelper.createRequest(url: url, method: "GET")

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

    /// DELETE method to delete a seller by id
    func deleteSeller(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        let request = NetworkHelper.createRequest(url: url, method: "DELETE")

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
    
    /// PUT request to update a seller by id
    func updateSeller(id: String, updatedSeller: Seller, completion: @escaping (Result<Seller, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }

        do {
            let jsonData = try JSONEncoder().encode(updatedSeller)
            var request = NetworkHelper.createRequest(url: url, method: "PUT", body: jsonData)

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
    
    /// POST request to create a seller
    func createSeller(_ seller: Seller, completion: @escaping (Result<Seller, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)") else { return } // Ensure correct API endpoint

        let sellerData = ["name": seller.name, "email": seller.email, "phone": seller.phone, "amountOwed": seller.amountOwed] as [String : Any]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: sellerData, options: [])
            var request = NetworkHelper.createRequest(url: url, method: "POST", body: jsonData)

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
    
    /// POST request to create a refund
    func createRefund(refund: Refund, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let url = URL(string: "\(baseURL)/refund") else { return }
            
            do {
                let jsonData = try JSONEncoder().encode(refund)
                let request = NetworkHelper.createRequest(url: url, method: "POST", body: jsonData)
                
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
    
    /// PUT request to update the amount owned to a seller
    func updateSellerAmountOwed(sellerId: String, amount: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(sellerId)") else { return }

        let requestBody = ["amountOwed": amount]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(.failure(NSError(domain: "Encoding error", code: -3, userInfo: nil)))
            return
        }

        var request = NetworkHelper.createRequest(url: url, method: "PUT", body: jsonData)

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

}
