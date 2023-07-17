//
//  FeedView.swift
//  iOS
//
//  Created by James Wolfe on 16/07/2023.
//

import SwiftUI
import Logic

struct FeedView: View {
    
    // MARK: - Variables
    @State var state: UIState = .initial
    @EnvironmentObject var logic: Logic
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    FeedView()
        .environmentObject(
            Logic(
                environment: .develop,
                token: { AuthObserver.shared.token }
            )
        )
}
