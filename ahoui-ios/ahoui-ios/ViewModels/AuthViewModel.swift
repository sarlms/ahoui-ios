import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var loginError: String?
    @Published var authToken: String? {
        didSet {
            UserDefaults.standard.set(authToken, forKey: "authToken")
        }
    }
    @Published var managerId: String? {  // ✅ Store manager's ID
        didSet {
            UserDefaults.standard.set(managerId, forKey: "managerId")
        }
    }
    @Published var isAuthenticated: Bool = false
    @Published var shouldNavigateToHome: Bool = false

    private let baseURL = "https://ahoui-back.cluster-ig4.igpolytech.fr/auth"

    init() {
        self.authToken = UserDefaults.standard.string(forKey: "authToken")
        self.managerId = UserDefaults.standard.string(forKey: "managerId") // ✅ Retrieve manager ID on app start
        self.isAuthenticated = (authToken != nil)
    }

    func login() {
        isLoading = true
        loginError = nil

        guard let url = URL(string: "\(baseURL)/login") else {
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
                
                guard let data = data, error == nil,
                      let json = try? JSONSerialization.jsonObject(with: data, options: []),
                      let responseDict = json as? [String: Any],
                      let token = responseDict["token"] as? String,
                      let managerId = responseDict["id"] as? String else {  // ✅ Extract manager ID
                    self.loginError = "Email ou mot de passe incorrect"
                    return
                }

                self.authToken = token
                self.managerId = managerId // ✅ Store manager ID
                self.isAuthenticated = true
                self.shouldNavigateToHome = true
            }
        }.resume()
    }

    func logout() {
        self.authToken = nil
        self.managerId = nil
        self.isAuthenticated = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.shouldNavigateToHome = false
        }
    }
}
