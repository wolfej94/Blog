//
//  iOSApp.swift
//  iOS
//
//  Created by James Wolfe on 16/07/2023.
//

import SwiftUI

@main
struct iOSApp: App {
    
    // MARK: - Variables
    @StateObject var auth = AuthObserver.shared
    
    // MARK: - Views
    var body: some Scene {
        WindowGroup {
            if auth.token == nil {
                LoginView()
            } else {
                EmptyView()
            }
        }
    }
}
