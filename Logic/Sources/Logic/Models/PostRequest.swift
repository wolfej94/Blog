//
//  PostRequest.swift
//  
//
//  Created by James Wolfe on 16/07/2023.
//

import Foundation

public final class PostRequest: NSObject, Codable {
    
    // MARK: - Variables
    public var title: String
    public var body: String
    
    // MARK: - Initializers
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
}
