import Foundation

class ClientService {
    private let baseURL = "https://ahoui-back.cluster-ig4.igpolytech.fr/client"

    // Fetch all clients
    func fetchClients(completion: @escaping (Result<[Client], Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        let request = NetworkHelper.createRequest(url: url, method: "GET")

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
                    let clients = try JSONDecoder().decode([Client].self, from: data)
                    completion(.success(clients))
                } catch {
                    print("JSON Decoding Error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    // Fetch a single client by ID
    func fetchClientById(clientId: String, completion: @escaping (Result<Client, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(clientId)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        let request = NetworkHelper.createRequest(url: url, method: "GET")

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
                    let client = try JSONDecoder().decode(Client.self, from: data)
                    completion(.success(client))
                } catch {
                    print("JSON Decoding Error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    // Create a new client
    func createClient(client: Client, completion: @escaping (Result<Client, Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        let clientData: [String: Any] = [
            "name": client.name,
            "email": client.email,
            "phone": client.phone,
            "address": client.address
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: clientData, options: []) else {
            completion(.failure(NSError(domain: "Encoding error", code: -3, userInfo: nil)))
            return
        }

        var request = NetworkHelper.createRequest(url: url, method: "POST", body: jsonData, requiresAuth: true)

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
                    let newClient = try JSONDecoder().decode(Client.self, from: data)
                    completion(.success(newClient))
                } catch {
                    print("JSON Decoding Error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    // Update an existing client
    func updateClient(clientId: String, client: Client, completion: @escaping (Result<Client, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(clientId)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        let encoder = JSONEncoder()
        guard let jsonData = try? encoder.encode(client) else {
            completion(.failure(NSError(domain: "Encoding error", code: -3, userInfo: nil)))
            return
        }

        var request = NetworkHelper.createRequest(url: url, method: "PUT", body: jsonData, requiresAuth: true)

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
                    let updatedClient = try JSONDecoder().decode(Client.self, from: data)
                    completion(.success(updatedClient))
                } catch {
                    print("JSON Decoding Error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    // Delete a client by ID
    func deleteClient(clientId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(clientId)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        let request = NetworkHelper.createRequest(url: url, method: "DELETE", requiresAuth: true)

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
