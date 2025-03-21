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
}

class DepositFeePaymentService {
    private let baseURL = "https://ahoui-back.cluster-ig4.igpolytech.fr/depositFeePayment"

    func createPayment(payment: DepositFeePaymentRequest, token: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        guard let jsonData = try? JSONEncoder().encode(payment) else {
            completion(.failure(NSError(domain: "Encoding error", code: -2)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }.resume()
    }
}
