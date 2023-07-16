//
//  Logic.swift
//  
//
//  Created by James Wolfe on 16/07/2023.
//

import Foundation

public class Logic {
    
    // MARK: - Variables
    private let environment: Environment
    private let token: () -> String?
    
    public lazy var auth: AuthService = {
        return .init(url: environment.url, token: token)
    }()
    
    // MARK: - Initializers
    public init(environment: Environment, token: @escaping () -> String?) {
        self.environment = environment
        self.token = token
    }
    
}
