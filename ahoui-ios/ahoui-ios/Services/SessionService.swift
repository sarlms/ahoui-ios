import Foundation

class SessionService {
    private let baseURL = "https://ahoui-back.cluster-ig4.igpolytech.fr/session"

    private func createRequest(url: URL, method: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request // Pas de token nécessaire
    }

    func fetchActiveSession(completion: @escaping (Result<Session, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/active") else { return }
        let request = createRequest(url: url, method: "GET")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            do {
                let activeSession = try JSONDecoder().decode(Session.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(activeSession))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchAllSessions(completion: @escaping (Result<[Session], Error>) -> Void) {
            guard let url = URL(string: baseURL) else { return }
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
                    let sessions = try JSONDecoder().decode([Session].self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(sessions))
                    }
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
}
