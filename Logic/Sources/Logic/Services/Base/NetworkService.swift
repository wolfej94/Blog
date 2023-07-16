//
//  NetworkService.swift
//  
//
//  Created by James Wolfe on 16/07/2023.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

public class NetworkService {
    
    // MARK: - Variables
    internal let url: URL
    internal let token: () -> String?
    
    // MARK: - Initialziers
    internal init(url: URL, token: @escaping () -> String?) {
        self.url = url
        self.token = token
    }
    
    // MARK: - Actions
    
    public func request<T: Decodable>(
        url: URL,
        headers: [String: String] = [:],
        body: Data? = nil,
        query: [URLQueryItem] = [],
        method: HTTPMethod,
        decoder: JSONDecoder = .init()
    ) async throws -> T {
        // Build URL with query if necessary
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = query
        let url = components.url!
        
        // Apply method and body
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        // Apply bearer token authorization header
        if let token = token() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Apply headers
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Make request
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: request) { data, response, error in
                do {
                    guard error == nil, let data = data else { throw error ?? "Invalid Response" }
                    if let error = try? decoder.decode(ErrorResponse.self, from: data) {
                        continuation.resume(throwing: error)
                    } else {
                        try continuation.resume(returning: decoder.decode(T.self, from: data))
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }.resume()
        }
    }
    
    public func request(
        url: URL,
        headers: [String: String] = [:],
        body: Data? = nil,
        query: [URLQueryItem] = [],
        method: HTTPMethod,
        decoder: JSONDecoder = .init()
    ) async throws {
        // Build URL with query if necessary
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = query
        let url = components.url!
        
        // Apply method and body
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        // Apply bearer token authorization header
        if let token = token() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Apply headers
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Make request
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: request) { data, response, error in
                do {
                    guard error == nil, let data = data else { throw error ?? "Invalid Response" }
                    if let error = try? decoder.decode(ErrorResponse.self, from: data) {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume()
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }.resume()
        }
    }
    
}
