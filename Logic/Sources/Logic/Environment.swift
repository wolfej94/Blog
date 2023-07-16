//
//  File.swift
//  
//
//  Created by James Wolfe on 16/07/2023.
//

import Foundation

public enum Environment {
    
    // MARK: - Cases
    case develop
    case staging
    case live
    
    // MARK: Variables
    var url: URL {
        switch self {
        case .develop:
            return .init(string: "http://127.0.0.1:8080/")!
        case .staging:
            return .init(string: "http://127.0.0.1:8080/")!
        case .live:
            return .init(string: "http://127.0.0.1:8080/")!
        }
    }
}
