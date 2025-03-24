import Foundation

// this class prevents redeclaration of fetching the token and creating an authenticated request in all service files
struct NetworkHelper {
    
    // fetch the token from UserDefaults (stored when logged in)
    static var bearerToken: String? {
        return UserDefaults.standard.string(forKey: "token")
    }

    // Function to create an authenticated request
    static func createRequest(url: URL, method: String, body: Data? = nil, requiresAuth: Bool = false) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if requiresAuth, let token = bearerToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        request.httpBody = body
        return request
    }
}
