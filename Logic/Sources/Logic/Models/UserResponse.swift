//
//  UserResponse.swift
//
//
//  Created by James Wolfe on 16/07/2023.
//

import Foundation

public final class UserResponse: NSObject, Codable {
    
    // MARK: - Variables
    public let id: UUID
    public let name: String
    public let email: String
    
    // MARK: - Initializers
    public init(id: UUID, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}
