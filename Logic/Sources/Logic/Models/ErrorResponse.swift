//
//  ErrorResponse.swift
//  
//
//  Created by James Wolfe on 16/07/2023.
//

import Foundation

struct ErrorResponse: LocalizedError, Decodable {
    
    // MARK: - Variables
    let error: Bool
    let reason: String
    
    var errorDescription: String? { return reason }
}

