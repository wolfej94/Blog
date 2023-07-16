//
//  UIState.swift
//  iOS
//
//  Created by James Wolfe on 16/07/2023.
//

import Foundation

enum UIState: Equatable {
    
    // MARK: - Cases
    case initial
    case loading
    case error(message: String)
    
    // MARK: - Variables
    var isError: Bool {
        switch self {
        case .error:
            return true
        case .initial, .loading:
            return false
        }
    }
}
