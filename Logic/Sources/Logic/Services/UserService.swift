//
//  UserService.swift
//  
//
//  Created by James Wolfe on 16/07/2023.
//

import Foundation

class UserService: NetworkService {

    public func users() async throws -> [UserResponse] {
        return try await self.request(
            url: url.appendingPathComponent("users"),
            method: .get
        )
    }
    
    public func user(for id: UUID) async throws -> UserResponse {
        return try await self.request(
            url: url.appendingPathComponent("users/\(id.uuidString)"),
            method: .get
        )
    }
    
    public func currentUser() async throws -> UserResponse {
        return try await self.request(
            url: url.appendingPathComponent("users/user"),
            method: .get
        )
    }
    
    public func delete() async throws {
        return try await self.request(
            url: url.appendingPathComponent("users/user"),
            method: .delete
        )
    }
    
}
