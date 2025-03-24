import Foundation

class RefundService {
    private let baseURL = "https://ahoui-back.cluster-ig4.igpolytech.fr/refund"
    
    private var authToken: String? {
        return UserDefaults.standard.string(forKey: "token")
    }

    private func createRequest(url: URL, method: String, body: Data? = nil, requiresAuth: Bool = false) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if requiresAuth, let token = authToken {
            request.addValue("Bearer (token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = body
        return request
    }

    // ✅ Fetch refunds by seller
    func fetchRefundsBySeller(sellerId: String, completion: @escaping (Result<[Refund], Error>) -> Void) {
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
                    let refunds = try JSONDecoder().decode([Refund].self, from: data)
                    completion(.success(refunds))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    // ✅ Create refund
    func createRefund(sellerId: String, refundAmount: Double, authViewModel: AuthViewModel, sessionViewModel: SessionViewModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let managerId = authViewModel.managerId else {
            completion(.failure(NSError(domain: "Manager ID not found", code: 0, userInfo: nil)))
            return
        }

        guard let activeSession = sessionViewModel.activeSession else {
            completion(.failure(NSError(domain: "No active session found", code: 0, userInfo: nil)))
            return
        }

        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        let refund = CreateRefund(
            sellerId: sellerId,
            sessionId: activeSession.id,
            managerId: managerId,
            refundAmount: refundAmount,
            refundDate: ISO8601DateFormatter().string(from: Date())
        )

        do {
            let jsonData = try JSONEncoder().encode(refund)
            
            

            // ✅ Log the request body before sending it
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("📤 Refund Request JSON:\n\(jsonString)")
            }

            var request = createRequest(url: url, method: "POST", body: jsonData)

            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                        completion(.failure(NSError(domain: "Server error", code: httpResponse.statusCode, userInfo: nil)))
                        return
                    }

                    completion(.success(()))
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    // ✅ Fetch all refunds
    func fetchAllRefunds(completion: @escaping (Result<[Refund], Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        let request = createRequest(url: url, method: "GET")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Error fetching refunds: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    print("❌ No refund data received")
                    completion(.failure(NSError(domain: "No data", code: -2, userInfo: nil)))
                    return
                }

                // ✅ Log Raw Response
                if let rawJSON = String(data: data, encoding: .utf8) {
                    print("📩 Raw Refund JSON Response: \(rawJSON)")
                }

                // ✅ Attempt to Decode
                do {
                    let refunds = try JSONDecoder().decode([Refund].self, from: data)
                    print("✅ Successfully decoded refunds: \(refunds)")
                    completion(.success(refunds))
                } catch {
                    print("❌ Error decoding refunds: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }



}
