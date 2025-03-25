import Foundation

class ManagerService {
    
    private let baseURL = "https://ahoui-back.cluster-ig4.igpolytech.fr/manager"
    
    /// GET request to fetch all managers
    func fetchManagers() async throws -> [Manager] {
        guard let url = URL(string: baseURL) else { throw URLError(.badURL) }
        let request = try NetworkHelper.createRequest(url: url, method: "GET", requiresAuth: true)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([Manager].self, from: data)
    }

    /// POST request to create a new manager
    func createManager(_ manager: CreateManager) async throws {
        guard let url = URL(string: "\(baseURL)/create") else { throw URLError(.badURL) }
        let jsonData = try JSONEncoder().encode(manager)
        let request = try NetworkHelper.createRequest(url: url, method: "POST", body: jsonData, requiresAuth: true)

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
    }

    /// PUT request to update a manager by id
    func updateManager(id: String, updatedManager: UpdateManager) async throws {
        guard let url = URL(string: "\(baseURL)/\(id)") else { throw URLError(.badURL) }
        let jsonData = try JSONEncoder().encode(updatedManager)
        let request = try NetworkHelper.createRequest(url: url, method: "PUT", body: jsonData, requiresAuth: true)

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }

    /// DELETE request to delete a manager by id
    func deleteManager(id: String) async throws {
        guard let url = URL(string: "\(baseURL)/\(id)") else { throw URLError(.badURL) }
        let request = try NetworkHelper.createRequest(url: url, method: "DELETE", requiresAuth: true)

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}
