import Foundation

class ManagerViewModel: ObservableObject {
    @Published var managers: [Manager] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let baseURL = "https://ahoui-back.cluster-ig4.igpolytech.fr/manager" // ✅ Replace with actual API URL
    private let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MjRkZGQ2MzVlNzZiMmU1OTUzZjk0NCIsImVtYWlsIjoic2FyYWhAZ21haWwuY29tIiwiaWF0IjoxNzQxODU3NzgxLCJleHAiOjE3NDE4NjA3ODF9.Y-h-k_WxwMl2PVrr360tW2fzovNleTEMQZD9u8tL3aw" // ✅ Use a real token

    /// Fetch managers from the API
    func fetchManagers() async {
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        DispatchQueue.main.async {
            self.isLoading = true
        }
        defer {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else { return }

            if httpResponse.statusCode == 200 {
                // ✅ Debugging: Print raw JSON response
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("🔹 Server Response: \(jsonString)")
                }

                // ✅ Decode JSON
                let decodedManagers = try JSONDecoder().decode([Manager].self, from: data)
                
                await MainActor.run {
                    self.managers = decodedManagers
                    print("✅ Successfully fetched \(self.managers.count) managers.")
                }
            } else {
                await MainActor.run {
                    print("⚠️ Error: Server returned \(httpResponse.statusCode)")
                    self.errorMessage = "Error fetching managers: \(httpResponse.statusCode)"
                }
            }
        } catch {
            await MainActor.run {
                print("❌ Decoding error: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
            }
        }
    }


    /// Create a new manager
    func createManager(_ manager: Manager) async {
        guard let url = URL(string: "\(baseURL)/create") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(manager)
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 201 {
                    print("✅ Manager created successfully!")

                    // ✅ Fetch managers on the main thread after creation
                    DispatchQueue.main.async {
                        Task {
                            await self.fetchManagers()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print("⚠️ Error creating manager: \(httpResponse.statusCode)")
                        self.errorMessage = "Error creating manager: \(httpResponse.statusCode)"
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                print("❌ Error creating manager: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
            }
        }
    }

}
