//
//  File.swift
//  
//
//  Created by James Wolfe on 16/07/2023.
//

import Foundation

struct LoginResponse: Codable {
    
    // MARK: - Variables
    let token: String
    
    // MARK: - Coding Keys
    private enum CodingKeys: String, CodingKey {
        case token = "value"
    }
}
