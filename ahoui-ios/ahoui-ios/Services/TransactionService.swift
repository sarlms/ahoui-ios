import Foundation

class TransactionService {
    private let baseURL = "https://ahoui-back.cluster-ig4.igpolytech.fr/transaction"
    private let authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MjRkZGQ2MzVlNzZiMmU1OTUzZjk0NCIsImVtYWlsIjoic2FyYWhAZ21haWwuY29tIiwiaWF0IjoxNzQyMzIyMTQwLCJleHAiOjE3NDIzMjUxNDB9.Ibr-yQg7qGK61jhtxseBA2XnFJN94zP3SjzdoveD72U"

    private func createRequest(url: URL, method: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }

    // ✅ Fetch transactions by seller
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
                    print("❌ Decoding Error: \(error.localizedDescription)")
                    print("🛑 Raw JSON: \(String(data: data, encoding: .utf8) ?? "Invalid JSON")")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
