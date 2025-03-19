import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var loginError: String?
    @Published var authToken: String?
    @Published var managerId: String?
    @Published var storeId: String?
    @Published var firstName: String?
    @Published var lastName: String?
    @Published var isAdmin: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var shouldNavigateToHome: Bool = false

    private let baseURL = "https://ahoui-back.cluster-ig4.igpolytech.fr"

    /// 🔹 Login Function
    func login() {
        print("🔑 Logging in with email:", email)
        isLoading = true
        loginError = nil

        guard let url = URL(string: "\(baseURL)/auth/login") else {
            isLoading = false
            loginError = "URL invalide"
            return
        }

        let requestData = ["email": email, "password": password]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestData) else {
            isLoading = false
            loginError = "Erreur lors de la préparation des données"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    print("❌ Erreur de requête : \(error.localizedDescription)")
                    self.loginError = "Erreur de connexion au serveur"
                    return
                }

                guard let data = data else {
                    print("❌ Aucune donnée reçue")
                    self.loginError = "Aucune réponse du serveur"
                    return
                }

                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📩 Réponse brute du serveur : \(responseString)")
                }

                guard let responseDict = json as? [String: Any],
                      let token = responseDict["token"] as? String else {
                    print("🚨 API Response:", json ?? "Invalid JSON")
                    self.loginError = "Email ou mot de passe incorrect"
                    return
                }

                // ✅ Decode JWT Token to Get Manager ID
                if let managerId = self.decodeJWT(token: token) {
                    self.authToken = token
                    self.managerId = managerId
                    self.isAuthenticated = true
                    self.fetchManagerProfile(token: token) // Fetch additional data
                } else {
                    print("❌ Impossible de décoder le JWT")
                    self.loginError = "Erreur d'authentification"
                }
            }
        }.resume()
    }

    /// 🔹 Fetch Manager Profile After Login
    func fetchManagerProfile(token: String) {
        guard let url = URL(string: "\(baseURL)/manager/profile") else {
            print("❌ Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("❌ Error fetching profile: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("❌ No data received")
                return
            }

            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseString = String(data: data, encoding: .utf8) {
                print("📩 Server Response (Profile): \(responseString)")
            }

            guard let responseDict = json as? [String: Any],
                  let managerId = responseDict["id"] as? String else {
                print("🚨 API Response (Profile) is invalid:", json ?? "No JSON received")
                return
            }

            DispatchQueue.main.async {
                self.managerId = managerId
                self.firstName = responseDict["firstName"] as? String
                self.lastName = responseDict["lastName"] as? String
                self.isAdmin = responseDict["admin"] as? Bool ?? true
                self.storeId = responseDict["storeId"] as? String

                print("✅ Manager Info: \(self.firstName ?? "") \(self.lastName ?? ""), Admin: \(self.isAdmin)")
            }
        }.resume()
    }



    /// 🔹 Decode JWT Token to Extract Manager ID
    func decodeJWT(token: String) -> String? {
        let parts = token.split(separator: ".")
        guard parts.count == 3 else {
            print("❌ JWT structure is invalid")
            return nil
        }

        var payload = String(parts[1])

        payload = payload.replacingOccurrences(of: "-", with: "+")
                         .replacingOccurrences(of: "_", with: "/")

        while payload.count % 4 != 0 {
            payload += "="
        }

        guard let payloadData = Data(base64Encoded: payload) else {
            print("❌ Failed to decode Base64 JWT payload")
            return nil
        }

        do {
            let jsonObject = try JSONSerialization.jsonObject(with: payloadData, options: [])
            if let payloadDict = jsonObject as? [String: Any], let managerId = payloadDict["id"] as? String {
                print("✅ Extracted Manager ID from JWT: \(managerId)")

                // ✅ Stocke dans UserDefaults et met à jour `shouldNavigateToHome`
                DispatchQueue.main.async {
                    self.managerId = managerId
                    UserDefaults.standard.set(managerId, forKey: "managerId")
                    self.shouldNavigateToHome = true  // ✅ Active la navigation
                    print("🔄 shouldNavigateToHome is set to TRUE ✅")
                }
                return managerId
            } else {
                print("🚨 JWT Payload Invalid:", jsonObject)
            }
        } catch {
            print("❌ Error parsing JWT JSON:", error.localizedDescription)
        }

        return nil
    }


    /// 🔹 Logout Function
    func logout() {
        self.authToken = nil
        self.managerId = nil
        self.storeId = nil
        self.firstName = nil
        self.lastName = nil
        self.isAdmin = false
        self.isAuthenticated = false
        self.shouldNavigateToHome = false
        
        // 🔹 Supprimer le managerId de UserDefaults
        UserDefaults.standard.removeObject(forKey: "managerId")
    }
}
