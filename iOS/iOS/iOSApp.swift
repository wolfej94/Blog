//
//  iOSApp.swift
//  iOS
//
//  Created by James Wolfe on 16/07/2023.
//

import SwiftUI
import Logic

@main
struct iOSApp: App {
    
    // MARK: - Variables
    @StateObject var auth = AuthObserver.shared
    private let logic = Logic(
        environment: .develop,
        token: { AuthObserver.shared.token }
    )
    
    // MARK: - Views
    var body: some Scene {
        WindowGroup {
            if auth.token == nil {
                NavigationView {
                    LoginView()
                        .environmentObject(logic)
                }
            } else {
                MainView()
                    .environmentObject(logic)
            }
        }
    }
}

extension Logic: ObservableObject { }
