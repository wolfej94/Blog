//
//  AuthObserver.swift
//  iOS
//
//  Created by James Wolfe on 16/07/2023.
//

import SwiftUI
import Valet

class AuthObserver: ObservableObject {
    
    // MARK: - Variables
    static let shared = AuthObserver()
    @Published var token: String? {
        didSet {
            if let token = token {
                try? secureEnclave.setString(token, forKey: "bearer")
            } else {
                try? secureEnclave.removeObject(forKey: "bearer")
            }
            
        }
    }
    
    private let secureEnclave = SecureEnclaveValet.valet(
        with: .init(nonEmpty: "com.wolfe.blog")!,
        accessControl: .userPresence
    )
    
    // MARK: - Initializers
    init() {
        token = try? secureEnclave.string(forKey: "bearer", withPrompt: "Just checking your identity")
    }
}
