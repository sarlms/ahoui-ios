import Foundation

class RefundService {
    private let baseURL = "https://ahoui-back.cluster-ig4.igpolytech.fr/refund"

    private func createRequest(url: URL, method: String, body: Data? = nil, token: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = body
        return request
    }

    func createRefund(sellerId: String, refundAmount: Double, authViewModel: AuthViewModel, sessionViewModel: SessionViewModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let managerId = authViewModel.managerId else {
            completion(.failure(NSError(domain: "Manager ID not found", code: 0, userInfo: nil)))
            return
        }

        sessionViewModel.fetchActiveSession() // ✅ Fetch active session before refund
        guard let activeSession = sessionViewModel.activeSession else {
            completion(.failure(NSError(domain: "No active session found", code: 0, userInfo: nil)))
            return
        }

        guard let url = URL(string: baseURL) else { return }

        let refund = Refund(
            sellerId: sellerId,
            sessionId: activeSession.id,  // ✅ Use active session ID
            managerId: managerId,         // ✅ Use logged-in manager ID
            refundAmount: refundAmount,
            refundDate: ISO8601DateFormatter().string(from: Date()) // ✅ Use current date
        )

        do {
            let jsonData = try JSONEncoder().encode(refund)
            let request = createRequest(url: url, method: "POST", body: jsonData, token: authViewModel.authToken ?? "")

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
