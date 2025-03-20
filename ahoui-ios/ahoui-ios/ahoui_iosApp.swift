//
//  ahoui_iosApp.swift
//  ahoui-ios
//
//  Created by etud on 12/03/2025.
//

import SwiftUI

@main
struct ahoui_iosApp: App {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var sellerViewModel = SellerViewModel()
    @StateObject var sessionViewModel = SessionViewModel()
    @StateObject var navigationViewModel = NavigationViewModel()
    @StateObject private var clientViewModel = ClientViewModel(service: ClientService())

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(authViewModel)
                .environmentObject(sellerViewModel)
                .environmentObject(sessionViewModel)
                .environmentObject(navigationViewModel)
                .environmentObject(clientViewModel)
        }
    }
}
