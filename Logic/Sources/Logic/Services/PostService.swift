//
//  PostService.swift
//  
//
//  Created by James Wolfe on 16/07/2023.
//

import Foundation

public class PostService: NetworkService {
    
    public func create(request: PostRequest) async throws -> PostResponse {
        let response: PostResponse = try await self.request(
            url: url.appendingPathComponent("posts"),
            body: JSONEncoder().encode(request),
            method: .post
        )
        return response
    }
    
    public func posts() async throws -> [PostResponse] {
        return try await self.request(
            url: url.appendingPathComponent("posts"),
            method: .get
        )
    }
    
    public func user(for id: UUID) async throws -> UserResponse {
        return try await self.request(
            url: url.appendingPathComponent("posts/\(id.uuidString)"),
            method: .get
        )
    }
    
    public func delete(for id: UUID) async throws {
        return try await self.request(
            url: url.appendingPathComponent("posts/\(id.uuidString)"),
            method: .delete
        )
    }
    
}
