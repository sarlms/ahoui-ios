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

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(authViewModel)
                .environmentObject(sellerViewModel)
                .environmentObject(sessionViewModel)
        }
    }
}
