//
//  NavigationViewModel.swift
//  ahoui-ios
//
//  Created by etud on 19/03/2025.
//

import SwiftUI

class NavigationViewModel: ObservableObject {
    @Published var shouldNavigateToSellerList = false
    @Published var shouldNavigateToDepositedGames = false
    @Published var shouldNavigateToCart = false
}
