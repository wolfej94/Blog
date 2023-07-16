//
//  PostResponse.swift
//  
//
//  Created by James Wolfe on 16/07/2023.
//

import Foundation

public final class PostResponse: NSObject, Codable {
    
    // MARK: - Variables
    public let id: UUID
    public let title: String
    public let body: String
    public let createdAt: Date
    
    // MARK: - Initializers
    public init(id: UUID, title: String, body: String, createdAt: Date) {
        self.id = id
        self.title = title
        self.body = body
        self.createdAt = createdAt
    }
}
