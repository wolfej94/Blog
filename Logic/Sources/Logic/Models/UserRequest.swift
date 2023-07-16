//
//  UserRequest.swift
//  
//
//  Created by James Wolfe on 16/07/2023.
//

import Foundation

public final class UserRequest: NSObject, Codable {
    
    // MARK: - Variables
    public var name: String
    public var email: String
    public var password: String
    public var confirmPassword: String
    
    // MARK: - Initializers
    public init(name: String, email: String, password: String, confirmPassword: String) {
        self.name = name
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
    }
}
