//
//  DepositFeePaymentService.swift
//  ahoui-ios
//
//  Created by etud on 21/03/2025.
//

import Foundation

struct DepositFeePaymentRequest: Codable {
    let sessionId: String
    let sellerId: String
    let depositFeePayed: Double
    let depositDate: String
}


class DepositFeePaymentService {
    private let baseURL = "https://ahoui-back.cluster-ig4.igpolytech.fr/depositFeePayment"

    func createPayment(payment: DepositFeePaymentRequest, token: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            print("❌ URL invalide : \(baseURL)")
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        guard let jsonData = try? JSONEncoder().encode(payment) else {
            print("❌ Erreur d'encodage JSON pour le paiement : \(payment)")
            completion(.failure(NSError(domain: "Encoding error", code: -2)))
            return
        }

        print("📤 Envoi du paiement JSON : \(String(data: jsonData, encoding: .utf8) ?? "Conversion failed")")
        print("🔐 TOKEN envoyé : \(token)")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Erreur lors de la requête de paiement : \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    if let httpResponse = response as? HTTPURLResponse {
                        print("📩 Code réponse HTTP : \(httpResponse.statusCode)")
                    }
                    completion(.success(()))
                }
            }
        }.resume()
    }
    
    // Fetch all deposit fee payments
    func fetchAllPayments(token: String, completion: @escaping (Result<[DepositFeePayment], Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: -2)))
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode([DepositFeePayment].self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

}
