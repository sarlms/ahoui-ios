//
//  GameDescription.swift
//  ahoui-ios
//
//  Created by etud on 20/03/2025.
//

import Foundation

class GameDescriptionService {
    private let baseURL = "https://ahoui-back.cluster-ig4.igpolytech.fr/gameDescription"

    func fetchAllGames(completion: @escaping (Result<[GameDescription], Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "URL invalide", code: -1, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "Données vides", code: -2, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let games = try decoder.decode([GameDescription].self, from: data)
                completion(.success(games))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchGameByName(name: String, completion: @escaping (Result<GameDescription, Error>) -> Void) {
        let formattedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
        guard let url = URL(string: "\(baseURL)/name/\(formattedName)") else {
            completion(.failure(NSError(domain: "URL invalide", code: -1, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "Données vides", code: -2, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let game = try decoder.decode(GameDescription.self, from: data)
                completion(.success(game))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

