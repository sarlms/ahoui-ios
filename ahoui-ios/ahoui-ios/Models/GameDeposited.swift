//
//  GameDeposited.swift
//  ahoui-ios
//
//  Created by etud on 21/03/2025.
//

import Foundation

struct GameDeposited: Identifiable {
    let id = UUID()
    var name: String = ""
    var salePrice: String = "0"
    var isForSale: Bool = false
}
