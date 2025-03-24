import Foundation

/// A helper utility to centralize network request creation.
/// Used across all services to avoid duplication and ensure consistent header configuration.
struct NetworkHelper {
    
    /// Retrieves the authentication token stored in UserDefaults.
    /// This token is set after a successful login and is required for authenticated requests.
    static var bearerToken: String? {
        return UserDefaults.standard.string(forKey: "token")
    }

    /// Function to create an authenticated request
    static func createRequest(url: URL, method: String, body: Data? = nil, requiresAuth: Bool = false) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Add Authorization header if required and token is available
        if requiresAuth, let token = bearerToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        request.httpBody = body
        return request
    }
}
