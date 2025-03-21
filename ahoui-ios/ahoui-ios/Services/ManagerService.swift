import Foundation

class ManagerService {
    private let baseURL = "https://ahoui-back.cluster-ig4.igpolytech.fr/manager"
    private let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MjRkZGQ2MzVlNzZiMmU1OTUzZjk0NCIsImVtYWlsIjoic2FyYWhAZ21haWwuY29tIiwiaWF0IjoxNzQyNTUwMjk3LCJleHAiOjE3NDI1NTMyOTd9.ldr5S2yzUGCdPLvhvlUZMvaXfQUTpNSIzYLMHKIZDb0"

    /// Fetch managers from the API
    func fetchManagers() async throws -> [Manager] {
        guard let url = URL(string: baseURL) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([Manager].self, from: data)
    }

    /// Create a new manager
    func createManager(_ manager: CreateManager) async throws {
        print("manager: ", manager)
        guard let url = URL(string: "\(baseURL)/create") else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonData = try JSONEncoder().encode(manager)
        request.httpBody = jsonData

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
    }

    /// Update an existing manager
    func updateManager(id: String, updatedManager: UpdateManager) async throws {
        guard let url = URL(string: "\(baseURL)/\(id)") else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonData = try JSONEncoder().encode(updatedManager)
        request.httpBody = jsonData

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}
