//
//  AuthService.swift
//  
//
//  Created by James Wolfe on 16/07/2023.
//

import Foundation

public class AuthService: NetworkService {
    
    private func basic(for email: String, andPassword password: String) -> String {
        "Basic " + String(format: "%@:%@", email, password).data(using: .utf8)!.base64EncodedString()
    }
    
    @objc
    public func login(email: String, password: String) async throws -> String {
        let basic = basic(for: email, andPassword: password)
        let response: LoginResponse = try await self.request(
            url: url.appendingPathComponent("auth"),
            headers: ["Authorization": basic],
            method: .post
        )
        return response.token
    }
    
    @objc
    public func register(request: UserRequest) async throws -> String {
        let response: LoginResponse = try await self.request(
            url: url.appendingPathComponent("users"),
            body: JSONEncoder().encode(request),
            method: .post
        )
        return response.token
    }
    
}
