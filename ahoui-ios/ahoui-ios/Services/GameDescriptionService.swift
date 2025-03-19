//
//  GameDescriptionService.swift
//  
//
//  Created by etud on 19/03/2025.
//

import Foundation

class GameDescriptionService {
    private let baseURL = "https://ahoui-back.cluster-ig4.igpolytech.fr/gameDescription"

    func fetchGameDescription(byId id: String, completion: @escaping (Result<DepositedGameDescriptionInfo, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
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
                    let gameDescription = try JSONDecoder().decode(DepositedGameDescriptionInfo.self, from: data)
                    completion(.success(gameDescription))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
